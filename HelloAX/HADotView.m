//
//  HADotView.m
//  HelloAX
//
//  Created by Sommer Panage on 12/6/13.
//  Copyright (c) 2013 Sommer Panage. All rights reserved.
//

#import "HADotView.h"

#define RADIUS 20.0f

static NSArray *colors;
static NSArray *colorStrings;

@implementation HADotView
{
    NSMutableArray *_axElements;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!colors) {
            colors = @[[UIColor redColor], [UIColor blueColor], [UIColor yellowColor]];
            colorStrings = @[@"Red", @"Blue", @"Yellow"];
            _axElements = [NSMutableArray new];
            [self updateAccessibility];
        }
    }
    NSAssert([colors count] == [colorStrings count], @"Color array and strings not the same lenght.");
    return self;
}

- (void)setDotCount:(NSUInteger)dotCount
{
    _dotCount = dotCount;
    [self updateAccessibility];
    [self setNeedsDisplay];
}

- (void)updateAccessibility
{
    if (_dotCount == 0) {
        self.isAccessibilityElement = YES;
        self.accessibilityLabel = @"No dots!";
    } else {
        self.isAccessibilityElement = NO;
        self.accessibilityLabel = nil;
    }
}

- (void)drawRect:(CGRect)rect
{
    [_axElements removeAllObjects];

    for (NSUInteger i= 0; i < _dotCount; i++) {
        [self drawRandomDot];
    }

    // Bonus: give proper T->B, L->R sorting
    [_axElements sortUsingComparator:^NSComparisonResult(UIAccessibilityElement *e1, UIAccessibilityElement *e2) {
        if (e1.accessibilityFrame.origin.y > e2.accessibilityFrame.origin.y) {
            return NSOrderedDescending;
        } else if (e1.accessibilityFrame.origin.y < e2.accessibilityFrame.origin.y) {
            return NSOrderedAscending;
        } else {
            if (e1.accessibilityFrame.origin.x < e2.accessibilityFrame.origin.x) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }
    }];

    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);

}

- (void)drawRandomDot
{
    const CGFloat diameter = 2 * RADIUS;
    const CGRect b = self.bounds;
    const CGFloat minX = b.origin.x;
    const CGFloat maxX = CGRectGetMaxX(b) - diameter;
    const CGFloat minY = b.origin.y;
    const CGFloat maxY = CGRectGetMaxY(b) - diameter;

    const CGFloat x = (CGFloat) ((arc4random() % (uint32_t)(maxX - minX)) + (uint32_t)minX);
    const CGFloat y = (CGFloat) ((arc4random() % (uint32_t)(maxY - minY)) + (uint32_t)minY);

    const NSUInteger colorIndex = arc4random() % [colors count];
    const UIColor *color = colors[colorIndex];
    const CGRect dotFrame = CGRectMake(x, y, diameter, diameter);

    CGContextRef cxt = UIGraphicsGetCurrentContext();
    CGContextSaveGState(cxt);
    {
        CGContextSetFillColorWithColor(cxt, color.CGColor);
        CGContextFillEllipseInRect(cxt, dotFrame);
        [_axElements addObject:[self axElementForDotWithFrame:dotFrame colorName:colorStrings[colorIndex]]];
    }
    CGContextRestoreGState(cxt);
}

#pragma mark - Accessibility

- (UIAccessibilityElement *)axElementForDotWithFrame:(CGRect)frame colorName:(NSString *)colorName
{
    UIAccessibilityElement *e = [[UIAccessibilityElement alloc] initWithAccessibilityContainer:self];
    e.accessibilityLabel = [NSString stringWithFormat:@"%@ Dot", colorName];
    e.accessibilityTraits = UIAccessibilityTraitImage;

    const CGRect windowFrame = [self convertRect:frame toView:self.window];
    e.accessibilityFrame =  [self.window convertRect:windowFrame toWindow:nil];

    return e;

}

- (NSInteger)accessibilityElementCount
{
    return [_axElements count];
}

- (NSInteger)indexOfAccessibilityElement:(id)element
{
    return [_axElements indexOfObject:element];
}

- (id)accessibilityElementAtIndex:(NSInteger)index
{
    id elem = nil;
    if (index >= 0 && index < [_axElements count]) {
        elem = _axElements[index];
    }
    return elem;
}

@end
