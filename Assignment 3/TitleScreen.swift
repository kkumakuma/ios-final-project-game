//
//  TitleScreen.swift
//  Assignment 3
//
//  Created by kumakuma on 30/5/20.
//  Copyright © 2020 kumakuma. All rights reserved.
//

import UIKit

class TitleScreen: UIViewController {
    
    let defaults = UserDefaults.standard
    var playerName = "Unknown"
    
    @IBOutlet weak var startGameButtonText: UIButton!
    @IBOutlet weak var clearSavesText: UIButton!
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    
    
    //loads any saved game
    @IBAction func startGameButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "loadGameSegue", sender: self)
    }

    //clears saves
    @IBAction func clearSaves(_ sender: UIButton) {
        let clearSavedGame = UIAlertController(title: "Are you sure you want to forfeit your progress?", message: "This will clear everything, including any settings.", preferredStyle: .alert)
        clearSavedGame.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            self.defaults.removeObject(forKey: "savedStoryLineNo")
            self.defaults.removeObject(forKey: "currentLine")
            self.defaults.removeObject(forKey: "playerName")
            self.defaults.removeObject(forKey: "playerWeapon")
            self.defaults.set(false, forKey: "bgmMuteStatus")
            self.defaults.removeObject(forKey: "altStoryArrayA")
            self.defaults.removeObject(forKey: "altStoryArrayB")
            self.defaults.set(0, forKey: "goodEndCounter")
            self.defaults.set(0, forKey: "badEndCounter")
            if self.defaults.bool(forKey: "bgmMuteStatus") == false {
                MusicPlayer.shared.unmuteBGM()
            }
            self.viewDidLoad()
        }))
        clearSavedGame.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(clearSavedGame, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.integer(forKey: "savedStoryLineNo") != 0 {
            startGameButtonText.setTitle("Load Game", for: [])
        } else {
            startGameButtonText.setTitle("Start Game", for: [])
        }
        
        if defaults.string(forKey: "playerName") != nil {
            playerName = defaults.string(forKey: "playerName") ?? "Unknown"
            welcomeMessageLabel.text = "Welcome back, \(playerName)."
        } else {
            welcomeMessageLabel.text = " Terminal \(playerName)66-75"
        }
    }
}
