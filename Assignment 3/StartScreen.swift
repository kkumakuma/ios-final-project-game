//
//  StartScreen.swift
//  Assignment 3
//
//  Created by kumakuma on 31/5/20.
//  Copyright © 2020 kumakuma. All rights reserved.
//

import UIKit

class StartScreen: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var introTimer: Timer?
    var timeRemaining = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        introTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.transitionTime()
        }
    }

    @objc func transitionTime() {
        if (timeRemaining == 0) {
            introTimer!.invalidate()
            self.performSegue(withIdentifier: "toTitleScreen", sender: self)
        } else {
            timeRemaining -= 1
        }
    }
}
