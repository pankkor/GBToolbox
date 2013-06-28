//
//  GBToggleControl.m
//  GBToolbox
//
//  Created by Luka Mirosevic on 28/06/2013.
//  Copyright (c) 2013 Goonbee. All rights reserved.
//

#import "GBToggleControl.h"

@interface GBToggleControl ()

@property (strong, nonatomic) UIButton          *button;

@end

@implementation GBToggleControl

#pragma mark - custom accessors

-(void)setImageWhenOff:(UIImage *)imageWhenOff {
    _imageWhenOff = imageWhenOff;
    
    [self _handleButton];
}

-(void)setImageWhenOn:(UIImage *)imageWhenOn {
    _imageWhenOn = imageWhenOn;
    
    [self _handleButton];
}

-(void)setBackgroundImageWhenOff:(UIImage *)backgroundImageWhenOff {
    _backgroundImageWhenOff = backgroundImageWhenOff;
    
    [self _handleButton];
}

-(void)setBackgroundImageWhenOn:(UIImage *)backgroundImageWhenOn {
    _backgroundImageWhenOn = backgroundImageWhenOn;
    
    [self _handleButton];
}

-(void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    
    [self _handleButton];
}

#pragma mark - init

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}

-(void)_init {
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = self.bounds;
    self.button.adjustsImageWhenHighlighted = NO;
    self.button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.button addTarget:self action:@selector(internalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.button];
}

#pragma mark - actions

-(void)internalButtonAction:(UIButton *)sender {
    self.isOn = !self.isOn;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - util

-(void)_handleButton {
    if (self.isOn) {
        [self.button setImage:self.imageWhenOn forState:UIControlStateNormal];
        [self.button setBackgroundImage:self.backgroundImageWhenOn forState:UIControlStateNormal];
    }
    else {
        [self.button setImage:self.imageWhenOff forState:UIControlStateNormal];
        [self.button setBackgroundImage:self.backgroundImageWhenOff forState:UIControlStateNormal];
    }
}

@end
