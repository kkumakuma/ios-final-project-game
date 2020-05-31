//
//  FontChange.swift
//  Assignment 3
//
//  Created by kumakuma on 1/6/20.
//  Copyright © 2020 kumakuma. All rights reserved.
//

import UIKit

extension UILabel {
    override open func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    func changeFontName() {
        self.font = UIFont(name: "Courier New", size: self.font.pointSize)
    }
}

extension UIButton {
    override open func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    func changeFontName() {
        self.titleLabel?.font = UIFont(name: "Courier New", size: (self.titleLabel?.font.pointSize)!)
    }
}

extension UITextField {
    override open func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    func changeFontName() {
        self.font = UIFont(name: "Courier New", size: (self.font?.pointSize)!)
    }
}

