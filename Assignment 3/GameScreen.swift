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
    var buttonNo = 0
    
    //time events
    var breakoutMessageA = "I'm looking for something, Brb."
    var breakoutMessageB = "Gonna take a nap."
    var actionInProgressA = "Unknown is busy."
    var actionInProgressB = "Unknown is asleep."
    var breakoutPt2MessageA = "Can't you be a little more patient?"
    var breakoutPt2MessageB = "Is it time to get up already?"
    
    //player settings
    var playerName = "Unknown"
    var playerWeapon = "???"
    var goodEndCounter = 0
    var badEndCounter = 0
    
    //game save variables
    var storySavePoint = 0
    var currentStoryLine = ""
    
    @IBOutlet weak var gameStoryText: UILabel!
    @IBOutlet weak var option1Text: UIButton!
    @IBOutlet weak var option2Text: UIButton!
    @IBOutlet weak var breakoutOptionText: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTextFiles()
        loadData()
        if defaults.integer(forKey: "savedStoryLineNo") != 0 {
            loadSave()
        } else {
            initGame()
        }
    }
    
    //button actions for 1st player choice
    @IBAction func option1Button(_ sender: UIButton) {
        if storyArrayNo < mainStoryArray.count - 1 {
            if !timeGateEventArrayA.contains(storyArrayNo) && !altStoryEventArray.contains(storyArrayNo) {
                advanceStory()
            } else if timeGateEventArrayA.contains(storyArrayNo) {
                saveGame(buttonID: 1)
                timeBreakout(buttonID: 1)
            } else if altStoryEventArray.contains(storyArrayNo) {
                saveGame(buttonID: 1)
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
                saveGame(buttonID: 2)
                timeBreakout(buttonID: 2)
            } else if altStoryEventArray.contains(storyArrayNo) {
                saveGame(buttonID: 2)
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
        if gameStoryText.text == actionInProgressA {
            timeBreakoutPt2(buttonID: 1)
        } else if gameStoryText.text == actionInProgressB {
            timeBreakoutPt2(buttonID: 2)
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
    }
    
    //loads default data if userdefaults does not exist and stores in variables
    func loadData() {
        if defaults.string(forKey: "playerName") == nil {
            defaults.set("Unknown", forKey: "playerName")
        } else {
            playerName = defaults.value(forKey: "playerName") as! String
        }
        if defaults.string(forKey: "playerWeapon") == nil {
            defaults.set("Sword", forKey: "playerWeapon")
        } else {
            playerWeapon = defaults.value(forKey: "playerWeapon") as! String
        }
        storySavePoint = defaults.integer(forKey: "savedStoryLineNo")
        actionInProgressA = "\(playerName) is busy."
        actionInProgressB = "\(playerName) is asleep."
    }
    
    //saves game
    func saveGame(buttonID: Int) {
        defaults.set(storyArrayNo, forKey: "savedStoryLineNo")
        defaults.set(gameStoryText.text, forKey: "currentLine")
        defaults.set(timeGateEventArrayA, forKey: "timeGateArray1")
        defaults.set(timeGateEventArrayB, forKey: "timeGateArray2")
        defaults.set(altStoryEventArray, forKey: "altStoryLineArray")
        defaults.set(goodEndCounter, forKey: "goodEndCounter")
        defaults.set(badEndCounter, forKey: "badEndCounter")
        defaults.set(buttonNo, forKey: "buttonIdentifier")
        storySavePoint = defaults.integer(forKey: "savedStoryLineNo")
        currentStoryLine = defaults.value(forKey: "currentLine") as! String
        switch buttonID {
            case 1:
                buttonNo = 1
            case 2:
                buttonNo = 2
            default: break
        }
    }
    
    //loads saved game
    func loadSave() {
        timeGateEventArrayA = defaults.array(forKey: "timeGateArray1") as! [Int]
        timeGateEventArrayB = defaults.array(forKey: "timeGateArray2") as! [Int]
        altStoryEventArray = defaults.array(forKey: "altStoryLineArray") as! [Int]
        goodEndCounter = defaults.integer(forKey: "goodEndCounter")
        badEndCounter = defaults.integer(forKey: "badEndCounter")
        buttonNo = defaults.integer(forKey: "buttonIdentifier")
        print(defaults.integer(forKey: "buttonIdentifier"))
        storyArrayNo = storySavePoint
        breakoutOptionText.isHidden = true
        
        if timeGateEventArrayA.contains(storyArrayNo) || timeGateEventArrayB.contains(storyArrayNo) {
            option1Text.isHidden = true
            option2Text.isHidden = true
            self.gameStoryText.textColor = #colorLiteral(red: 0.2115378903, green: 0.5939850973, blue: 0.3091130621, alpha: 1)
            switch buttonNo {
                case 1:
                    gameStoryText.text = self.actionInProgressA
                case 2:
                    gameStoryText.text = self.actionInProgressB
                default: break
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.breakoutOptionText.isHidden = false
            }
            switch buttonNo {
                case 1:
                    breakoutOptionText.setTitle("Did you find it?", for: [])
                case 2:
                    breakoutOptionText.setTitle("Come on, wake up.", for: [])
                default: break
            }
        } else {
            setMainStoryLines()
            self.option2Text.sendActions(for: .touchUpInside)
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
            return textFileContent.components(separatedBy: "\n")
        } catch {
            return nil
        }
    }
    
    //advances story if no breakout points are hit
    func advanceStory() {
        setMainStoryLines()
        storyArrayNo += 1
    }
    
    //displays main story lines
    func setMainStoryLines() {
        gameStoryText.text = mainStoryArray[storyArrayNo]
        option1Text.setTitle(optionAStoryArray[storyArrayNo], for: [])
        option2Text.setTitle(optionBStoryArray[storyArrayNo], for: [])
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
            saveGame(buttonID: 1)
        case 2:
            gameStoryText.text = altStoryArrayB[0]
            badEndCounter += 1
            saveGame(buttonID: 2)
        default: break
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.option2Text.sendActions(for: .touchUpInside)
        }
    }

    // time gated interaction events
    func timeBreakout(buttonID: Int) {
        option1Text.isHidden = true
        option2Text.isHidden = true
        
        switch buttonID {
            case 1:
                gameStoryText.text = breakoutMessageA
            case 2:
                gameStoryText.text = breakoutMessageB
            default: break
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.gameStoryText.textColor = #colorLiteral(red: 0.2115378903, green: 0.5939850973, blue: 0.3091130621, alpha: 1)
            switch buttonID {
                case 1:
                    self.gameStoryText.text = self.actionInProgressA
                case 2:
                    self.gameStoryText.text = self.actionInProgressB
                default: break
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.gameStoryText.textColor = UIColor.systemTeal
            switch buttonID {
                case 1:
                    self.gameStoryText.text = self.breakoutPt2MessageA
                case 2:
                    self.gameStoryText.text = self.breakoutPt2MessageB
                default: break
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.breakoutOptionText.isHidden = false
            }
        }
        switch buttonID {
            case 1:
                breakoutOptionText.setTitle("Did you find it?", for: [])
            case 2:
                breakoutOptionText.setTitle("Come on, wake up.", for: [])
            default: break
        }
    }
    
    //time gated event part 2
    func timeBreakoutPt2(buttonID: Int) {
        self.gameStoryText.textColor = UIColor.systemTeal
        switch buttonID {
            case 1:
                gameStoryText.text = "Yeah, I got it"
                timeGateEventArrayA.remove(at: 0)
                saveGame(buttonID: 1)
            case 2:
                gameStoryText.text = "Alright I'm up."
                timeGateEventArrayB.remove(at: 0)
                saveGame(buttonID: 2)
            default: break
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.option2Text.sendActions(for: .touchUpInside)
        }
    }
}
