//
//  Extensions.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation
import UIKit

// MARK: - UIColor

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let speerYellow = UIColor.rgb(red: 255, green: 229, blue: 172)
}

// MARK: - UIFont

extension UIFont {
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func mainFont(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "Poppins-Regular", size: size)
    }
    
    static func boldMainFont(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "Poppins-Bold", size: size)
    }
    
    static func lightMainFont(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "Poppins-Light", size: size)
    }
}
