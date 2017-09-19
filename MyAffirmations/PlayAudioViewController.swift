//
//  PlayAudioViewController.swift
//  MyAffirmations
//
//  Created by Raxit Cholera on 8/21/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import AVFoundation

class PlayAudioViewController: UIViewController {
    
    var selectedAffermation:Affermations?
    
    @IBOutlet weak var TimeRemaining: UILabel!
    @IBOutlet weak var TimePlayed: UILabel!
    @IBOutlet weak var AffermationName: UILabel!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var audioTimeSlider: UISlider!
    @IBOutlet weak var StopButton: UIButton!
    var audioPlayer = AVAudioPlayer()
    var updater : CADisplayLink! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AffermationName.text = selectedAffermation?.name
        audioTimeSlider.minimumValue = 0
        audioTimeSlider.maximumValue = 100
        
    }
    
    @IBAction func PlayButtonPressed(_ sender:UIButton){
        playAudio()
    }
    
    @IBAction func stopButtonPressed(_ sender:UIButton){
        stopAudio()
    }
    
}


extension PlayAudioViewController: AVAudioPlayerDelegate {

    enum PlayingState { case playing, notPlaying }
    
    func stopAudio() {
        audioPlayer.stop()
        configureUI(PlayingState.notPlaying)
    }
    func playAudio() {

        let data = selectedAffermation!.audiofile
        do {
            audioPlayer = try AVAudioPlayer(data: data! as Data)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            configureUI(PlayingState.playing)
            
            updater = CADisplayLink(target: self, selector: #selector(PlayAudioViewController.trackAudio))
            updater.frameInterval = 1
            updater.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
            
        } catch{
            configureUI(PlayingState.notPlaying)
        }
        
    }
    
    func trackAudio() {
        audioTimeSlider.value = Float(audioPlayer.currentTime * 100.0 / audioPlayer.duration)
        TimePlayed.text = stringFromTimeInterval(interval: audioPlayer.currentTime) as String
        TimeRemaining.text = stringFromTimeInterval(interval: audioPlayer.duration - audioPlayer.currentTime) as String
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        configureUI(PlayingState.notPlaying)
    }
    
    func configureUI(_ playState: PlayingState) {
        switch(playState) {
        case .playing:
            StopButton.isHidden = false
            PlayButton.isHidden = true
            
        case .notPlaying:
            StopButton.isHidden = true
            PlayButton.isHidden = false
            
        }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let ti = NSInteger(interval)
        
//        let ms = Int((interval % 1) * 1000)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
    
}
