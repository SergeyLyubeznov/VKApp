//
//  UserProfileController.m
//  VKApp
//
//  Created by Sergey Lyubeznov on 27.05.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import "VKUserProfileController.h"
#import "VKFriendsController.h"
#import "VKLeftMenuController.h"

#import "VKModels.h"
#import "VKImageModel.h"
#import "UIImageView+UIImageViewExtension.h"

#import "VKManager.h"
#import "VKUtils.h"

static NSString *const kVKFriendsController = @"VKFriendsController";

@interface VKUserProfileController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (assign,  nonatomic) BOOL isMenuOpen;
@property (strong, nonatomic) VKImageModel *imageModel;

- (IBAction)actionFriends:(UIButton *)sender;
- (IBAction)actionMutualFriends:(UIButton *)sender;

@end

@implementation VKUserProfileController

- (void)dealloc
{
    NSLog(@"VKUserProfileController dead");
    self.models.userID = self.models.prevUserID;

  
}

#pragma View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    if (!self.models) {
        self.models = [[VKModels alloc]init];
        [VKManager sharedManager].models = self.models;
        __weak id weakObject = self;
        self.models.delegate = weakObject;
        self.models.userID = [[VKSdk getAccessToken] userId];
        self.models.prevUserID = self.models.userID;
        [self loadUserInfo];
    }
    
    NSInteger countVC = [self.navigationController.viewControllers count];
    NSLog(@"%ld",countVC);
    
    
    if (self.models.userID != [[VKSdk getAccessToken] userId]) {
        
        self.navigationItem.leftItemsSupplementBackButton = YES;
    
    }
    
    [self.userImageView setCornerRadius:50.f andBorderWidth:0.f andBorderColor:[UIColor blackColor]];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}




#pragma mark - Private Methods

- (void)showUserViews {
    
    VKUser *user = self.models.currentUser;
    
    self.friendsView.hidden = [[[user counters] friends]integerValue] ? NO : YES;
    self.groupsView.hidden = [[[user counters] groups]integerValue] ? NO : YES;
    self.audioView.hidden = [[[user counters] audios]integerValue] ? NO : YES;
    self.moviesView.hidden = [[[user counters] videos]integerValue] ? NO : YES;
    self.followersView.hidden = [[[user counters] followers]integerValue] ? NO : YES;
    self.photosView.hidden = [[[user counters] photos]integerValue] ? NO : YES;
    self.mutualView.hidden = [[[user counters] mutual_friends]integerValue] ? NO : YES;
    
}

- (void)initProfile {
    
    VKUser *user = self.models.currentUser;
    
    NSString *firstName = [user first_name];
    NSString *lastName = [user last_name];
    NSString *photoUrl = [user photo_100];
    NSString *bdate = [user bdate];
    NSString *city = [[user city] title] ? [[user city] title] : [user home_town];
    
    NSString *cityAndAge = [NSString stringWithFormat:@"%@, %@",city,bdate];
    
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    self.friendsLabel.text = [NSString stringWithFormat:@"%ld\n%@",[[[user counters] friends] integerValue],@"Друзья"];
    self.moviesLabel.text = [NSString stringWithFormat:@"%ld\n%@",[[[user counters] videos] integerValue],@"Видео"];
    self.audioLabel.text = [NSString stringWithFormat:@"%ld\n%@",[[[user counters] audios] integerValue],@"Аудио"];
    self.followersLabel.text = [NSString stringWithFormat:@"%ld\n%@",[[[user counters] followers] integerValue],@"Подписч."];
    self.photosLabel.text = [NSString stringWithFormat:@"%ld\n%@",[[[user counters] photos] integerValue],@"Фото"];
    self.groupsLabel.text = [NSString stringWithFormat:@"%ld\n%@",[[[user counters] groups] integerValue],@"Группы"];
    self.mutualFriendsLabel.text = [NSString stringWithFormat:@"%ld\n%@",[[[user counters] mutual_friends] integerValue],@"Общие"];
    self.onlineLabel.text = [self.models onlineUser:user];
    self.cityAndAgeLabel.text = cityAndAge;
    self.navigationItem.title = firstName;
    
    
    if (!self.imageModel) {
        self.imageModel = [[VKImageModel alloc]init];
        __weak id weakSelf = self;
        self.imageModel.delegate = weakSelf;
        self.imageModel.imageUrl = photoUrl;
    } else {
        
        self.imageModel.imageUrl = photoUrl;
    }
    
}

- (void)loadUserInfo {
    
    if (self.models.userID) {
        [self.models loadUser];
        
    }
}

- (void)performPushControllerWithUserGroup:(kVKUsersGroup)userGroup {
    
    UIStoryboard *storyboard = mainStoryboard();
    
    VKFriendsController *vc = [storyboard instantiateViewControllerWithIdentifier:kVKFriendsController];
    vc.userGroup = userGroup;
    vc.models = self.models;
    [VKManager sharedManager].loadingFromMenu = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - VKModelsProtocolDelegate

- (void)processCompleted {
    
    [self initProfile];
    [self showUserViews];
}

- (void)processCompletedImage {
    
    self.userImageView.image = self.imageModel.image;
   }

#pragma mark - Actions

- (IBAction)actionLogout:(UIButton *)sender {
    
    [VKSdk forceLogout];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionFriends:(UIButton *)sender {
    
    [self performPushControllerWithUserGroup:kVKAllUsersGroup];
}

- (IBAction)actionMutualFriends:(UIButton *)sender {
    
    [self performPushControllerWithUserGroup:kVKMutualUsersGroup];
}

@end
