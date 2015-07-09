//
//  VKManager.m
//  VKApp
//
//  Created by Sergey Lyubeznov on 07.07.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import "VKManager.h"

@implementation VKManager

+ (VKManager *)sharedManager {
    
    static VKManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VKManager alloc] init];
        manager.exit = NO;
        manager.loadingFromMenu = NO;
        manager.photoUrl = @"https://pp.vk.me/c620825/v620825385/2aaf/jJfLVw9-3FQ.jpg";
    });
    
    return manager;
    
}

@end
