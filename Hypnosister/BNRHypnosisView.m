//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by Krzysztof Kula on 28.07.2014.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRHypnosisView.h"

@interface BNRHypnosisView ()
@property (strong, nonatomic) UIColor *circleColor;
@end

@implementation BNRHypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect bounds = self.bounds;
    
    //figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0 endAngle:M_PI * 2
                     clockwise:YES];
    }
    
    
    
    path.lineWidth = 10;
    [self.circleColor setStroke];
    [path stroke];
    
    //gradient
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    
    UIBezierPath *clip = [[UIBezierPath alloc] init];
    [clip moveToPoint:CGPointMake(center.x, center.y - 100)];
    [clip addLineToPoint:CGPointMake(center.x - bounds.size.width /2, center.y + 100)];
    [clip addLineToPoint:CGPointMake(center.x + bounds.size.width /2, center.y + 100)];
    
    [clip addClip];
    
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        0.0, 1.0, 0.0, 1.0,//red
        1.0, 1.0, 0.0, 1.0 //yellow
    };
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 2);
    
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(20, 400);
    
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    
    CGContextRestoreGState(currentContext);
    
    
    //iage with shadow
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    
    CGContextSaveGState(currentContext);
    
    CGContextSetShadow(currentContext, CGSizeMake(4, 7), 3);
    
    [logoImage drawInRect:bounds];
    
    CGContextRestoreGState(currentContext);
    
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@ was touched", self);
    float red = (arc4random() % 100) / 100.0;
    float green = (arc4random() % 100) / 100.0;
    float blue = (arc4random() % 100) / 100.0;
    
    UIColor *randomColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue alpha:1.0];
    self.circleColor = randomColor;
}

- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

@end
