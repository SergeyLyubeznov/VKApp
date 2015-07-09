//
//  NSDate+NSDateExtension.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 27.05.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDateExtension)

- (NSDate *)toLocalTime;
- (NSDate *)toGlobalTime;

@end
