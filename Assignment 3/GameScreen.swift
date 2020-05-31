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
    var optionAStoryArray = [""]
    var optionBStoryArray = [""]
    var altStoryArrayA = [""]
    var altStoryArrayB = [""]
    var textFileContent = ""
    var timeGateEventArrayA = [4, 8, 9] //can be any array
    var timeGateEventArrayB = [3, 6, 12] //can be any array
    var altStoryEventArray = [2, 14, 21] //set array as per main story
    var storyArrayNo = 0
    
    var breakoutMessageA = "Can't you be a little more patient?"
    var breakoutMessageB = "Is it time to get up already?"
    
    //player settings
    var playerName = "Unknown"
    var playerWeapon = "???"
    var goodEndCounter = 0
    var badEndCounter = 0
    
    //game save
    var storySavePoint = 0
    var currentStoryLine = ""
    var isSaveCalled = false
    
    @IBOutlet weak var gameStoryText: UILabel!
    @IBOutlet weak var option1Text: UIButton!
    @IBOutlet weak var option2Text: UIButton!
    @IBOutlet weak var breakoutOptionText: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.value(forKey: "playerName") == nil {
            loadDefaultData()
        }
        playerName = defaults.value(forKey: "playerName") as! String
        playerWeapon = defaults.value(forKey: "playerWeapon") as! String
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
        if storyArrayNo < mainStoryArray.count - 1 {
            if !timeGateEventArrayA.contains(storyArrayNo) && !altStoryEventArray.contains(storyArrayNo) {
                advanceStory()
            } else if timeGateEventArrayA.contains(storyArrayNo) {
                saveGame()
                timeBreakoutA()
            } else if altStoryEventArray.contains(storyArrayNo) {
                saveGame()
                alternateStoryline(buttonID: 1)
            }
        }
    }
    
    //button actions for 2nd player choice
    @IBAction func option2Button(_ sender: UIButton) {
        if storyArrayNo < mainStoryArray.count - 1{
            if !timeGateEventArrayB.contains(storyArrayNo) && !altStoryEventArray.contains(storyArrayNo) {
                advanceStory()
            } else if timeGateEventArrayB.contains(storyArrayNo) {
                saveGame()
                timeBreakoutB()
            } else if altStoryEventArray.contains(storyArrayNo) {
                saveGame()
                alternateStoryline(buttonID: 2)
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
    
    
    //loads story from files
    func loadTextFiles() {
        mainStoryArray = loadTextToArray(fileName: "mainStory")!
        optionAStoryArray = loadTextToArray(fileName: "optionsSideA")!
        optionBStoryArray = loadTextToArray(fileName: "optionsSideB")!
        altStoryArrayA = loadTextToArray(fileName: "alternateStoryLinesA")!
        altStoryArrayB = loadTextToArray(fileName: "alternateStoryLinesB")!
    }
    
    
    //initialises game
    func initGame() {
        gameStoryText.text = "First line of story."
        option1Text.setTitle("First option", for: [])
        option2Text.setTitle("Second option", for: [])
        breakoutOptionText.isHidden = true
        
        print(mainStoryArray)// testing line to check if output is correct
    }
    
    //loads default data if userdefaults does not exist
    func loadDefaultData() {
        if defaults.string(forKey: "playerName") == nil {
            defaults.set("Unknown", forKey: "playerName")
        }
        if defaults.string(forKey: "playerWeapon") == nil {
            defaults.set("Sword", forKey: "playerWeapon")
        }
    }
    
    //saves game
    func saveGame() {
        defaults.set(storyArrayNo, forKey: "savedStoryLineNo")
        defaults.set(gameStoryText.text, forKey: "currentLine")
        defaults.set(timeGateEventArrayA, forKey: "timeGateArray1")
        defaults.set(timeGateEventArrayB, forKey: "timeGateArray2")
        defaults.set(altStoryEventArray, forKey: "altStoryLineArray")
        defaults.set(goodEndCounter, forKey: "goodEndCounter")
        defaults.set(badEndCounter, forKey: "badEndCounter")
        storySavePoint = defaults.integer(forKey: "savedStoryLineNo")
        currentStoryLine = defaults.value(forKey: "currentLine") as! String
        print(storySavePoint) //testing line
    }
    
    
    //loads saved game
    func loadSave() {
        timeGateEventArrayA = defaults.array(forKey: "timeGateArray1") as! [Int]
        timeGateEventArrayB = defaults.array(forKey: "timeGateArray2") as! [Int]
        altStoryEventArray = defaults.array(forKey: "altStoryLineArray") as! [Int]
        goodEndCounter = defaults.integer(forKey: "goodEndCounter")
        badEndCounter = defaults.integer(forKey: "badEndCounter")
        storyArrayNo = storySavePoint
        breakoutOptionText.isHidden = true
        if timeGateEventArrayA.contains(storyArrayNo) {
            option1Text.isHidden = true
            option2Text.isHidden = true
            gameStoryText.text = self.breakoutMessageA
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.breakoutOptionText.isHidden = false
            }
            breakoutOptionText.setTitle("Did you find it?", for: [])
        } else if timeGateEventArrayB.contains(storyArrayNo) {
            option1Text.isHidden = true
            option2Text.isHidden = true
            gameStoryText.text = self.breakoutMessageB
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.breakoutOptionText.isHidden = false
            }
            breakoutOptionText.setTitle("Come on, wake up.", for: [])
        } else {
            gameStoryText.text = mainStoryArray[storyArrayNo]
            option1Text.setTitle(optionAStoryArray[storyArrayNo], for: [])
            option2Text.setTitle(optionBStoryArray[storyArrayNo], for: [])
            self.option2Text.sendActions(for: .touchUpInside)
        }
        isSaveCalled = true
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
        gameStoryText.text = mainStoryArray[storyArrayNo]
        option1Text.setTitle(optionAStoryArray[storyArrayNo], for: [])
        option2Text.setTitle(optionBStoryArray[storyArrayNo], for: [])
        storyArrayNo += 1
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
        timeGateEventArrayA.remove(at: 0)
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
        timeGateEventArrayB.remove(at: 0)
        saveGame()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.option2Text.sendActions(for: .touchUpInside)
        }
    }
    
    
    //alternate line event display
    func alternateStoryline(buttonID: Int) {
        option1Text.setTitle("", for: [])
        option2Text.setTitle("", for: [])
        altStoryEventArray.remove(at: 0)
        switch buttonID {
        case 1:
            gameStoryText.text = altStoryArrayA[0]
            goodEndCounter += 1
        case 2:
            gameStoryText.text = altStoryArrayB[0]
            badEndCounter += 1
        default: break
        }
        saveGame()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.option2Text.sendActions(for: .touchUpInside)
        }
    }
}
