//
//  VKFriendsController.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 27.05.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk/VKSdk.h>
#import "SlideNavigationController.h"
#import "VKModels.h"

@interface VKFriendsController : UIViewController<SlideNavigationControllerDelegate>

@property (strong, nonatomic) NSString *userID;
@property (assign, nonatomic) kVKUsersGroup userGroup;
@property (strong, nonatomic) VKModels *models;

@end
