//
//  VKManager.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 07.07.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VKModels;

@interface VKManager : NSObject

@property (strong, nonatomic) NSString *currentUserID;
@property (strong, nonatomic) NSString *photoUrl;
@property (strong, nonatomic) VKModels *models;
@property (assign, nonatomic, getter=isLoadingFromMenu) BOOL loadingFromMenu;
@property (assign, nonatomic, getter=isExit) BOOL exit;

+ (VKManager *)sharedManager;

@end
