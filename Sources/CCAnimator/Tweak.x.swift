import Orion
import CCAnimatorC
import UIKit


struct Settings: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case isTweakEnabled
        case isCustomEnabled
        
        case itemTintColorCode
        case itemBackgroundColorCode
        case itemBorderColorCode
        case itemBorderWidth
        
        case ccBackgroundColorCode
        
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
    
    var ccBackgroundColorCode: String = "#0000FF:0.50"
    
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
        
        ccBackgroundColorCode = try container.decodeIfPresent(String.self, forKey: .ccBackgroundColorCode) ?? "#0000FF:0.50"
        
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

var localSettings = Settings()

let AnimationNotification = NSNotification.Name(rawValue: "com.p-x9.ccanimator.animation")

struct customTweak: HookGroup {}
struct animationTweak: HookGroup {}

class CCUIModularControlCenterOverlayViewController_Anim_Hook: ClassHook<CCUIModularControlCenterOverlayViewController> {
    
    typealias Group = animationTweak
    
    @Property(.atomic) var animationTimer: Timer? = nil
    
    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)
        
        guard localSettings.isAnimationEnabled else {
            return
        }
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: localSettings.animationInterval, repeats: true, block: { _ in
            NotificationCenter.default.post(name: AnimationNotification, object: self.target)
        })
    }
    
    func viewWillDisappear(_ animated: Bool) {
        orig.viewWillDisappear(animated)
        
        animationTimer?.invalidate()
    }
}

class CCUIContentModuleContentContainerView_Anim_Hook: ClassHook<CCUIContentModuleContentContainerView> {
    
    typealias Group = animationTweak
    
    func initWithFrame(_ frame: CGRect) -> UIControl {
        let target = orig.initWithFrame(frame)
        
        NotificationCenter.default.addObserver(forName: AnimationNotification, object: nil, queue: .main) { _ in
            self.target.animate()
        }
        
        return target
    }
    
    func deinitializer() -> DeinitPolicy {
        let policy = orig.deinitializer()
        
        NotificationCenter.default.removeObserver(target, name: AnimationNotification, object: nil)
        
        return policy
    }
    
    // orion:new
    @objc
    func animate() {
        guard localSettings.isAnimationEnabled else {
            return
        }
        
        var options: UIView.AnimationOptions = [localSettings.animation]
        if localSettings.isAnimationAutoReverseEnabled {
            options.insert(.autoreverse)
        }
        
        UIView.transition(with: target.superview!, duration: localSettings.animationDuration, options: options, animations: nil)
    }
}


// MARK: ControlCenter background
class CCUIModularControlCenterOverlayViewController_Hook: ClassHook<CCUIModularControlCenterOverlayViewController> {
    
    typealias Group = customTweak
    
    func viewWillDisappear(_ animated: Bool) {
        orig.viewWillDisappear(animated)
        
        target.view.layer.backgroundColor = nil
    }
    
    func updatePresentationWithLocation(_ point: CGPoint, translation: CGPoint, velocity: CGPoint) {
        let alpha = (1 - (point.y / target.view.frame.height)) * localSettings.ccBackgroundColor.alphaComponent
        let color = localSettings.ccBackgroundColor.withAlphaComponent(alpha)
        
        target.view.layer.backgroundColor = color.cgColor
        
        orig.updatePresentationWithLocation(point, translation: translation, velocity: velocity)
    }
    
    func endPresentationWithLocation(_ point: CGPoint, translation: CGPoint, velocity: CGPoint) {
        orig.endPresentationWithLocation(point, translation: translation, velocity: velocity)
    }
    
    func cancelPresentationWithLocation(_ point: CGPoint, translation: CGPoint, velocity: CGPoint) {
        orig.cancelPresentationWithLocation(point, translation: translation, velocity: velocity)
        
        target.view.backgroundColor = nil
    }
    
