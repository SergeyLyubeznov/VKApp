//
//  ViewController.m
//  VKApp
//
//  Created by Sergey Lyubeznov on 26.05.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import "VKLoginController.h"
#import "VKUserProfileController.h"
#import "VKManager.h"


static NSString *const kVKAPI_KEY = @"4933789";
static NSString *const TOKEN_KEY = @"my_application_access_token";
static NSString *const NEXT_CONTROLLER_SEGUE_ID = @"USER_INFO";
static NSArray  * SCOPE = nil;

@interface VKLoginController () 

- (IBAction)actionAuthorize:(UIButton *)sender;
@end

@implementation VKLoginController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
    
    [VKSdk initializeWithDelegate:self andAppId:kVKAPI_KEY];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"123"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    if ([VKSdk wakeUpSession]) {
        NSLog(@"session up");
        [self startWorking];
    } else {
        NSLog(@"session down");
        [VKSdk authorize:SCOPE revokeAccess:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([VKManager sharedManager].isExit && [VKSdk isLoggedIn]) {
        [VKSdk forceLogout];
        [VKManager sharedManager].models = nil;
        [VKSdk authorize:SCOPE revokeAccess:YES];
        return;
    }
    
    if ([VKManager sharedManager].isLoadingFromMenu && [VKSdk isLoggedIn]) {
        [self startWorking];
        
    }
    
}

#pragma mark - Actions

- (IBAction)actionAuthorize:(UIButton *)sender {
    if ([VKSdk isLoggedIn]) {
        [self startWorking];
    } else {
        [VKSdk authorize:SCOPE revokeAccess:YES];
    }
    
}

#pragma mark - Private Methods

- (void)startWorking {
    [VKManager sharedManager].exit = NO;
   [self performSegueWithIdentifier:NEXT_CONTROLLER_SEGUE_ID sender:self];
    
}


#pragma mark - VKSdkDelegate



- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.navigationController.topViewController];
}


- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    [self actionAuthorize:nil];
}


- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
    NSLog(@"access denied");
}


- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    
    [self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
}


- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    [self startWorking];
}


@end