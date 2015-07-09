//
//  VKMessagesModel.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 02.06.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VKSdk/VKSdk.h>
#import "VKModelsProtocolDelegate.h"

@interface VKMessagesModel : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, weak) id<VKModelsProtocolDelegate> delegate;
@property (nonatomic, strong) VKUsersArray *users;
@property (nonatomic, strong) VKUser *currentUser;
@property (strong, nonatomic) NSArray *messages;

- (void)loadDialogs;
- (void)loadUserMessages;

- (void)addMessage:(NSString *)messsage;
- (void)removeAllMessages;
@end
