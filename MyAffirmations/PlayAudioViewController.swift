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
    
    @IBOutlet weak var AffermationName: UILabel!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var StopButton: UIButton!
    var audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        AffermationName.text = selectedAffermation?.name

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        // initialize audio engine components
        let data = selectedAffermation!.audiofile
        do {
            audioPlayer = try AVAudioPlayer(data: data! as Data)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            configureUI(PlayingState.playing)
            
        } catch{
            //error message
            configureUI(PlayingState.notPlaying)
        }
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
    
    
}
