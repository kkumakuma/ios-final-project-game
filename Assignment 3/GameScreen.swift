//
//  GameScreen.swift
//  Assignment 3Tests
//
//  Created by kumakuma on 30/5/20.
//  Copyright © 2020 kumakuma. All rights reserved.
//

import UIKit

class GameScreen: UIViewController {
    
    var mainStoryArray = [""]
    var opAArray = [""]
    var opBArray = [""]
    var timeGateArray = [4, 7, 12]
    var i = 0
    
    @IBOutlet weak var gameTextLabel: UILabel!
    @IBOutlet weak var op1Text: UIButton!
    @IBOutlet weak var op2Text: UIButton!
    
    
    @IBAction func op1Button(_ sender: UIButton) {
        if i < mainStoryArray.count && !timeGateArray.contains(i){
            gameTextLabel.text = mainStoryArray[i]
            op1Text.setTitle(opAArray[i], for: [])
            op2Text.setTitle(opBArray[i], for: [])
            i += 1
        } else if timeGateArray.contains(i) {
            op1Text.isHidden = true
            op2Text.isHidden = true
            gameTextLabel.text = "I'm looking for something. Tell you when I find it."
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.op1Text.isHidden = false
                self.op2Text.isHidden = false
            }
            op1Text.setTitle(opAArray[i], for: [])
            op2Text.setTitle(opBArray[i], for: [])
            i += 1
        }
    }
    
    @IBAction func op2Button(_ sender: Any) {
        if i < mainStoryArray.count {
            gameTextLabel.text = mainStoryArray[i]
            op1Text.setTitle(opAArray[i], for: [])
            op2Text.setTitle(opBArray[i], for: [])
            i += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGame()
        
        mainStoryArray = loadTextToArray(fileName: "mainStory")!
        print(mainStoryArray)
        opAArray = loadTextToArray(fileName: "optionsSideA")!
        opBArray = loadTextToArray(fileName: "optionsSideB")!
    }
    
    //opening setup
    func initGame() {
        gameTextLabel.text = "Can you see me?"
        op1Text.setTitle("Yes", for: [])
        op2Text.setTitle("No", for: [])
    }
    
    //loads story text into arrays
    func loadTextToArray(fileName: String) -> [String]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            return nil
        }
        do {
            let content = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
             print(content)
            return content.components(separatedBy: "\n")
        } catch {
            return nil
        }
    }
}
