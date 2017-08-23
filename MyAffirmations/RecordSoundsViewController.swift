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
    @IBOutlet weak var AffermationName: UITextField!
    @IBOutlet weak var affirmationTextViwer: UITextView!
    var audioRecorder: AVAudioRecorder!
    var selectedAffermation:Affermations?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        if ((selectedAffermation) != nil) {
            let htmlData = NSString(string: (selectedAffermation?.text)!).data(using: String.Encoding.unicode.rawValue)
            let attributedString = try! NSAttributedString(data: htmlData!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName:UIColor.black], documentAttributes: nil)
            affirmationTextViwer.attributedText = attributedString
        }else {
            print("Add Mode")
//            affirmationTextViwer.isEditable = true
            
        }
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
}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag)
        {
            // Add code that would save the recordedSound.wav files content to core data.
            //Once saved redirect to the listview with refresh command.
        } else {
            showAlertwith(title: "Recording Failed", message: "Please try again", vc: self)
        }
    }
}

