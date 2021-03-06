//
//  UIScrollView+GBToolbox.m
//  GBToolbox
//
//  Created by Luka Mirosevic on 27/06/2013.
//  Copyright (c) 2013 Luka Mirosevic. All rights reserved.
//

#import "UIScrollView+GBToolbox.h"

@implementation UIScrollView (GBToolbox)

-(void)scrollToOriginAnimated:(BOOL)animated {
    [self setContentOffset:CGPointZero animated:animated];
}

-(void)scrollToTopAnimated:(BOOL)animated {
    [self setContentOffset:CGPointMake(self.contentOffset.x, 0 - self.contentInset.top) animated:animated];
}

-(void)scrollToBottomAnimated:(BOOL)animated {
    [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentSize.height - self.bounds.size.height + self.contentInset.bottom) animated:YES];
}

-(void)scrollToLeftAnimated:(BOOL)animated {
    self.contentOffset = CGPointMake(0 - self.contentInset.left, self.contentOffset.y);
}

-(void)scrollToRightAnimated:(BOOL)animated {
    [self setContentOffset:CGPointMake(self.contentSize.height - self.bounds.size.width + self.contentInset.right, self.contentOffset.y) animated:YES];
}

@end
