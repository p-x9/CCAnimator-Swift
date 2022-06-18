import Orion
import CCAnimatorC
import UIKit


struct localSettings {
    static var isTweakEnabled = true
    static var isCustomEnabled = true
    static var scale: CGFloat = 0.5
    
    static var itemTintColorCode: String = "#00FF00FF"
    static var itemBackgroundColorCode: String = "#FF0000AA"
    
    static var itemTintColor: UIColor {
        UIColor(rgba: Self.itemTintColorCode)
    }
    
    static var itemBackgroundColor: UIColor {
        UIColor(rgba: Self.itemBackgroundColorCode)
    }
}

struct tweak: HookGroup {}

class CCUIContentModuleContentContainerView_Hook: ClassHook<CCUIContentModuleContentContainerView> {
    func layoutSubviews() {
        orig.layoutSubviews()
        
        let materialView = Ivars<UIView>(target)._moduleMaterialView
        
        materialView.layer.setValue(false, forKey: "enabled")
        materialView.backgroundColor = localSettings.itemBackgroundColor
    }
}

class MediaControlsVolumeSliderView_Hook: ClassHook<MediaControlsVolumeSliderView> {
    
    func layoutSubviews() {
        orig.layoutSubviews()
        
        let materialView = Ivars<UIView>(target)._materialView
        
        materialView.layer.setValue(false, forKey: "enabled")
        materialView.backgroundColor = localSettings.itemBackgroundColor
    }
}

// for ios 14
class MRUControlCenterView_Hook: ClassHook<MRUControlCenterView> {
    func layoutSubviews() {
        orig.layoutSubviews()
        
        let materialView = target.materialView
        
        materialView?.layer.setValue(false, forKey: "enabled")
        materialView?.backgroundColor = localSettings.itemBackgroundColor
    }
}

class MediaControlsMaterialView_Hook: ClassHook<MediaControlsMaterialView> {
    func layoutSubviews() {
        orig.layoutSubviews()
        
        let materialView = Ivars<UIView>(target)._backgroundView
        
        materialView.layer.setValue(false, forKey: "enabled")
        materialView.backgroundColor = localSettings.itemBackgroundColor
    }
}

class CCUIRoundButton_Hook: ClassHook<CCUIRoundButton> {
    typealias Group = tweak
    
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
    typealias Group = tweak
    
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
    typealias Group = tweak
    
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
    typealias Group = tweak
    
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
        tweak().activate()
    }
}
