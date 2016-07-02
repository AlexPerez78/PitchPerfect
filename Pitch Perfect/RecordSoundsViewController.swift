//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Alex Perez on 6/21/16.
//  Copyright © 2016 Alex Perez. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    
    override func viewDidLoad() { //When the screen first runs, it will execute this after viewDidAppear, setting stopRecordingButton to falsse
        super.viewDidLoad()
        stopRecordingButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //Handling the Audio saving onto the phones data folders
    @IBAction func recordAudio(sender: AnyObject) {
        print("Record Button Was Pressed")
        recordingLabel.text = "Recording In Progress"
        stopRecordingButton.enabled = true
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //Handles the recording to stop and setting the buttons to thier appropiate task
    @IBAction func stopRecording(sender: AnyObject) {
        print("Stop Button Recording Was Pressed")
        recordingLabel.text = "Tap To Record"
        recordButton.enabled = true
        stopRecordingButton.enabled = false
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //Is the first thing to execute in the background when the app first launches
    override func viewWillAppear(animated: Bool) {
        print("View Will Appear Called")
    }
    
    //Handles the segue for the audio that if it has finished to perform a self segue and enter the next view controller when the user stops record
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording")
        if(flag){ //returns a flag, and if true
          self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url) //return that the flag has passed and will perform segue
        }
        else{
            print("Saving of recording has failed") // if it has failed then we return to the console that it has failed
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") { //Check if it is the Segue that we want
            let playSoundsVC = segue.destinationViewController as!
                PlaySoundsViewController //ask question on this.
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL // recieves the recorded URL and ready for playback
        }
    }
}