    func _dismissalPanGestureRecognizerChanged(_ sender: UIPanGestureRecognizer) {
        let translatedPoint = sender.translation(in: target.view)

        let alpha = (1 - (translatedPoint.y / target.view.frame.height)) * localSettings.ccBackgroundColor.alphaComponent
        let color = localSettings.ccBackgroundColor.withAlphaComponent(alpha)

        target.view.layer.backgroundColor = color.cgColor

        orig._dismissalPanGestureRecognizerChanged(sender)
    }
    
    func _handleDismissalTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        orig._handleDismissalTapGestureRecognizer(sender)
        
        target.view.layer.backgroundColor = nil
    }
    
    @objc(dismissAnimated:withCompletionHandler:)
    func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        orig.dismiss(animated: flag, completion: completion)
        
        target.view.layer.backgroundColor = nil
    }
    
    @objc(presentAnimated:withCompletionHandler:)
    func present(animated flag: Bool, completion: (() -> Void)?) {
        orig.present(animated: flag, completion: completion)
        
        target.view.backgroundColor = localSettings.ccBackgroundColor
    }
}


// MARK: Item Background
class CCUIContentModuleContentContainerView_Hook: ClassHook<CCUIContentModuleContentContainerView> {
    
    typealias Group = customTweak
    
    func layoutSubviews() {
        orig.layoutSubviews()
        
        let materialView = Ivars<UIView>(target)._moduleMaterialView
        
        materialView.layer.setValue(false, forKey: "enabled")
        materialView.backgroundColor = localSettings.itemBackgroundColor
        
        materialView.layer.borderWidth = localSettings.itemBorderWidth
        materialView.layer.borderColor = localSettings.itemBorderColor.cgColor
    }
    
}

class MediaControlsVolumeSliderView_Hook: ClassHook<MediaControlsVolumeSliderView> {
    typealias Group = customTweak
    
    func layoutSubviews() {
        orig.layoutSubviews()
        
        let materialView = Ivars<UIView>(target)._materialView
        
        materialView.layer.setValue(false, forKey: "enabled")
        materialView.backgroundColor = localSettings.itemBackgroundColor
        
        materialView.layer.borderWidth = localSettings.itemBorderWidth
        materialView.layer.borderColor = localSettings.itemBorderColor.cgColor
    }
}

// for ios 14
class MRUControlCenterView_Hook: ClassHook<MRUControlCenterView> {
    
    typealias Group = customTweak
    
    func layoutSubviews() {
        orig.layoutSubviews()
        
        let materialView = target.materialView
        
        materialView?.layer.setValue(false, forKey: "enabled")
        materialView?.backgroundColor = localSettings.itemBackgroundColor
        
        materialView?.layer.borderWidth = localSettings.itemBorderWidth
        materialView?.layer.borderColor = localSettings.itemBorderColor.cgColor
    }
}

class MediaControlsMaterialView_Hook: ClassHook<MediaControlsMaterialView> {
    
    typealias Group = customTweak
    
    func layoutSubviews() {
        orig.layoutSubviews()
        
        let materialView = Ivars<UIView>(target)._backgroundView
        
        materialView.layer.setValue(false, forKey: "enabled")
        materialView.backgroundColor = localSettings.itemBackgroundColor
        
        materialView.layer.borderWidth = localSettings.itemBorderWidth
        materialView.layer.borderColor = localSettings.itemBorderColor.cgColor
    }
}

class CCUIRoundButton_Hook: ClassHook<CCUIRoundButton> {
    typealias Group = customTweak
    
    func glyphImage() -> UIImage {
        orig.glyphImage()
            .withRenderingMode(.alwaysTemplate)
    }
    
    func setSelected(_ selected: Bool) {
        orig.setSelected(selected)
        
        if let packageView = target.glyphPackageView {
            let selector = #selector(CCUICAPackageView.applyFigure(with:))
            let color: UIColor = selected ? localSettings.itemTintColor : .white
            
            if packageView.responds(to: selector) {
                packageView.perform(selector, with: color)
            }
        }
        
        target.selectedGlyphView?.tintColor = localSettings.itemTintColor
    }
}


class CCUIButtonModuleViewController_Hook: ClassHook<CCUIButtonModuleViewController> {
    
