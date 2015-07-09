//
//  UserProfileController.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 27.05.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk/VKSdk.h>
#import "VKModelsProtocolDelegate.h"
#import "SlideNavigationController.h"

@class VKModels;

@interface VKUserProfileController : UIViewController<VKModelsProtocolDelegate, SlideNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityAndAgeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) VKModels *models;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupsLabel;
@property (weak, nonatomic) IBOutlet UILabel *photosLabel;
@property (weak, nonatomic) IBOutlet UILabel *moviesLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioLabel;
@property (weak, nonatomic) IBOutlet UILabel *mutualFriendsLabel;
@property (weak, nonatomic) IBOutlet UIView *friendsView;
@property (weak, nonatomic) IBOutlet UIView *groupsView;
@property (weak, nonatomic) IBOutlet UIView *photosView;
@property (weak, nonatomic) IBOutlet UIView *moviesView;
@property (weak, nonatomic) IBOutlet UIView *followersView;
@property (weak, nonatomic) IBOutlet UIView *audioView;
@property (weak, nonatomic) IBOutlet UIView *mutualView;


@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;

- (void)loadUserInfo;

@end
