@import UIKit;

@class CCUICAPackageView;
@interface CCUIRoundButton : UIControl

@property (nonatomic,retain) UIColor * highlightColor;
@property (nonatomic,retain) UIView * normalStateBackgroundView;
@property (nonatomic,retain) UIView * selectedStateBackgroundView;
@property (nonatomic,retain) UIView * alternateSelectedStateBackgroundView;
@property (nonatomic,retain) CCUICAPackageView * glyphPackageView;
@property (nonatomic,retain) UIImageView * glyphImageView;
@property (nonatomic,retain) UIImageView * selectedGlyphView;
@property (nonatomic,retain) UIImage * glyphImage;
@property (nonatomic,copy) NSString * glyphState;
@property (assign,nonatomic) BOOL useAlternateBackground;

-(UIImage *)glyphImage;
-(UIImageView *)glyphImageView;
-(UIImageView *)selectedGlyphView;
-(void)setUseAlternateBackground:(BOOL)arg1;

@end


@interface MTMaterialView : UIView

@property (assign,getter=isBlurEnabled,nonatomic) BOOL blurEnabled;
@property (assign,getter=isZoomEnabled,nonatomic) BOOL zoomEnabled;
@property (assign,getter=isCaptureOnly,nonatomic) BOOL captureOnly; 

@end


@interface CCUIModularControlCenterOverlayViewController : UIViewController

@property (nonatomic,readonly) MTMaterialView * overlayBackgroundView;
@property (nonatomic,readonly) UIScrollView * overlayScrollView;

-(void)_dismissalPanGestureRecognizerChanged:(id)arg1 ;

@end


@interface CCUIAppLauncherModule : NSObject

@property (nonatomic,copy) NSString * applicationIdentifier;
@property (nonatomic,copy) NSString * launchApplicationIdentifier;
@property (nonatomic,copy) NSURL * launchURL;
@property (nonatomic,copy) NSString * displayName;
//@property (getter=_application,nonatomic,readonly) SBFApplication * application;
@property (nonatomic,copy,readonly) UIImage * iconGlyph;

@end


@interface CCUIButtonModuleView : UIControl

@property (nonatomic,retain) UIImage * glyphImage;
@property (nonatomic,retain) UIColor * glyphColor;
@property (nonatomic,retain) UIImage * selectedGlyphImage;
@property (nonatomic,retain) UIColor * selectedGlyphColor;
@property (assign,nonatomic) double glyphAlpha;
@property (assign,nonatomic) double glyphScale;

-(CCUIButtonModuleView*)initWithFrame:(CGRect)arg1;
-(UIImage *)glyphImage;
-(UIColor *)glyphColor;
-(UIColor *)selectedGlyphColor;
-(void)setSelected:(BOOL)arg1;
-(UIColor *)_tintColorForSelectedState:(BOOL)arg1;
-(void)_dismissalPanGestureRecognizerEnded:(id)arg1;
-(void)dismissAnimated:(BOOL)arg1 withCompletionHandler:(/*^block*/id)arg2 ;
-(void)presentAnimated:(BOOL)arg1 withCompletionHandler:(/*^block*/id)arg2 ;
-(void)layoutSubviews;

@end


@interface CCUICAPackageView : UIView {
    UIView* _packageContentView;
    CALayer* _packageLayer;
}
-(double)scale;
-(void)setScale:(double)arg1 ;

// new
-(void)applyFigureWithColor:(UIColor*)color for:(nullable NSArray<CALayer*>*)layers;
-(void)applyFigureWithColor:(UIColor*)color;

@end

@interface CCUIButtonModuleViewController : UIViewController

@property (nonatomic,retain) UIImage * glyphImage;
@property (nonatomic,retain) UIColor * glyphColor;
@property (nonatomic,retain) UIImage * selectedGlyphImage;
@property (nonatomic,retain) UIColor * selectedGlyphColor;
@property (nonatomic,copy) NSString * glyphState;
@property (assign,nonatomic) double glyphScale;
@property (assign,getter=isSelected,nonatomic) BOOL selected;
@property (assign,getter=isExpanded,nonatomic) BOOL expanded;
@property (nonatomic,readonly) CCUIButtonModuleView * buttonView;
@property (nonatomic,readonly) BOOL hasGlyph;
@property (nonatomic,readonly) double preferredExpandedContentHeight;
@property (nonatomic,readonly) double preferredExpandedContentWidth;
@property (nonatomic,readonly) double preferredExpandedContinuousCornerRadius;

-(BOOL)isSelected;
-(void)setSelected:(BOOL)arg1 ;
-(UIImage *)glyphImage;
-(UIColor *)glyphColor;
-(void)_buttonTouchDown:(id)arg1 forEvent:(id)arg2 ;
-(void)_buttonTapped:(id)arg1 forEvent:(id)arg2 ;
@end
