//
//  VKModels.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 28.05.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VKSdk/VKSdk.h>
#import "VKModelsProtocolDelegate.h"

typedef enum : NSUInteger {
    kVKAllUsersGroup,
    kVKOnlineUsersGroup,
    kVKMutualUsersGroup,
} kVKUsersGroup;

@interface VKModels : NSObject

@property (strong, nonatomic) VKUsersArray *users;
@property (strong, nonatomic) VKUser *currentUser;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *prevUserID;
@property (weak, nonatomic) id<VKModelsProtocolDelegate> delegate;

- (void)loadWithUsersGroup:(kVKUsersGroup)group;
- (void)loadUser;
- (void)performFilteringWithFilter:(NSString *)filterString;
- (NSString *)onlineUser:(VKUser *)user;

@end
