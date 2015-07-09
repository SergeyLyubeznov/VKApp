//
//  UIImageView+UIImageViewExtension.m
//  VKApp
//
//  Created by Sergey Lyubeznov on 04.06.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import "UIImageView+UIImageViewExtension.h"

@implementation UIImageView (UIImageViewExtension)

- (void)setCornerRadius:(CGFloat)radius andBorderWidth:(CGFloat)width andBorderColor:(UIColor *)color {
    
    self.layer.cornerRadius = radius;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.clipsToBounds = YES;
    
}

@end
