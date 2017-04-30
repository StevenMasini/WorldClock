//
//  ClockView.m
//  JediClock
//
//  Created by Steven Masini on 29/04/2017.
//  Copyright © 2017 Steven Masini. All rights reserved.
//

#import "ClockView.h"

@interface ClockView ()

@property (strong, nonatomic) CAShapeLayer  *clockLayer;
@property (strong, nonatomic) CAShapeLayer  *innerLayer;
@property (strong, nonatomic) CAShapeLayer  *dotLayer;
@property (strong, nonatomic) CALayer       *hourHandLayer;
@property (strong, nonatomic) CALayer       *minuteHandLayer;
@property (strong, nonatomic) CALayer       *secondHandLayer;

@end

@implementation ClockView

#pragma mark - UIView inherited methods

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupClockLayers];
}

#pragma mark - ClockCell setup methods

- (void)setupClockLayers {
    // initialize the main layer
    self.clockLayer             = [CAShapeLayer layer];
    self.clockLayer.path        = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    self.clockLayer.fillColor   = [UIColor blackColor].CGColor;
    
    
    // define the size and position of the inner circle
    CGFloat innerWidth    = self.bounds.size.width / 18.0;
    CGFloat innerHeight   = self.bounds.size.height / 18.0;
    CGFloat innerX        = (self.bounds.size.width / 2.0) - (innerWidth / 2.0);
    CGFloat innerY        = (self.bounds.size.height / 2.0) - (innerHeight / 2.0);
    CGRect innerRect      = CGRectMake(innerX, innerY, innerWidth, innerHeight);
    
    self.innerLayer            = [CAShapeLayer layer];
    self.innerLayer.path       = [UIBezierPath bezierPathWithOvalInRect:innerRect].CGPath;
    self.innerLayer.fillColor  = [UIColor whiteColor].CGColor;
    
    [self.clockLayer addSublayer:self.innerLayer];
    
    CGRect dotRect = CGRectMake(innerX + innerWidth / 4.0, innerY + innerHeight / 4.0, innerWidth / 2.0, innerHeight / 2.0);
    self.dotLayer = [CAShapeLayer layer];
    self.dotLayer.path = [UIBezierPath bezierPathWithOvalInRect:dotRect].CGPath;
    self.dotLayer.fillColor = [UIColor redColor].CGColor;
    
    [self.innerLayer addSublayer:self.dotLayer];
    
    [self.layer addSublayer:self.clockLayer];
    
//    self.centerView.layer.cornerRadius      = self.centerView.frame.size.width / 2.0f;
//    self.redCenterView.layer.cornerRadius   = self.redCenterView.frame.size.width / 2.0f;
    
    // 2) setup the hands rendering
    [self setupHands];
    
    // 3) put the numbers on the clock
    [self setupClockNumbers];
}

- (void)setupHands {
    self.hourHandLayer      = [CALayer layer];
    self.minuteHandLayer    = [CALayer layer];
    self.secondHandLayer    = [CALayer layer];
    
    
    // setup hands view anchor point
    self.hourHandLayer.anchorPoint      = CGPointMake(0.5f, 1.0f);
    self.minuteHandLayer.anchorPoint    = CGPointMake(0.5f, 1.0f);
    self.secondHandLayer.anchorPoint    = CGPointMake(0.5f, 1.0f);
    
    // setup anti-aliasing for hands
    self.secondHandLayer.borderColor       = [UIColor clearColor].CGColor;
    self.secondHandLayer.borderWidth       = 1.0f;
    self.secondHandLayer.shouldRasterize   = YES;
    
    self.minuteHandLayer.borderColor       = [UIColor clearColor].CGColor;
    self.minuteHandLayer.borderWidth       = 0.5f;
    self.minuteHandLayer.cornerRadius      = 1.0f;
    self.minuteHandLayer.shouldRasterize   = YES;

    self.hourHandLayer.borderColor         = [UIColor clearColor].CGColor;
    self.hourHandLayer.borderWidth         = 0.5f;
    self.hourHandLayer.cornerRadius        = 1.0f;
    self.hourHandLayer.shouldRasterize     = YES;
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
}

@end
