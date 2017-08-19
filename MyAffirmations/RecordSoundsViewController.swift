//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Raxit Cholera on 5/31/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordinButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Recording Affermation"
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        setUIState(isRecording: true, recordingText: "Recording in progress")
        
        let recordedFileName = "recordedSound.wav"
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = NSURL.fileURL(withPathComponents: [directoryPath, recordedFileName])
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings:[:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    @IBAction func stopAudio(_ sender: Any) {
        setUIState(isRecording: false, recordingText: "Recording Stopped")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func setUIState(isRecording:Bool, recordingText:String){
        recordinButton.isEnabled = !isRecording
        stopButton.isEnabled = isRecording
        recordingLabel.text = recordingText
    }
   
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "stopRecording"){
//            let playSoundVC = segue.destination as! PlayBackViewController
//            let recordedAudioURL = sender as! NSURL
//            playSoundVC.audioUrl = recordedAudioURL
//        }
//    }
    
}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag)
        {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            let alert = UIAlertController(title: "Recording Failed", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

