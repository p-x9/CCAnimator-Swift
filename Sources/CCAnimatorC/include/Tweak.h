@import UIKit;
#import "sparkcolorheaders/SparkColourPickerUtils.h"

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


@interface CCUIModularControlCenterOverlayViewController : UIViewController {
    MTMaterialView* _backgroundView;
    UIView* _containerView;
    
    UIPanGestureRecognizer* _headerPocketViewDismissalPanGesture;
    UITapGestureRecognizer* _headerPocketViewDismissalTapGesture;
    
    UIPanGestureRecognizer* _collectionViewDismissalPanGesture;
    UITapGestureRecognizer* _collectionViewDismissalTapGesture;
    UIPanGestureRecognizer* _collectionViewScrollPanGesture;
}

@property (nonatomic,readonly) MTMaterialView * overlayBackgroundView;
@property (nonatomic,readonly) UIScrollView * overlayScrollView;
@property (nonatomic,readonly) UIView * overlayContainerView;

-(void)beginPresentationWithLocation:(CGPoint)arg1 translation:(CGPoint)arg2 velocity:(CGPoint)arg3 ;
-(void)updatePresentationWithLocation:(CGPoint)arg1 translation:(CGPoint)arg2 velocity:(CGPoint)arg3 ;
-(void)cancelPresentationWithLocation:(CGPoint)arg1 translation:(CGPoint)arg2 velocity:(CGPoint)arg3 ;
-(void)endPresentationWithLocation:(CGPoint)arg1 translation:(CGPoint)arg2 velocity:(CGPoint)arg3 ;
-(void)_dismissalPanGestureRecognizerChanged:(id)arg1 ;
-(void)_dismissalPanGestureRecognizerEnded:(id)arg1 ;
-(void)_handleDismissalTapGestureRecognizer:(id)arg1 ;
-(void)dismissAnimated:(BOOL)arg1 withCompletionHandler:(/*^block*/id)arg2 ;
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


@interface CCUIContentModuleContentContainerView : UIView {
    BOOL _expanded;
    MTMaterialView* _moduleMaterialView;
    BOOL _moduleProvidesOwnPlatter;
    double _compactContinuousCornerRadius;
    double _expandedContinuousCornerRadius;
}
-(double)expandedContinuousCornerRadius;
-(double)compactContinuousCornerRadius;

-(void)transitionToExpandedMode:(BOOL)arg1 ;
-(void)_transitionToExpandedMode:(BOOL)arg1 force:(BOOL)arg2 ;
-(void)didEndTransitionToExpandedMode:(BOOL)arg1 ;

-(void)setExpandedContinuousCornerRadius:(double)arg1 ;
-(void)setCompactContinuousCornerRadius:(double)arg1 ;
// new
- (void)animate;

@end

@interface CCUIContinuousSliderView : UIView <UIGestureRecognizerDelegate> {
    
    UIView* _valueIndicatorClippingView;
    UIView* _backgroundView;
    double _startingLength;
    float _startingValue;
    BOOL _gestureStartedInside;
    UIPanGestureRecognizer* _valueChangeGestureRecognizer;
    double _continuousSliderCornerRadius;
    unsigned long long _axis;
    
}

@property (assign,nonatomic) double continuousSliderCornerRadius;
@property (assign,nonatomic) unsigned long long axis;
@property (nonatomic,readonly) UIView * valueIndicatorClippingView;
-(id)topLevelBlockingGestureRecognizers;
-(void)_handleValueChangeGestureRecognizer:(id)arg1 ;
-(double)sliderLengthForValue:(float)arg1 ;
-(float)_valueForTouchTranslation:(CGPoint)arg1 ;
-(void)_beginTrackingWithGestureRecognizer:(id)arg1 ;
-(unsigned long long)axis;
-(void)setAxis:(unsigned long long)arg1 ;
-(void)_updateValueForPanGestureRecognizer:(id)arg1 forContinuedGesture:(BOOL)arg2 ;
-(void)_endTrackingWithGestureRecognizer:(id)arg1 ;
-(double)continuousSliderCornerRadius;
-(float)filteredValueForValue:(float)arg1 ;
-(CGPoint)glyphCenter;
-(void)setContinuousSliderCornerRadius:(double)arg1 ;
-(UIView *)valueIndicatorClippingView;
-(void)_continueTrackingWithGestureRecognizer:(id)arg1 ;
@end

@interface MediaControlsVolumeSliderView : CCUIContinuousSliderView {
    
    UIView* _orangeValueView;
    BOOL _didAcknowledgeThreshold;
    BOOL _didHitThreshold;
    BOOL _didTakeActionToAcknowledge;
    UIView* _materialView;
    BOOL _euDevice;
    BOOL _euVolumeLimitEnforced;
    float _euVolumeLimit;
    
}
@end

//ios14.4
@interface MRUControlCenterView : UIView {
    
    BOOL _transitioning;
    BOOL _showMoreButton;
    BOOL _showAlertView;
    UIView* _contentView;
    UIView* _alertView;
    UIView* _containerView;
    UICollectionView* _collectionView;
    UICollectionViewFlowLayout* _collectionViewLayout;
    long long _state;
    double _cornerRadius;
    UIView* _materialView;
    CGSize _forcedContentSize;
    CGRect _transitionFrame;
}
@property (nonatomic,retain) UIView * materialView;
@property (nonatomic,retain) UIView * contentView;
@property (nonatomic,retain) UIView * alertView;
@property (nonatomic,readonly) UIView * containerView;
@property (nonatomic,readonly) UICollectionView * collectionView;
@property (nonatomic,readonly) UICollectionViewFlowLayout * collectionViewLayout;
@property (assign,nonatomic) long long state;
@property (assign,getter=isTransitioning,nonatomic) BOOL transitioning;
@property (assign,nonatomic) CGRect transitionFrame;
@property (assign,nonatomic) double cornerRadius;
@property (assign,nonatomic) BOOL showMoreButton;
@property (assign,nonatomic) BOOL showAlertView;
@property (assign,nonatomic) CGSize forcedContentSize;

-(void)setCornerRadius:(double)arg1 ;
@end


@interface MediaControlsMaterialView : UIView {
    
    UIView* _backgroundView;
    UIView* _highlightView;
    BOOL _highlighted;
}
@end