    typealias Group = customTweak
    
    func setSelected(_ selected: Bool) {
        orig.setSelected(selected)

        if !selected {
            let packageView = Ivars<UIView>(target.buttonView)._glyphPackageView
            let selector = #selector(CCUICAPackageView.applyFigure(with:))

            if packageView.responds(to: selector) {
                packageView.perform(selector, with: localSettings.itemTintColor)
            }
        }
    }

    func _buttonTapped(_ isSelected: Bool, forEvent event: Any) {
        orig._buttonTapped(isSelected, forEvent: event)
        
        guard !isSelected else {
            return
        }
        
        let packageView = Ivars<UIView>(target.buttonView)._glyphPackageView
        let selector = #selector(CCUICAPackageView.applyFigure(with:))
        
        if packageView.responds(to: selector) {
            packageView.perform(selector, with: localSettings.itemTintColor)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                packageView.perform(selector, with: localSettings.itemTintColor)
            }
        }
        
    }
}


class CCUIButtonModuleView_Hook: ClassHook<CCUIButtonModuleView> {
    typealias Group = customTweak
    
    func initWithFrame(_ frame: CGRect) -> UIControl {
        let target = orig.initWithFrame(frame)
        return target
    }
    
    func selectedGlyphColor() -> UIColor {
        localSettings.itemTintColor
    }
    
    func glyphImage() -> UIImage {
        orig.glyphImage().withRenderingMode(.alwaysTemplate)
    }

    func selectedGlyphImage() -> UIImage {
        orig.selectedGlyphImage().withRenderingMode(.alwaysTemplate)
    }
    
    func _tintColor(forSelectedState selected: Bool) -> UIColor {
        let tintColor = orig._tintColor(forSelectedState: selected)

        if !selected {
            return localSettings.itemTintColor
        }
        return tintColor
    }

    func setSelected(_ selected: Bool) {
        orig.setSelected(selected)
    }
}

class CCUICAPackageView_Hook: ClassHook<CCUICAPackageView> {
    typealias Group = customTweak
    
    // orion:new
    func applyFigure(color: UIColor, for layers: [CALayer]?) {
        layers?.forEach { layer in
            if let backgroundColor = layer.backgroundColor,
               UIColor(cgColor: backgroundColor).rgbaInt == 0xffffffff {
                layer.backgroundColor = color.cgColor
            }
            if let borderColor = layer.borderColor,
               UIColor(cgColor: borderColor).rgbaInt == 0xffffffff{
                layer.borderColor = color.cgColor
            }
            if let shapeLayer = layer as? CAShapeLayer,
               let fillColor = shapeLayer.fillColor,
               UIColor(cgColor: fillColor).rgbaInt == 0xffffffff {
                shapeLayer.fillColor = color.cgColor
            }
            applyFigure(color: color, for: layer.sublayers)
        }
    }
    
    // orion:new
    func applyFigure(color: UIColor) {
        applyFigure(color: color, for: target.layer.sublayers)
    }
}


func readPrefs() {
    let path = "/var/mobile/Library/Preferences/com.p-x9.ccanimator.pref.plist"
    let url = URL(fileURLWithPath: path)
    
    //Reading values
    guard let data = try? Data(contentsOf: url) else {
        return
    }
    let decoder = PropertyListDecoder()
    localSettings =  (try? decoder.decode(Settings.self, from: data)) ?? Settings()
}

func settingChanged() {
    readPrefs()
}

func observePrefsChange() {
    let NOTIFY = "com.p-x9.ccanimator.prefschanged" as CFString
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    nil, { _, _, _, _, _ in
        settingChanged()
    }, NOTIFY, nil, CFNotificationSuspensionBehavior.deliverImmediately)
}


struct CCAnimator: Tweak {
    init() {
        guard localSettings.isTweakEnabled else {
            return
        }
        
        readPrefs()
        observePrefsChange()
        
        if localSettings.isCustomEnabled {
            customTweak().activate()
        }
        
        if localSettings.isAnimationEnabled {
            animationTweak().activate()
        }
        
    }
}
