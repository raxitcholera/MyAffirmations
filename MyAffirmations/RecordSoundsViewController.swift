//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Raxit Cholera on 5/31/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordinButton: UIButton!
    @IBOutlet weak var AffermationName: UITextField!
    @IBOutlet weak var affirmationTextViwer: UITextView!
    var audioRecorder: AVAudioRecorder!
    var selectedAffermation:Affermations?
    var tempRecordingPath:URL?
    var isinEditingMode: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        AffermationName.delegate = self
        if ((selectedAffermation) != nil) {
            let htmlData = NSString(string: (selectedAffermation?.text)!).data(using: String.Encoding.unicode.rawValue)
            let attributedString = try! NSAttributedString(data: htmlData!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName:UIColor.black], documentAttributes: nil)
            affirmationTextViwer.attributedText = attributedString
            AffermationName.text = selectedAffermation?.name
            isinEditingMode = true
        }else {
            print("Add Mode")
//            affirmationTextViwer.isEditable = true
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Recording Affermation"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        if AffermationName.text != "" {
            
        
        setUIState(isRecording: true, recordingText: "Recording in progress")
        
        let recordedFileName = "recordedSound.wav"
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        tempRecordingPath = NSURL.fileURL(withPathComponents: [directoryPath, recordedFileName])
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: tempRecordingPath!, settings:[:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        } else {
            setUIState(isRecording: false, recordingText: "Please fill the name first")
        }
        
        
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
            do {
                var dictionary=[String:AnyObject]()
                dictionary["audiofile"] = try NSData(contentsOf: tempRecordingPath!, options: NSData.ReadingOptions())
                dictionary["name"] = AffermationName.text as AnyObject
                dictionary["text"] = " " as AnyObject
                dictionary["createdon"] = Date() as AnyObject
                if(isinEditingMode){
                CoreDataManager.sharedManager.updateAffermation(selectedAffermation: selectedAffermation!, dictionary: dictionary)
                } else {
                    CoreDataManager.sharedManager.addAffermation(dictionary: dictionary)
                }
                //Once saved redirect to the listview with refresh command.
                performOnMainthread {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
            catch{
                showAlertwith(title: "Recording Failed", message: "Please try again", vc: self)
            }
            
            
        } else {
            showAlertwith(title: "Recording Failed", message: "Please try again", vc: self)
        }
    }
}

