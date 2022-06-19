#import "CCAHeaderView.h"
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface CCAHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIStackView *contentStackView;
@end


@implementation CCAHeaderView

- (UILabel*)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _titleLabel;
}

- (UILabel*)subTitleLabel {
    if(!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _subTitleLabel;
}

- (UIStackView*)contentStackView {
    if(!_contentStackView) {
        _contentStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
        _contentStackView.alignment = UIStackViewAlignmentCenter;
        _contentStackView.axis = UILayoutConstraintAxisVertical;
        _contentStackView.distribution = UIStackViewDistributionEqualCentering;
    }

    return _contentStackView;
}

- (id)initWithSpecifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if(!self) return self;

    [self.contentView addSubview: self.contentStackView];
    [self.contentStackView addArrangedSubview: self.titleLabel];
    [self.contentStackView addArrangedSubview: self.subTitleLabel];

    self.titleLabel.text = @"CCAnimator";
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Ultralight" size:36];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel sizeToFit];

    self.subTitleLabel.text = @"Adjust the quality of the screenshot。";
    self.subTitleLabel.textColor = UIColor.grayColor;
    self.subTitleLabel.font = [UIFont systemFontOfSize:14];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.subTitleLabel sizeToFit];

    self.contentStackView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [self.contentStackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant: 8],
        [self.contentStackView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant: 0],
        [self.contentStackView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant: 0],
        [self.contentStackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant: -8],
    ]];

    return self;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
  return 96.0;
}


@end
