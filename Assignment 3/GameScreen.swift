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
    var timeGateArrayA = [4, 7, 12]
    var timeGateArrayB = [3, 8, 15]
    var alterStoryArray = [5, 14, 21]
    var i = 0
    
    @IBOutlet weak var gameTextLabel: UILabel!
    @IBOutlet weak var op1Text: UIButton!
    @IBOutlet weak var op2Text: UIButton!
    @IBOutlet weak var op3Text: UIButton!
    
    //button for 1st player choice
    @IBAction func op1Button(_ sender: UIButton) {
        if i < mainStoryArray.count - 1 {
            if !timeGateArrayA.contains(i) {
                gameTextLabel.text = mainStoryArray[i]
                op1Text.setTitle(opAArray[i], for: [])
                op2Text.setTitle(opBArray[i], for: [])
                i += 1
            } else if timeGateArrayA.contains(i) {
                    timeBreakoutA()
            } else if alterStoryArray.contains(i) {
                print("wahaha")
            }
        }
    }
    
    //button for 2nd player choice
    @IBAction func op2Button(_ sender: UIButton) {
        if i < mainStoryArray.count - 1{
            if !timeGateArrayB.contains(i) && !alterStoryArray.contains(i){
                gameTextLabel.text = mainStoryArray[i]
                op1Text.setTitle(opAArray[i], for: [])
                op2Text.setTitle(opBArray[i], for: [])
                i += 1
            } else if timeGateArrayB.contains(i) {
                timeBreakoutB()
            } else if alterStoryArray.contains(i) {
                print("ceebs")
            }
        }
    }
    
    //button used for time gated breakout events
    @IBAction func op3Button(_ sender: Any) {
        op1Text.setTitle("", for: [])
        op1Text.isHidden = false
        op2Text.setTitle("", for: [])
        op2Text.isHidden = false
        op3Text.isHidden = true
        if gameTextLabel.text == "Can't you be a little more patient?" {
            timeBreakoutA2()
        } else if gameTextLabel.text == "Is it time to get up already?" {
            timeBreakoutB2()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGame()
    }
    
    //opening setup
    func initGame() {
        mainStoryArray = loadTextToArray(fileName: "mainStory")!
        opAArray = loadTextToArray(fileName: "optionsSideA")!
        opBArray = loadTextToArray(fileName: "optionsSideB")!
        
        gameTextLabel.text = "Can you see me?"
        op1Text.setTitle("Yes", for: [])
        op2Text.setTitle("No", for: [])
        op3Text.isHidden = true
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
    
    
    //breakout interactions for time gated sequences on option A
    func timeBreakoutA() {
        op1Text.isHidden = true
        op2Text.isHidden = true
        gameTextLabel.text = "I'm looking for something. Brb."
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.gameTextLabel.text = "Can't you be a little more patient?"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.op3Text.isHidden = false
            }
        }
        op3Text.setTitle("Did you find it?", for: [])
    }
    func timeBreakoutA2() {
        gameTextLabel.text = "Yeah, I got it"
        timeGateArrayB.remove(at: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.op2Text.sendActions(for: .touchUpInside)
        }
    }
    
    //breakout interactions for time gated sequences on option B
    func timeBreakoutB() {
        op1Text.isHidden = true
        op2Text.isHidden = true
        gameTextLabel.text = "Gonna take a nap."
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.gameTextLabel.text = "Is it time to get up already?"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.op3Text.isHidden = false
            }
        }
        op3Text.setTitle("Come on, wake up.", for: [])
    }
    func timeBreakoutB2() {
        gameTextLabel.text = "Alright I'm up."
        timeGateArrayB.remove(at: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.op2Text.sendActions(for: .touchUpInside)
        }
    }
}
