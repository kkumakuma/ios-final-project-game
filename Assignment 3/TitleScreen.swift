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

    //loads any saved game
    @IBAction func loadGameButton(_ sender: Any) {
        print(defaults.integer(forKey: "savedStoryLineNo"))
        if defaults.integer(forKey: "savedStoryLineNo") != 0 {
            self.performSegue(withIdentifier: "loadGameSegue", sender: self)
        } else {
            let noSavedGame = UIAlertController(title: "Oops, there's no saved game", message: "", preferredStyle: .alert)
            noSavedGame.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(noSavedGame, animated: true)
        }
    }
    
    //clears saves
    @IBAction func clearSaves(_ sender: Any) {
        defaults.removeObject(forKey: "savedStoryLineNo")
        defaults.removeObject(forKey: "currentLine")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
