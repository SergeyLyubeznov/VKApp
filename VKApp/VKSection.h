//
//  VKSection.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 28.05.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKSection : NSObject

@property (strong, nonatomic) NSString *sectionName;
@property (strong, nonatomic) NSMutableArray *items;

@end
