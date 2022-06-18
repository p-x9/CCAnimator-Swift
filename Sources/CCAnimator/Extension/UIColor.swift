//
//  UIColor.swift
//  PxUtil
//
//  Created by p-x9 on 2022/02/19.
//
//

import UIKit

extension UIColor {
    /// init with rgb color code
    /// - Parameter rgb: color code
    public convenience init(rgb: Int) {
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat( rgb & 0x0000FF       ) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /// init with rgba color code
    /// - Parameter rgba: color code
    public convenience init(rgba: Int) {
        let r = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let g = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let b = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let a = CGFloat( rgba & 0x000000FF       ) / 255.0
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    /// init with rgb color code
    /// - Parameter rgb: color code
    public convenience init(rgb code: String) {
        var color: UInt64 = 0
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        if Scanner(string: code.replacingOccurrences(of: "#", with: "")).scanHexInt64(&color) {
            r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            b = CGFloat( color & 0x0000FF       ) / 255.0
        }
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /// init with rgba color code
    /// - Parameter rgba: color code
    public convenience init(rgba code: String) {
        var color: UInt64 = 0
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 1.0
        let code = code.replacingOccurrences(of: "#", with: "")
        if Scanner(string: code).scanHexInt64(&color) {
            r = CGFloat((color & 0xFF000000) >> 24) / 255.0
            g = CGFloat((color & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((color & 0x0000FF00) >> 8) / 255.0
            a = CGFloat( color & 0x000000FF        ) / 255.0
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
}

extension UIColor {
    /// rgb color code
    public var rgbString: String {
        var red: CGFloat = -1
        var blue: CGFloat = -1
        var green: CGFloat = -1
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        let rgb: [CGFloat] = [red, green, blue]
        return rgb.reduce(into: "") { res, value in
            let intval = Int(round(value * 255))
            res += (NSString(format: "%02X", intval) as String)
        }
    }
    
    /// rgba color code
    public var rgbaString: String {
        var red: CGFloat = -1
        var blue: CGFloat = -1
        var green: CGFloat = -1
        var alpha: CGFloat = 1
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgba: [CGFloat] = [red, green, blue, alpha]
        return rgba.reduce(into: "") { res, value in
            let intval = Int(round(value * 255))
            res += (NSString(format: "%02X", intval) as String)
        }
    }
    
    /// rgb color code
    public var rgbInt: Int {
        var red: CGFloat = -1
        var blue: CGFloat = -1
        var green: CGFloat = -1
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        let rgb: [CGFloat] = [red, green, blue]
        
        let r = Int(rgb[0] * 255) << 16
        let g = Int(rgb[1] * 255) << 8
        let b = Int(rgb[2] * 255)
        
        return [r, g, b].reduce(0, +)
    }
    
    /// rgba color code
    public var rgbaInt: Int {
        var red: CGFloat = -1
        var blue: CGFloat = -1
        var green: CGFloat = -1
        var alpha: CGFloat = 1
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgba: [CGFloat] = [red, green, blue, alpha]
        
        let r = Int(rgba[0] * 255) << 24
        let g = Int(rgba[1] * 255) << 16
        let b = Int(rgba[2] * 255) << 8
        let a = Int(rgba[3] * 255)
        
        return [r, g, b, a].reduce(0, +)
    }
}

extension UIColor {
    
    /// red component
    public var redComponent: CGFloat {
        rgbaComponent(at: 0)
    }
    
    /// blue component
    public var blueComponent: CGFloat {
        rgbaComponent(at: 1)
    }
    
    /// green component
    public var greenComponent: CGFloat {
        rgbaComponent(at: 2)
    }
    
    /// alpha component
    public var alphaComponent: CGFloat {
        rgbaComponent(at: 3)
    }
    
    private func rgbaComponent(at index: Int) -> CGFloat {
        var red: CGFloat = -1
        var blue: CGFloat = -1
        var green: CGFloat = -1
        var alpha: CGFloat = 1
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgba: [CGFloat] = [red, green, blue, alpha]
        return rgba[index]
    }
}

extension UIColor {
    /// returns a new version of the current color with the specified red component.
    /// - Parameter red: red value
    /// - Returns: modified color
    public func withRedComponent(_ red: CGFloat) -> UIColor {
        withRGBComponent(at: 0, value: red)
    }
    
    /// returns a new version of the current color with the specified green component.
    /// - Parameter green: green value
    /// - Returns: modified color
    public func withGreenComponent(_ green: CGFloat) -> UIColor {
        withRGBComponent(at: 1, value: green)
    }
    
    /// returns a new version of the current color with the specified blue component.
    /// - Parameter blue: blue value
    /// - Returns: modified color
    public func withBlueComponent(_ blue: CGFloat) -> UIColor {
        withRGBComponent(at: 2, value: blue)
    }
    
    private func withRGBComponent(at index: Int, value: CGFloat) -> UIColor {
        var red: CGFloat = -1
        var blue: CGFloat = -1
        var green: CGFloat = -1
        var alpha: CGFloat = 1
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        var rgba: [CGFloat] = [red, green, blue, alpha]
        rgba[index] = (value > 1) ? 1 : ((value < 0) ? 0 : value)
        return UIColor(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])
    }
}
