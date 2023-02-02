//
//  Settings.swift
//  
//
//  Created by p-x9 on 2022/06/20.
//  
//

import UIKit
import CCAnimatorC

struct Settings: Codable {

    private enum CodingKeys: String, CodingKey {
        case isTweakEnabled
        case isCustomEnabled

        case itemTintColorCode
        case itemBackgroundColorCode
        case itemBorderColorCode
        case itemBorderWidth
        case itemCornerRadius

        case ccBackgroundColorCode
        case isCCBackgroundBlurEnabled

        case isAnimationEnabled
        case animationRawValue
        case isAnimationAutoReverseEnabled
        case animationDuration
        case animationInterval
    }

    var isTweakEnabled = true
    var isCustomEnabled = true

    var itemTintColorCode: String = "#FFFF9C"
    var itemBackgroundColorCode: String = "#D00090"
    var itemBorderColorCode: String = "#FFFFFF"
    var itemBorderWidth: CGFloat = 1
    var itemCornerRadius: CGFloat = 19

    var ccBackgroundColorCode: String = "#0000FF:0.50"
    var isCCBackgroundBlurEnabled: Bool = true

    var isAnimationEnabled: Bool = true
    var animationRawValue: Int = 0
    var isAnimationAutoReverseEnabled: Bool = true
    var animationDuration: TimeInterval = 1
    var animationInterval: TimeInterval = 10

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        isTweakEnabled = try container.decodeIfPresent(Bool.self, forKey: .isTweakEnabled) ?? true
        isCustomEnabled = try container.decodeIfPresent(Bool.self, forKey: .isCustomEnabled) ?? true

        itemTintColorCode = try container.decodeIfPresent(String.self, forKey: .itemTintColorCode) ?? "#FFFF9C"
        itemBackgroundColorCode = try container.decodeIfPresent(String.self, forKey: .itemBackgroundColorCode) ?? "#D00090"
        itemBorderColorCode = try container.decodeIfPresent(String.self, forKey: .itemBorderColorCode) ?? "#FFFFFF"
        itemBorderWidth = try container.decodeIfPresent(CGFloat.self, forKey: .itemBorderWidth) ?? 1
        itemCornerRadius = try container.decodeIfPresent(CGFloat.self, forKey: .itemCornerRadius) ?? 19

        ccBackgroundColorCode = try container.decodeIfPresent(String.self, forKey: .ccBackgroundColorCode) ?? "#0000FF:0.50"
        isCCBackgroundBlurEnabled = try container.decodeIfPresent(Bool.self, forKey: .isCCBackgroundBlurEnabled) ?? true

        isAnimationEnabled = try container.decodeIfPresent(Bool.self, forKey: .isAnimationEnabled) ?? true
        animationRawValue = try container.decodeIfPresent(Int.self, forKey: .animationRawValue) ?? 0
        isAnimationAutoReverseEnabled = try container.decodeIfPresent(Bool.self, forKey: .isAnimationAutoReverseEnabled) ?? false

        animationDuration = try container.decodeIfPresent(Double.self, forKey: .animationDuration) ?? 1
        animationInterval = try container.decodeIfPresent(Double.self, forKey: .animationInterval) ?? 10
    }
}

extension Settings {
    var itemTintColor: UIColor {
        SparkColourPickerUtils.colour(with: self.itemTintColorCode, withFallbackColour: .white)
    }

    var itemBackgroundColor: UIColor {
        SparkColourPickerUtils.colour(with: self.itemBackgroundColorCode, withFallbackColour: .blue)
    }

    var itemBorderColor: UIColor {
        SparkColourPickerUtils.colour(with: self.itemBorderColorCode, withFallbackColour: .white)
    }

    var ccBackgroundColor: UIColor {
        SparkColourPickerUtils.colour(with: self.ccBackgroundColorCode, withFallbackColour: .systemPink)
    }

    static let animations: [UIView.AnimationOptions] =
    [
        .transitionFlipFromLeft,
        .transitionFlipFromRight,
        .transitionFlipFromTop,
        .transitionFlipFromBottom,
        .transitionCurlUp,
        .transitionCurlDown,
        .transitionCrossDissolve
    ]

    var animation: UIView.AnimationOptions {
        if Self.animations.indices.contains(animationRawValue) {
            return Self.animations[animationRawValue]
        }
        return Self.animations[0]
    }
}
