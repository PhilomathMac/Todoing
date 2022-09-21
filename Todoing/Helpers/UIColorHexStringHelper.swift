//
//  UIColorHexStringHelper.swift
//
//
//  Created by McKenzie Macdonald on 9/20/22.
//  Code improved from Bart Jacobs at https://cocoacasts.com/from-hex-to-uicolor-and-back-in-swift/

import Foundation
import UIKit

extension UIColor {
    
    // MARK: - Initialization From HexString
    convenience init?(hex: String) {
        
        // Sanitize string passed to initialization
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        // Declare helper variables
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        // Use scanner to scan for hexadecimal representation by passing in the rgb value by reference (&)
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        // Based on length of hexString, extract r,g,b,a
        switch length {
        case 6:
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        case 8:
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        default:
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    
    }
    
    //MARK: - HexString From UIColor
    var hexString: String? {
        return toHex()
    }
    
    func toHex() -> String? {
        // Extract color components using CGColor
        guard let components = cgColor.components, components.count >= 3 else { return nil }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let a = components.count >= 4 ? Float(components[3]) : Float(1.0)
        
        // Create HexString
        /*
         1. Define string format
            • % defines the format specifier
            • 02 defines the string length
            • l casts the value to an unsigned long
            • X prints the value in hexadecimal
         
         2. Multiply color component values by 255
         
         3. Convert to integer
         */
        if components.count >= 4 {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
