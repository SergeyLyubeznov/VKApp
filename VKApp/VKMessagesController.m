//
//  VKMessagesController.m
//  VKApp
//
//  Created by Sergey Lyubeznov on 02.06.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import "VKMessagesController.h"
#import "VKMessagesModel.h"
#import "VKMessageCell.h"
#import "VKHelpMethods.h"
//#import "VKModelsProtocolDelegate.h"
#import <VKSdk/VKSdk.h>
#import "VKDialogController.h"

static NSString *const kVKDialogController = @"VKDialogController";


@interface VKMessagesController () <UITableViewDelegate, UITableViewDataSource, VKModelsProtocolDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;

@property (strong, nonatomic) VKMessagesModel *models;


@end

@implementation VKMessagesController

#pragma mark - View Life Cycle

- (void)dealloc
{
    NSLog(@"VKMessagesController dead");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    if (self.models.delegate != self) {
        __weak id weakSelf = self;
        self.models.delegate = weakSelf;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.models = [[VKMessagesModel alloc] init];
    self.models.userID = [[VKSdk getAccessToken] userId];
    
    self.navigationItem.title = @"Диалоги";
    
    [self loadMessages];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    //return [VKManager sharedManager].isLoadingFromMenu;
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}


#pragma mark - Private Methods 

- (void)initCellWithIndex:(VKMessageCell *)cell user:(NSInteger)index {
    
    VKUser *user = [self.models.users objectAtIndex:index];
    NSDictionary *message = [[self.models.messages objectAtIndex:index] objectForKey:@"message"];
    
    NSString *firstName = user.first_name;
    NSString *lastName = user.last_name;
    NSString *messageTitle = [message objectForKey:@"body"];
    NSString *photoURL = user.photo_50;
    NSNumber *dateN = [message objectForKey:@"date"];
    double dateD = dateN.doubleValue;
    
    NSString *date = [VKHelpMethods getStringDateByTimeInterval:dateD];
    
    cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@",firstName, lastName];
    cell.messageDateLabel.text = date;
    cell.messageTitleLabel.text = messageTitle;
    
    if (!cell.imageModel) {
        [cell initImageModel];
    }
    cell.cellIndicatorView.hidden = NO;
    cell.activityIndicator.hidden = NO;
    [cell.activityIndicator startAnimating];
    cell.userImageView.image = nil;
    cell.imageModel.imageUrl = photoURL;
    
    
}

- (void)loadMessages {
    
    [self.models loadDialogs];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.models.users.items count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"VKMessageCell";
    
    VKMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[VKMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        // NSLog(@"created new cell");
    }else {
        // NSLog(@"reused cell");
    }
    
  
    
    [self initCellWithIndex:cell user:indexPath.row];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    VKDialogController *vc = [self.storyboard instantiateViewControllerWithIdentifier:kVKDialogController];
    VKUser *user = [self.models.users objectAtIndex:indexPath.row];
    self.models.userID = [user.id stringValue];
    self.models.currentUser = user;
    [self.models removeAllMessages];
    vc.models = self.models;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - VKModelsProtocolDelegate

- (void)processCompleted {
    
    self.indicatorView.hidden = YES;
    [self.tableView reloadData];
    
}



@end
