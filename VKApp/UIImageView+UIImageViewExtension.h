//
//  UIImageView+UIImageViewExtension.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 04.06.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (UIImageViewExtension)

- (void)setCornerRadius:(CGFloat)radius andBorderWidth:(CGFloat)width andBorderColor:(UIColor *)color;

@end
