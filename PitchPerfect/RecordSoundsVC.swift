//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Ahmed Fathi on 8/19/16.
//  Copyright © 2016 company.com. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsVC: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var startRecordingBtn: UIButton!
    @IBOutlet weak var recordingLbl: UILabel!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stopRecordingBtn.enabled = false
        self.recordingLbl.text = "Tap to Record"
    }
    
    
    //MARK: IBActions
    
    @IBAction func startRecording(sender: AnyObject) {
        // configue the UI elements
        self.startRecordingBtn.enabled = false
        self.stopRecordingBtn.enabled = true
        self.recordingLbl.text = "Recording ..."
        
        // start recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        
        let pathArray = [dirPath, recordingName]
        
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // in order to record or playback audio we need audio session
        // the AVFoundation is just an abstraction above the audio hardware
        // since we have one audio hardware in our device then we have on audio session
        // so we grab it the the sharedInstance() method
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    
    @IBAction func stopRecording(sender: AnyObject) {
        // configue the UI elements
        self.startRecordingBtn.enabled = true
        self.stopRecordingBtn.enabled = false
        self.recordingLbl.text = "Tap to Record"
        
        // stop the recording
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecordingSegue") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsVC
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    
    //MARK: AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder: finished saving recording")
        
        // send the audio file path to the second view
        if (flag) {
            self.performSegueWithIdentifier("stopRecordingSegue", sender: audioRecorder.url)
        } else {
            print("Saving of recording failed!")
        }
        
    }
    
}

