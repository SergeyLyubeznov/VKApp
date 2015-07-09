//
//  VKModels.m
//  VKApp
//
//  Created by Sergey Lyubeznov on 28.05.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import "VKModels.h"
#import "VKHelpMethods.h"

NSString *const fields = @"first_name, last_name, uid, photo_50, photo_100, online, online_mobile, last_seen";
static NSString *const ALL_USER_FIELDS = @"id,first_name,last_name,sex,bdate,city,home_town,country,photo_50,photo_100,photo_200_orig,photo_200,photo_400_orig,photo_max,photo_max_orig,online,online_mobile,lists,domain,has_mobile,contacts,connections,site,education,universities,schools,can_post,can_see_all_posts,can_see_audio,can_write_private_message,status,last_seen,common_count,relation,relatives,counters";

@interface VKModels()

@property (strong, nonatomic) VKUsersArray *usersBackup;


@end

@implementation VKModels

#pragma mark - Initializations 

- (instancetype)initWithUserID:(NSString *)userID
{
    self = [super init];
    if (self) {
        self.userID = userID;
    }
    return self;
}

#pragma mark - Public Methods

- (void)loadUser {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        __block VKUsersArray *users;
        VKRequest *request = [[VKApi users] get:@{VK_API_FIELDS:ALL_USER_FIELDS, VK_API_USER_ID:self.userID}];
        request.waitUntilDone = YES;
        [request setPreferredLang:@"ru"];
        [request executeWithResultBlock:^(VKResponse *response)
         {
             users = response.parsedModel;
         }
                             errorBlock:^(NSError *error)
         {
             
         }];
        
        self.currentUser =  [users lastObject];
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate processCompleted];
        });
    });

    
}

- (void)performFilteringWithFilter:(NSString *)filterString {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSMutableArray *filteredArray = [NSMutableArray arrayWithArray:self.usersBackup.items];
        
        NSString *filter = [filterString lowercaseString];
        NSString *name = @"";
        
        for (VKUser *user in self.usersBackup.items) {
            
            name = [user.first_name lowercaseString];
            
            if ([name rangeOfString:filter].location == NSNotFound) {
                [filteredArray removeObject:user];
            }
        }
        
       self.users  = [[VKUsersArray alloc] initWithArray:[self sortArrayWithArray:filteredArray]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.delegate processCompleted];
        });
    });
    
}

- (void)loadWithUsersGroup:(kVKUsersGroup)group {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* Код, который должен выполниться в фоне */
        
        __block VKUsersArray *users = nil;
        NSString *listUIDS = nil;
        VKRequest *request = nil;
        
        if (group == kVKAllUsersGroup) {
            listUIDS = self.userID;
            
        }
        
        if (group == kVKOnlineUsersGroup) {
            listUIDS = [self getUsersUIDsByRequestMethod:@"friends.getOnline" andParams:@{@"user_id":self.userID}];
                    }
        
        if (group == kVKMutualUsersGroup && self.userID != [[VKSdk getAccessToken] userId]) {
            listUIDS = [self getUsersUIDsByRequestMethod:@"friends.getMutual" andParams:@{@"target_uid":self.userID}];
        }
        
        if (listUIDS) {
            
            request = [self getRequestByUserGroup:group andUserIDs:listUIDS];
            request.waitUntilDone = YES;
            [request setPreferredLang:@"ru"];
            [request executeWithResultBlock:^(VKResponse *response)
             {
                 users = response.parsedModel;
             }
                                 errorBlock:^(NSError *error)
             {
                 NSLog(@"%@",error);
             }];
            
            
            self.users  = [[VKUsersArray alloc] initWithArray:[self sortArrayWithArray:users.items]];
            self.usersBackup = self.users;
            
            //[self creatModels];
        
        } else {
            
            self.users = [[VKUsersArray alloc] init];
        }
        
        
        //sleep(arc4random_uniform(2));
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate processCompleted];
            
            
        });
        
    });
    
}

#pragma mark - Private Methods

- (VKRequest *)getRequestByUserGroup:(kVKUsersGroup)group andUserIDs:(NSString *)uIDS {
    
    VKRequest *request = nil;
    
    switch (group) {
        case kVKAllUsersGroup:
            request = [[VKApi friends] get:@{VK_API_FIELDS:fields,VK_API_USER_ID:uIDS}];
            break;
        case kVKMutualUsersGroup:
        case kVKOnlineUsersGroup:
            request = [[VKApi users] get:@{VK_API_FIELDS:fields,VK_API_USER_IDS:uIDS}];

            break;
            
        default:
            break;
    }
    
    return request;
}

- (NSString *)getUsersUIDsByRequestMethod:(NSString *)method andParams:(NSDictionary *)params {
    
    VKRequest *request = [VKRequest requestWithMethod:method andParameters:params andHttpMethod:@"GET"];
    
    __block NSArray *arrayUIDS = [NSArray array];
    
    request.waitUntilDone = YES;
    
    [request executeWithResultBlock:^(VKResponse *response) {
        
        arrayUIDS = response.json;
        
    } errorBlock:^(NSError *error) {
        
    }];
    
    NSString *resultString = ([arrayUIDS count]) ?[arrayUIDS componentsJoinedByString:@","]:nil;
    
    return resultString;
}

- (NSString *)onlineUser:(VKUser *)user {
    
    NSString *lastSeen = @"";
    
    
    BOOL isOnline = [[user online] boolValue] | [[user online_mobile] boolValue];
    NSLog(@"%d",isOnline);
    
    if (!isOnline) {
        
        double last_seen = [[[user last_seen] time] doubleValue];
        lastSeen = [VKHelpMethods getStringDateByTimeInterval:last_seen];
    } else {
        lastSeen = @"Online";
    }
    
    return lastSeen;
    
}



- (NSMutableArray *)sortArrayWithArray:(NSMutableArray *)array {
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"first_name" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"last_name" ascending:YES];
    
    NSMutableArray *newArray2 = (NSMutableArray *)[array sortedArrayUsingDescriptors:@[sortDescriptor,sortDescriptor2]];
    
//    NSArray *newArray = [array sortedArrayUsingComparator:^NSComparisonResult(VKModel *obj1, VKModel *obj2) {
//        return [obj1.firstName compare:obj2.firstName];
//    }];
    
    
    
    return newArray2;
    
}










@end
