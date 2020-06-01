//
//  MusicPlayer.swift
//  Assignment 3
//
//  Created by kumakuma on 1/6/20.
//  Copyright © 2020 kumakuma. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer {
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    
    func startBGM(bgmFileName: String) {
        if let bundle = Bundle.main.path(forResource: bgmFileName, ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func muteBGM() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.setVolume(0, fadeDuration: 1)
    }
    
    func silenceBGM() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.setVolume(0, fadeDuration: 0)
    }
    
    func unmuteBGM() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.setVolume(1, fadeDuration: 3)
    }
}
