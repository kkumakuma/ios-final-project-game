//
//  SettingsScreen.swift
//  Assignment 3
//
//  Created by kumakuma on 31/5/20.
//  Copyright © 2020 kumakuma. All rights reserved.
//

import UIKit

class SettingsScreen: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let defaults = UserDefaults.standard
    var weaponPickerData: [String] = [String]()
    var playerWeapon = ""
    var playerName = ""
    var bgmMuteStatus = false
    
    @IBOutlet weak var clearSettingsText: UIButton!
    @IBOutlet weak var weaponPickerScroll: UIPickerView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var muteBGMText: UIButton!
    
    @IBAction func muteBGMButton(_ sender: Any) {
        if bgmMuteStatus == false {
            defaults.set(true, forKey: "bgmMuteStatus")
            MusicPlayer.shared.muteBGM()
            muteBGMText.setTitle("Mute BGM", for: [])
            self.viewDidLoad()
        } else if bgmMuteStatus == true {
            defaults.set(false, forKey: "bgmMuteStatus")
            MusicPlayer.shared.unmuteBGM()
            muteBGMText.setTitle("Unmute BGM", for: [])
            self.viewDidLoad()
        }
    }
  
    @IBAction func saveSettings(_ sender: UIButton) {
        if nameInput.text != "" {
            defaults.set(nameInput.text, forKey: "playerName")
        }
        defaults.set(playerWeapon, forKey: "playerWeapon")
        defaults.synchronize()
        self.performSegue(withIdentifier: "settingsToTitle", sender: self)
    }
    
    @IBAction func clearSettings(_ sender: Any) {
        defaults.removeObject(forKey: "playerName")
        defaults.removeObject(forKey: "playerWeapon")
        defaults.set(false, forKey: "bgmMuteStatus")
        if defaults.bool(forKey: "bgmMuteStatus") == false {
            MusicPlayer.shared.unmuteBGM()
        }
        defaults.synchronize()
        self.performSegue(withIdentifier: "settingsToTitle", sender: self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weaponPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.text = weaponPickerData[row]
        pickerLabel.font = UIFont(name: "Courier New", size: 22)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        playerWeapon = weaponPickerData[row]
        defaults.set(weaponPickerData[row], forKey: "playerWeapon")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weaponPickerScroll.delegate = self
        self.weaponPickerScroll.dataSource = self
        
        weaponPickerData = ["Sword", "Shield"]
        
        loadSettings()
    }
    
    
    func loadSettings() {
        if defaults.integer(forKey: "savedStoryLineNo") != 0 {
            weaponPickerScroll.isUserInteractionEnabled = false
            clearSettingsText.isEnabled = false
            clearSettingsText.setTitleColor(UIColor.gray, for: .disabled)
        } else {
            weaponPickerScroll.isUserInteractionEnabled = true
        }
        
        if defaults.string(forKey: "playerName") != nil {
            playerName = defaults.string(forKey: "playerName") ?? "Unknown"
            nameInput.attributedPlaceholder = NSAttributedString(string: playerName, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        } else {
            playerName = "Unknown"
            nameInput.attributedPlaceholder = NSAttributedString(string: playerName, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
        
        if defaults.string(forKey: "playerWeapon") == "Shield" {
            weaponPickerScroll.selectRow(1, inComponent: 0, animated: false)
        } else {
            weaponPickerScroll.selectRow(0, inComponent: 0, animated: false)
        }
        
        bgmMuteStatus = defaults.bool(forKey: "bgmMuteStatus")
        if bgmMuteStatus == true {
            muteBGMText.setTitle("Unmute BGM", for: [])
        } else {
            muteBGMText.setTitle("Mute BGM", for: [])
        }
    }
}
