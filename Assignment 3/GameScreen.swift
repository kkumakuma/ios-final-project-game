//
//  GameScreen.swift
//  Assignment 3Tests
//
//  Created by kumakuma on 30/5/20.
//  Copyright © 2020 kumakuma. All rights reserved.
//

import UIKit

class GameScreen: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var mainStoryArray = [""]
    var option1StoryArray = [""]
    var option2StoryArray = [""]
    var textFileContent = ""
    var timeGateEventArray1 = [4, 8, 9] //can be any array
    var timeGateEventArray2 = [3, 6, 12] //can be any array
    var alterStoryArray = [5, 14, 21] //can be any array
    var arrayNo = 0
    
    var breakoutMessageA = "Can't you be a little more patient?"
    var breakoutMessageB = "Is it time to get up already?"
    
    //player settings
    var playerName = "Doctor Doom" //will be read from userdefaults later
    var playerWeapon = "???"
    
    //game save
    var storySavePoint = 0
    var currentStoryLine = ""
    
    @IBOutlet weak var gameStoryText: UILabel!
    @IBOutlet weak var option1Text: UIButton!
    @IBOutlet weak var option2Text: UIButton!
    @IBOutlet weak var breakoutOptionText: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTextFiles()
        storySavePoint = defaults.integer(forKey: "savedStoryLineNo")
        if defaults.integer(forKey: "savedStoryLineNo") != 0 {
            loadSave()
        } else {
            initGame()
        }
        print(storySavePoint)
    }
    
    
    //button actions for 1st player choice
    @IBAction func option1Button(_ sender: UIButton) {
        if arrayNo < mainStoryArray.count - 1 {
            if !timeGateEventArray1.contains(arrayNo) && !alterStoryArray.contains(arrayNo) {
                advanceStory()
            } else if timeGateEventArray1.contains(arrayNo) {
                saveGame()
                timeBreakoutA()
            } else if alterStoryArray.contains(arrayNo) {
                print("wahaha")
            }
        }
    }
    
    //button actions for 2nd player choice
    @IBAction func option2Button(_ sender: UIButton) {
        if arrayNo < mainStoryArray.count - 1{
            if !timeGateEventArray2.contains(arrayNo) && !alterStoryArray.contains(arrayNo) {
                advanceStory()
            } else if timeGateEventArray2.contains(arrayNo) {
                saveGame()
                timeBreakoutB()
            } else if alterStoryArray.contains(arrayNo) {
                print("ceebs")
            }
        }
    }
    
    //button actions for time gated breakout events
    @IBAction func breakoutOptionButton(_ sender: UIButton) {
        option1Text.setTitle("", for: [])
        option1Text.isHidden = false
        option2Text.setTitle("", for: [])
        option2Text.isHidden = false
        breakoutOptionText.isHidden = true
        if gameStoryText.text == breakoutMessageA {
            timeBreakoutA2()
        } else if gameStoryText.text == breakoutMessageB {
            timeBreakoutB2()
        }
    }
    
    
    //opening setup
    func loadTextFiles() {
        mainStoryArray = loadTextToArray(fileName: "mainStory")!
        option1StoryArray = loadTextToArray(fileName: "optionsSideA")!
        option2StoryArray = loadTextToArray(fileName: "optionsSideB")!
    }
    
    func initGame() {
        gameStoryText.text = "Can you see me?"
        option1Text.setTitle("Yes", for: [])
        option2Text.setTitle("No", for: [])
        breakoutOptionText.isHidden = true
        
        print(mainStoryArray)// testing line to check if output is correct
    }
    
    //loads saved game
    func loadSave() {
        timeGateEventArray1 = defaults.array(forKey: "timeGateArray1") as! [Int]
        timeGateEventArray2 = defaults.array(forKey: "timeGateArray2") as! [Int]
        arrayNo = storySavePoint
        if timeGateEventArray1.contains(arrayNo) {
            option1Text.isHidden = true
            option2Text.isHidden = true
            gameStoryText.text = self.breakoutMessageA
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.breakoutOptionText.isHidden = false
            }
            breakoutOptionText.setTitle("Did you find it?", for: [])
        } else if timeGateEventArray2.contains(arrayNo) {
            option1Text.isHidden = true
            option2Text.isHidden = true
            gameStoryText.text = self.breakoutMessageB
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.breakoutOptionText.isHidden = false
            }
            breakoutOptionText.setTitle("Come on, wake up.", for: [])
        } else {
            gameStoryText.text = mainStoryArray[arrayNo]
            option1Text.setTitle(option1StoryArray[arrayNo], for: [])
            option2Text.setTitle(option2StoryArray[arrayNo], for: [])
        }
    }
    
    //loads player variables into story array
    func loadPlayerSettings() {
        textFileContent = textFileContent.replacingOccurrences(of: "playerName", with: "\(playerName)")
        textFileContent = textFileContent.replacingOccurrences(of: "playerWeapon", with: "\(playerWeapon)")
    }
    
    
    //loads story text from files into arrays
    func loadTextToArray(fileName: String) -> [String]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            return nil
        }
        do {
            textFileContent = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            loadPlayerSettings()
             print(textFileContent) //testing line to ensure contents are being parsed correctly
            return textFileContent.components(separatedBy: "\n")
        } catch {
            return nil
        }
    }
    
    
    //advances story if no breakout points are hit
    func advanceStory() {
        gameStoryText.text = mainStoryArray[arrayNo]
        option1Text.setTitle(option1StoryArray[arrayNo], for: [])
        option2Text.setTitle(option2StoryArray[arrayNo], for: [])
        arrayNo += 1
    }
    
    
    //breakout interactions for time gated sequences on option A
    func timeBreakoutA() {
        option1Text.isHidden = true
        option2Text.isHidden = true
        gameStoryText.text = "I'm looking for something. Brb."
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.gameStoryText.text = self.breakoutMessageA
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.breakoutOptionText.isHidden = false
            }
        }
        breakoutOptionText.setTitle("Did you find it?", for: [])
    }
    func timeBreakoutA2() {
        gameStoryText.text = "Yeah, I got it"
        timeGateEventArray1.remove(at: 0)
        saveGame()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.option2Text.sendActions(for: .touchUpInside)
        }
    }
    
    //breakout interactions for time gated sequences on option B
    func timeBreakoutB() {
        option1Text.isHidden = true
        option2Text.isHidden = true
        gameStoryText.text = "Gonna take a nap."
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.gameStoryText.text = self.breakoutMessageB
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.breakoutOptionText.isHidden = false
            }
        }
        breakoutOptionText.setTitle("Come on, wake up.", for: [])
    }
    func timeBreakoutB2() {
        gameStoryText.text = "Alright I'm up."
        timeGateEventArray2.remove(at: 0)
        saveGame()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.option2Text.sendActions(for: .touchUpInside)
        }
    }
    
    
    //game save
    func saveGame() {
        defaults.set(arrayNo, forKey: "savedStoryLineNo")
        defaults.set(gameStoryText.text, forKey: "currentLine")
        defaults.set(timeGateEventArray1, forKey: "timeGateArray1")
        defaults.set(timeGateEventArray2, forKey: "timeGateArray2")
        storySavePoint = defaults.integer(forKey: "savedStoryLineNo")
        currentStoryLine = defaults.value(forKey: "currentLine") as! String
        print(storySavePoint) //testing line
    }
}
