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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!colors) {
            colors = @[[UIColor redColor], [UIColor blueColor], [UIColor yellowColor]];
            colorStrings = @[@"Red", @"Blue", @"Yellow"];
        }
    }
    NSAssert([colors count] == [colorStrings count], @"Color array and strings not the same lenght.");
    return self;
}

- (void)setDotCount:(NSUInteger)dotCount
{
    _dotCount = dotCount;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    for (NSUInteger i= 0; i < _dotCount; i++) {
        [self drawRandomDot];
    }
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

    CGContextRef cxt = UIGraphicsGetCurrentContext();
    CGContextSaveGState(cxt);
    {
        CGContextSetFillColorWithColor(cxt, color.CGColor);
        CGContextFillEllipseInRect(cxt, CGRectMake(x, y, diameter, diameter));
    }
}

@end
