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

    @IBOutlet weak var startGameButtonText: UIButton!
    @IBOutlet weak var clearSavesText: UIButton!
    
    
    //loads any saved game
    @IBAction func startGameButton(_ sender: UIButton) {
        print(defaults.integer(forKey: "savedStoryLineNo"))
        if defaults.integer(forKey: "savedStoryLineNo") != 0 {
            self.performSegue(withIdentifier: "loadGameSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "loadGameSegue", sender: self)
        }
    }
    

    //clears saves
    @IBAction func clearSaves(_ sender: UIButton) {
        let clearSavedGame = UIAlertController(title: "Are you sure you want to clear your saves?", message: "", preferredStyle: .alert)
        clearSavedGame.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            self.defaults.removeObject(forKey: "savedStoryLineNo")
            self.defaults.removeObject(forKey: "currentLine")
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
    }

}
