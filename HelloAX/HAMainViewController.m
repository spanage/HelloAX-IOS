//
//  HAMainViewController.m
//  HelloAX
//
//  Created by Sommer Panage on 12/5/13.
//  Copyright (c) 2013 Sommer Panage. All rights reserved.
//

#import "HAMainViewController.h"
#import "HADotView.h"

#define HEADING_FONT_SIZE 30.0f
#define HEADING_FONT @"Helvetica"
#define HEADING_TEXT @"Hello Accessibility!"
#define VIEW_PADDING_VERT 40.0f
#define VIEW_PADDING_HORI 20.0f
#define INNER_PADDING_VERT 20.0f
#define BUTTON_SPACER_HORI 100.0f

@interface HAMainViewController ()
@end

@implementation HAMainViewController
{
    UILabel *_headingLabel;
    UIButton *_plusButton;
    UIButton *_minusButton;
    HADotView *_dotView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _headingLabel = [UILabel new];
    _headingLabel.text = HEADING_TEXT;
    _headingLabel.textColor = [UIColor blackColor];
    _headingLabel.font = [UIFont fontWithName:HEADING_FONT size:HEADING_FONT_SIZE];
    _headingLabel.textAlignment = NSTextAlignmentCenter;
    _headingLabel.accessibilityTraits |= UIAccessibilityTraitHeader;
    [self.view addSubview:_headingLabel];

    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_plusButton setImage:[UIImage imageNamed:@"image2-plus"] forState:UIControlStateNormal];
    [_plusButton addTarget:self action:@selector(incrementDots:) forControlEvents:UIControlEventTouchUpInside];
    _plusButton.accessibilityLabel = @"Add dot";
    [self.view addSubview:_plusButton];

    _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_minusButton setImage:[UIImage imageNamed:@"image1-minus"] forState:UIControlStateNormal];
    [_minusButton addTarget:self action:@selector(incrementDots:) forControlEvents:UIControlEventTouchUpInside];
    _minusButton.accessibilityLabel = @"Remove dot";
    [self.view addSubview:_minusButton];

    _dotView = [HADotView new];
    _dotView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_dotView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    const CGRect b = self.view.bounds;
    const CGFloat minX = b.origin.x + VIEW_PADDING_HORI;
    const CGFloat minY = b.origin.y + VIEW_PADDING_VERT;
    const CGFloat maxWidth = b.size.width - 2 * VIEW_PADDING_HORI;

    [_headingLabel sizeToFit];
    _headingLabel.frame = CGRectMake(minX, minY, maxWidth, _headingLabel.frame.size.height);

    [_plusButton sizeToFit];
    [_minusButton sizeToFit];
    const CGFloat totalWidth = _plusButton.frame.size.width + BUTTON_SPACER_HORI + _minusButton.frame.size.width;
    CGFloat x = (b.size.width - totalWidth) / 2;
    CGFloat y = CGRectGetMaxY(_headingLabel.frame) + INNER_PADDING_VERT;
    _minusButton.frame = CGRectMake(x, y, _minusButton.frame.size.width, _minusButton.frame.size.height);
    x += BUTTON_SPACER_HORI + _minusButton.frame.size.width;
    _plusButton.frame = CGRectMake(x, y, _plusButton.frame.size.width, _plusButton.frame.size.height);

    y += MAX(_plusButton.frame.size.height,  _minusButton.frame.size.height) + INNER_PADDING_VERT;
    _dotView.frame = CGRectMake(minX, y, maxWidth, (CGRectGetMaxY(b) - VIEW_PADDING_VERT) - y);
}

#pragma mark - Actions

- (void)incrementDots:(UIButton *)sender
{
    if (sender == _plusButton) {
        ++_dotView.dotCount;
    } else if (sender == _minusButton && _dotView.dotCount > 0) {
        --_dotView.dotCount;
    }
}

@end
