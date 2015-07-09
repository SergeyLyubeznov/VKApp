//
//  VKDialogController.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 04.06.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@class VKMessagesModel;

@interface VKDialogController : UIViewController<SlideNavigationControllerDelegate>

@property (strong, nonatomic) VKMessagesModel *models;

@end
