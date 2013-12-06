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

@implementation HADotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!colors) {
            colors = @[[UIColor redColor], [UIColor blueColor], [UIColor yellowColor]];
        }
    }
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
    const CGRect b = self.bounds;
    const CGFloat minX = b.origin.x;
    const CGFloat maxX = CGRectGetMaxX(b) - 2 * RADIUS;
    const CGFloat minY = b.origin.y;
    const CGFloat maxY = CGRectGetMaxY(b) - 2 * RADIUS;

    const CGFloat x = (CGFloat) ((arc4random() % (uint32_t)(maxX - minX)) + (uint32_t)minX);
    const CGFloat y = (CGFloat) ((arc4random() % (uint32_t)(maxY - minY)) + (uint32_t)minY);

    const UIColor *color = colors[arc4random() % [colors count]];

    CGContextRef cxt = UIGraphicsGetCurrentContext();
    CGContextSaveGState(cxt);
    {
        CGContextSetFillColorWithColor(cxt, color.CGColor);
        CGContextFillEllipseInRect(cxt, CGRectMake(x, y, 2 * RADIUS, 2 * RADIUS));
    }
}

@end
