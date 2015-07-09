//
//  VKLeftMenuController.m
//  VKApp
//
//  Created by Sergey Lyubeznov on 07.07.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import "VKLeftMenuController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"

#import "VKFriendsController.h"
#import "VKLeftMenuCell.h"
#import "VKManager.h"
#import "UIImageView+UIImageViewExtension.h"

#import "UIImageView+WebCache.h"


@interface VKLeftMenuController()

@property (assign, nonatomic) BOOL exit;

@end


@implementation VKLeftMenuController



#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.slideOutAnimationEnabled = YES;
    
    return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
    //self.tableView.backgroundView = imageView;
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VKLeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VKLeftMenuCell"];
    
    if (indexPath.row == 0) {
        
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:[VKManager sharedManager].photoUrl]
                          placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     cell.userImageView.image = image;
                                     [cell.userImageView setCornerRadius:20.f andBorderWidth:0.f andBorderColor:[UIColor blackColor]];
                                 }];
    }
    
    switch (indexPath.row)
    {
        case 0:
            cell.titleLabel.text = @"Домой";
            //cell.picImageView.image = [UIImage imageNamed:@"home_50.png"];
            
            break;
            
        case 1:
            cell.titleLabel.text = @"Друзья";
            cell.picImageView.image = [UIImage imageNamed:@"friends_50.png"];
            break;
            
        case 2:
            cell.titleLabel.text = @"Сообщения";
            cell.picImageView.image = [UIImage imageNamed:@"messages_50.png"];

            break;
            
        case 3:
            cell.titleLabel.text = @"Выход";
            cell.picImageView.image = [UIImage imageNamed:@"exit_50.png"];
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
     [VKManager sharedManager].loadingFromMenu = YES;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UIViewController *vc ;
    
    if (indexPath.row == 0 || indexPath.row == 3) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    switch (indexPath.row)
    {
        case 0:
//            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"UserProfileController"];
//            break;
            
            [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
            return;
            
        case 1:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"VKFriendsController"];
            
            break;
            
        case 2:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"VKMessagesController"];
            break;
            
        case 3:
            
            [self showExitAlert];
            return;
            
            
    }
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    self.exit = (buttonIndex)? YES : NO;

}

#pragma mark - Private Methods

- (void)showExitAlert {
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@"Вы точно хотите выйти?"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Выйти"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
                             [VKManager sharedManager].exit = YES;
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Отмена"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [view addAction:ok];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
    
    
}

@end
