import Orion
import CCAnimatorC
import UIKit


struct localSettings {
    static var isTweakEnabled = true
    static var isCustomEnabled = true
    static var scale: CGFloat = 0.5
    
    static var itemTintColorCode: String = "#00FF00FF"
    static var itemBackgroundColorCode: String = "#FF0000AA"
    static var itemBorderColorCode: String = "#FFFFFFFF"
    static var itemBorderWidth: CGFloat = 1
    
    static var ccBackgroundColorCode: String = "#000088FF"
    
    static var isAnimationEnabled: Bool = true
    static var animationRawValue: Int = 0
    static var isAnimationAutoReverseEnabled: Bool = true
    static var animationDuration: TimeInterval = 1
    static var animationInterval: TimeInterval = 10
    
    static var itemTintColor: UIColor {
        UIColor(rgba: Self.itemTintColorCode)
    }
    
    static var itemBackgroundColor: UIColor {
        UIColor(rgba: Self.itemBackgroundColorCode)
    }
    
    static var itemBorderColor: UIColor {
        UIColor(rgba: Self.itemBorderColorCode)
    }
    
    static var ccBackgroundColor: UIColor {
        UIColor(rgba: Self.ccBackgroundColorCode)
    }
    
    private static let animations: [UIView.AnimationOptions] =
        [
            .transitionFlipFromLeft,
            .transitionFlipFromRight,
            .transitionFlipFromTop,
            .transitionFlipFromBottom,
            .transitionCurlUp,
            .transitionCurlDown,
            .transitionCrossDissolve
        ]
    
    
    static var animation: UIView.AnimationOptions {
        if animations.indices.contains(animationRawValue) {
            return animations[animationRawValue]
        }
        return animations[0]
    }
}

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
        let alpha = 1 - (point.y / target.view.frame.height)
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

        let alpha = 1 - (translatedPoint.y / target.view.frame.height)
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


struct CCAnimator: Tweak {
    init() {
        guard localSettings.isTweakEnabled else {
            return
        }
        if localSettings.isCustomEnabled {
            customTweak().activate()
        }
        
        if localSettings.isAnimationEnabled {
            animationTweak().activate()
        }
        
    }
}
