//
//  UIColorContrastHelper.swift
//  Todoing
//
// Created by Kelhutch17 at https://github.com/kelhutch17/ColorContrast
//  Modified by McKenzie Macdonald on 9/21/22.
//

import Foundation
import UIKit

extension UIColor {
    
  static let minContrastRatio: CGFloat = 7.0
  
  /// Calculates the brightness of the receiver
  /// Returns nil if the color space of the receiver is not compatible
  func brightnessValue() -> CGFloat? {
    var h: CGFloat = 0
    var s: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
    if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
      return b
    }
    
    return nil
  }
  
  /// Returns an updated version of the receiver with an adjusted brightness component
  /// that ensures the receiver and otherColor meet the minContrastRatio
  func adjustedColorForBestContrast(withColor otherColor: UIColor) -> UIColor {
    guard let contrastRatio = self.contrastRatio(withColor: otherColor), contrastRatio < UIColor.minContrastRatio else {
      return self
    }
    
    guard let adjustedBrightness =
      self.brightnessToMeetMinContrast(withColor: otherColor) else {
        return self
    }
    return self.adjustedColor(withNewBrightness: adjustedBrightness)
  }
  
  /// Formula for calculating the contrast ratio of two colors is:
  /// (b1 + 0.05) / (b2 + 0.05)
  /// where b1 and b2 are the brightness values of two colors, and b1 > b2
  func contrastRatio(withColor otherColor: UIColor) -> CGFloat? {
    guard let b1 = self.brightnessValue(), let b2 = otherColor.brightnessValue() else {
      return nil
    }
    
    if b1 > b2 {
      return (b1 + 0.05) / (b2 + 0.05)
    } else {
      return (b2 + 0.05) / (b1 + 0.05)
    }
  }
  
  /// Returns the brightness value needed to adjust the receiver color to meet the minContrastRatio
  /// when compared to otherColor
  func brightnessToMeetMinContrast(withColor otherColor: UIColor) -> CGFloat? {
    guard let b1 = self.brightnessValue(), let b2 = otherColor.brightnessValue() else {
      return nil
    }
    
    if b1 > b2 {
      return UIColor.minContrastRatio * (b2 + 0.05) - 0.05
    } else {
      return ((b2 + 0.05) / UIColor.minContrastRatio) + 0.05
    }
  }
  
  /// Returns a copy of the receiver with the brightness component changed to be
  /// the passed in brightness value
  func adjustedColor(withNewBrightness brightness: CGFloat) -> UIColor {
    var h: CGFloat = 0
    var s: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
      return UIColor(hue: h, saturation: s, brightness: brightness, alpha: a)
    }
    return self;
  }
}
