//
//  VKMessagesModel.m
//  VKApp
//
//  Created by Sergey Lyubeznov on 02.06.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import "VKMessagesModel.h"
#import "VKHelpMethods.h"


@interface VKMessagesModel()

@property (strong, nonatomic) NSMutableArray *mutableMessages;

@end

@implementation VKMessagesModel


#pragma mark - Accessors

-(NSArray *)messages {
    
    return [self.mutableMessages copy];
    
}


#pragma mark - Public Methods

- (void)addMessage:(NSString *)message {
    
    NSNumber *userId = [self getNSNumberWithNSString:self.userID];
    NSNumber *myID = [self getNSNumberWithNSString:[[VKSdk getAccessToken] userId]];
    
    NSDate *dateNow = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    double timeStamp = [dateNow timeIntervalSince1970];
    NSNumber *date = [[NSNumber alloc] initWithDouble:timeStamp];

    
    NSDictionary *messageBox = @{@"body":message,@"from_id:":myID,@"user_id":userId,@"date":date};
    [self.mutableMessages addObject:messageBox];
    
}

- (NSNumber *)getNSNumberWithNSString:(NSString *)string {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *number = [numberFormatter numberFromString:string];
    
    return number;
}

- (void)removeAllMessages {
    
    [self.mutableMessages removeAllObjects];
    
}

- (void)loadUserMessages {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        __block NSDictionary *messages;
        VKRequest *request = [VKRequest requestWithMethod:@"messages.getHistory" andParameters:@{@"count":@"50",@"user_id":self.userID} andHttpMethod:@"GET"];
        request.waitUntilDone = YES;
        [request setPreferredLang:@"ru"];
        [request executeWithResultBlock:^(VKResponse *response)
         {
             messages = response.json;
         }
                             errorBlock:^(NSError *error)
         {
             
         }];
        
        NSArray *array = [messages objectForKey:@"items"];
        
        array = [[array reverseObjectEnumerator] allObjects];
        
        self.mutableMessages = [NSMutableArray arrayWithArray:array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate processCompleted];
        });
    });


}

-(void)loadDialogs {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        __block NSDictionary *dialogs;
        VKRequest *request = [VKRequest requestWithMethod:@"messages.getDialogs" andParameters:@{@"count":@"20"} andHttpMethod:@"GET"];
        request.waitUntilDone = YES;
        [request setPreferredLang:@"ru"];
        [request executeWithResultBlock:^(VKResponse *response)
         {
             dialogs = response.json;
         }
                             errorBlock:^(NSError *error)
         {
             
         }];
        
        NSArray *array = [dialogs objectForKey:@"items"];
        self.mutableMessages = [NSMutableArray arrayWithArray:array];
        [self loadUsers];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate processCompleted];
        });
    });

}

- (void)loadUsers {
    
    
    __block VKUsersArray *users;
    NSString *uids = [self getUserUIDs];
    VKRequest *request = [[VKApi users] get:@{VK_API_FIELDS:@"first_name, last_name, photo_50", VK_API_USER_IDS:uids}];
    request.waitUntilDone = YES;
    [request setPreferredLang:@"ru"];
    [request executeWithResultBlock:^(VKResponse *response)
     {
         users = response.parsedModel;
     }
                         errorBlock:^(NSError *error)
     {
         
     }];
    
    self.users = users;
    
}

- (NSString *)getUserUIDs {
    
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in self.messages ) {
        NSString *uid = [[dic objectForKey:@"message"] objectForKey:@"user_id"];
        [result addObject:uid];
    }
    
    NSString *uids = [result componentsJoinedByString:@","];
    return uids;
    
}

@end
