//
//  ClockView.m
//  JediClock
//
//  Created by Steven Masini on 29/04/2017.
//  Copyright © 2017 Steven Masini. All rights reserved.
//

#import "ClockView.h"
#import "UIColor+Jedi.h"

@interface ClockView ()

@property (assign, nonatomic) CGPoint center;

#pragma mark - CAShapeLayers
@property (strong, nonatomic) CAShapeLayer  *clockLayer;
@property (strong, nonatomic) CAShapeLayer  *innerLayer;
@property (strong, nonatomic) CAShapeLayer  *dotLayer;

@property (strong, nonatomic) CAShapeLayer  *hourHandLayer;
@property (strong, nonatomic) CAShapeLayer  *minuteHandLayer;
@property (strong, nonatomic) CAShapeLayer  *secondHandLayer;

@end

@implementation ClockView

#pragma mark - UIView inherited methods

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // setup the clock
    [self setupClockLayers];
}

#pragma mark - ClockCell setup methods

- (void)setupClockLayers {
    // initialize the main layer
    self.clockLayer             = [CAShapeLayer layer];
    self.clockLayer.path        = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    self.clockLayer.fillColor   = [UIColor blackColor].CGColor;
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    
    // define the size and position of the inner circle
    CGFloat innerWidth    = self.bounds.size.width / 18.0;
    CGFloat innerHeight   = self.bounds.size.height / 18.0;
    
    self.innerLayer             = [CAShapeLayer layer];
    self.innerLayer.frame       = CGRectMake(0, 0, innerWidth, innerHeight);
    self.innerLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    self.innerLayer.position    = CGPointMake(center.x, center.y);
    self.innerLayer.path        = [UIBezierPath bezierPathWithOvalInRect:self.innerLayer.bounds].CGPath;
    self.innerLayer.fillColor   = [UIColor whiteColor].CGColor;
    
    [self.clockLayer addSublayer:self.innerLayer];
    
    self.dotLayer               = [CAShapeLayer layer];
    self.dotLayer.frame         = CGRectMake(0, 0, innerWidth / 2.0, innerHeight / 2.0);
    self.dotLayer.anchorPoint   = CGPointMake(0.5f, 0.5f);
    self.dotLayer.position      = CGPointMake(center.x, center.y);
    self.dotLayer.path          = [UIBezierPath bezierPathWithOvalInRect:self.dotLayer.bounds].CGPath;
    self.dotLayer.fillColor     = [UIColor redColor].CGColor;
    
    [self.clockLayer addSublayer:self.dotLayer];
    
    // 2) setup the hands rendering
    [self setupHands];
    
    // finally add the clock layer
    [self.layer addSublayer:self.clockLayer];
    
    // 3) put the numbers on the clock
    [self setupClockNumbers];
}

- (void)setupHands {
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    
    self.minuteHandLayer    = [CAShapeLayer layer];
    self.secondHandLayer    = [CAShapeLayer layer];
    
    // setup the hour hand
    CGFloat hourHandWidth   = self.bounds.size.width / 28.0;
    CGFloat hourHandHeight  = self.bounds.size.height / 4.0;
    CGFloat hourHandY       = self.dotLayer.frame.origin.y;
    
    self.hourHandLayer              = [CAShapeLayer layer];
    self.hourHandLayer.frame        = CGRectMake(0, 0, hourHandWidth, hourHandHeight);
    self.hourHandLayer.anchorPoint  = CGPointMake(0.5f, 1.0f);
    self.hourHandLayer.position     = CGPointMake(center.x, hourHandY);
    self.hourHandLayer.path         = [UIBezierPath bezierPathWithRoundedRect:self.hourHandLayer.bounds cornerRadius:2.0].CGPath;
    self.hourHandLayer.fillColor    = [UIColor whiteColor].CGColor;
    
    
    [self.clockLayer insertSublayer:self.hourHandLayer below:self.dotLayer];
    
    // setup hands view anchor point
    self.minuteHandLayer.anchorPoint    = CGPointMake(0.5f, 1.0f);
    self.secondHandLayer.anchorPoint    = CGPointMake(0.5f, 1.0f);
}

- (void)setupClockNumbers {
    float PI2 = M_PI * 2.0f;
    CGSize clockSize = self.bounds.size;
    CGPoint c = CGPointMake((clockSize.width) / 2.0f, (clockSize.height) / 2.0f);
    CGFloat r = (self.bounds.size.width) / 2.0f;
    
    for (NSInteger i = 0; i < 12; i++) {
        CGFloat x = ((c.x - 6) + (r - 9) * cos((PI2 / 12.0f) * i));
        CGFloat y = ((c.y - 6) + (r - 9) * sin((PI2 / 12.0f) * i));
        CGRect frame = CGRectMake(x, y, 12.0f, 12.0f);
        
        UILabel *hourLabel = [[UILabel alloc] initWithFrame:frame];
        hourLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f];
        hourLabel.backgroundColor = [UIColor clearColor];
        
        NSInteger time = (i + 3) <= 12 ? (i + 3) : i - 9;
        hourLabel.text = @(time).stringValue;
        hourLabel.textColor = [UIColor whiteColor];
        hourLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:hourLabel];
    }
}

#pragma mark - Getter/Setter

- (void)setIsDayTheme:(Boolean)isDayTheme {
    _isDayTheme = isDayTheme;
    
    self.clockLayer.fillColor       = isDayTheme ? [[UIColor whiteGrayColor] CGColor] : [[UIColor blackColor] CGColor];
    self.minuteHandLayer.fillColor  = isDayTheme ? [[UIColor blackColor] CGColor] : [[UIColor whiteColor] CGColor];
    self.hourHandLayer.fillColor    = isDayTheme ? [[UIColor blackColor] CGColor] : [[UIColor whiteColor] CGColor];
    self.innerLayer.fillColor         = isDayTheme ? [[UIColor blackColor] CGColor] : [[UIColor whiteColor] CGColor];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            label.textColor = isDayTheme ? [UIColor blackColor] : [UIColor whiteColor];
        }
    }
}

@end
