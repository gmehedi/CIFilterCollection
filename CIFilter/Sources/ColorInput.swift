//
//  ColorInput.swift
//  Cmg
//
//  Created by xxxAIRINxxx on 2016/02/20.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

public final class ColorInput: FilterInputable {
    
    public let key: String
    public fileprivate(set) var red: CGFloat = 0.0
    public fileprivate(set) var green: CGFloat = 0.0
    public fileprivate(set) var blue: CGFloat = 0.0
    public fileprivate(set) var alpha: CGFloat = 0.0
    
    fileprivate let initialValue: UIColor
    
    public init(filter: CIFilter, key: String) {
        self.key = key
        
        let attributes = filter.attributes[key] as? [String : AnyObject]
        let color = attributes?[kCIAttributeDefault] as? CIColor
        if let _color = color {
            self.red = _color.red * 255.0
            self.green = _color.green * 255.0
            self.blue = _color.blue * 255.0
            self.alpha = _color.alpha * 255
        }
        
        self.initialValue = UIColor(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
    }
    
    public func sliders() -> [Slider] {
        return [
          Slider("red", Range(0.0, 255.0, Float(self.red))) { [weak self] value in
                self?.red = CGFloat(value)
            },
          Slider("green", Range(0.0, 255.0, Float(self.green))) { [weak self] value in
                self?.green = CGFloat(value)
            },
          Slider("blue", Range(0.0, 255.0, Float(self.blue))) { [weak self] value in
                self?.blue = CGFloat(value)
            },
          Slider("alpha", Range(0.0, 255.0, Float(self.alpha))) { [weak self] value in
                self?.alpha = CGFloat(value)
            },
        ]
    }
    
    public func setInput(_ filter: CIFilter) {
        filter.setValue(CIColor(cgColor: self.rgbaCcolor.cgColor), forKey: self.key)
    }
    
    public func resetValue() {
        self.setColor(self.initialValue)
    }
}

extension ColorInput {
    
    public func setRed(_ red: CGFloat) {
        var v: CGFloat = red
        if v > 255.0 { v = 255.0 }
        if v < 0.0 { v = 0.0 }
        self.red = v
    }
    
    public func setGreen(_ green: CGFloat) {
        var v: CGFloat = green
        if v > 255.0 { v = 255.0 }
        if v < 0.0 { v = 0.0 }
        self.green = v
    }
    
    public func setBlue(_ blue: CGFloat) {
        var v: CGFloat = blue
        if v > 255.0 { v = 255.0 }
        if v < 0.0 { v = 0.0 }
        self.blue = v
    }
    
    public func setAlpha(_ alpha: CGFloat) {
        var v: CGFloat = alpha
        if v > 255.0 { v = 255.0 }
        if v < 0.0 { v = 0.0 }
        self.alpha = v
    }
    
    public func setColor(_ color: UIColor) {
        func zeroIfDodgy(_ value: CGFloat) -> CGFloat {
            return value.isNaN || value.isInfinite ? 0.0 : value
        }
        
        let colorRef = color.cgColor.components
        if color.cgColor.numberOfComponents == 4 {
            self.red = 255 * zeroIfDodgy((colorRef?[0])!)
            self.green = 255 * zeroIfDodgy((colorRef?[1])!)
            self.blue = 255 * zeroIfDodgy((colorRef?[2])!)
            self.alpha = 255 * zeroIfDodgy((colorRef?[3])!)
        } else if color.cgColor.numberOfComponents == 2 {
            let greyComponent = 255 * zeroIfDodgy((colorRef?[0])!)
            self.red = greyComponent
            self.green = greyComponent
            self.blue = greyComponent
            self.alpha = 255 * zeroIfDodgy((colorRef?[1])!)
        }
    }
    
    public var rgbaCcolor: UIColor {
        return UIColor(red: self.red / 255.0,
            green: self.green / 255.0,
            blue: self.blue / 255.0,
            alpha: self.alpha / 255.0
        )
    }
}
