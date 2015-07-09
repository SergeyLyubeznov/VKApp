//
//  VKFriendsController.m
//  VKApp
//
//  Created by Sergey Lyubeznov on 27.05.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import "VKFriendsController.h"
#import "VKFriendCell.h"
#import "VKImageModel.h"
#import "VKSection.h"

#import "NSDate+NSDateExtension.h"
#import "VKUserProfileController.h"
#import "VKModelsProtocolDelegate.h"
#import "VKManager.h"
#import "VKUtils.h"

static NSString *const kVKUserProfileController = @"VKUserProfileController";

@interface VKFriendsController () <VKModelsProtocolDelegate, UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *sections;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)actionSegmentedControl:(UISegmentedControl *)sender;


@end

@implementation VKFriendsController

- (void)dealloc
{
    NSLog(@"VKFriendsController dead");
}

#pragma mark - View Life Cicle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    if (self.models.delegate != self) {
        __weak id weakSelf = self;
        self.models.delegate = weakSelf;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(0, 0, 150, 50))];
   // searchBar.showsCancelButton = YES;
    self.searchBar = searchBar;
    searchBar.returnKeyType = UIReturnKeyDone;
    searchBar.delegate = self;
    [searchBar sizeToFit];
    searchBar.translucent = YES;
    [searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    UIView *barWrapper = [[UIView alloc]initWithFrame:searchBar.bounds];
    [barWrapper addSubview:searchBar];
    self.navigationItem.titleView = barWrapper;
    
    self.segmentedControl.selectedSegmentIndex = self.userGroup;
    //self.navigationItem.leftBarButtonItem.title = self.userID;
    NSLog(@"item title = %@",[[self.navigationController.navigationBar.items objectAtIndex:0] title]);
    
    if (!self.models) {
        self.models = [VKManager sharedManager].models;
    }
    
    if (![VKManager sharedManager].loadingFromMenu) {
        
        self.navigationItem.leftItemsSupplementBackButton = YES;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Accessors

- (void)setModels:(VKModels *)models {
    
    _models = models;
    
    if (_models) {
        self.userID = models.currentUser.id.stringValue;
        __weak id weakObject = self;
        _models.delegate = weakObject;
        [self loadWithGroup:self.userGroup];
    }
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

- (UIViewController *)getUserProfileController {
    
    NSArray *arrayVC = [self.navigationController viewControllers];
    
    return [arrayVC objectAtIndex:1];
}

- (VKUser *)getModelByIndexPath:(NSIndexPath *)indexPath {
    
    VKSection *sec = [self.sections objectAtIndex:indexPath.section];
    return [sec.items objectAtIndex:indexPath.row];
    
}

- (void)creatSections {
    
    self.sections = [NSMutableArray array];
    VKSection *section = nil;
    NSString *firstLetter = @"";
    
    for (VKUser *user in self.models.users) {
    
        firstLetter = [user.first_name substringToIndex:1];
        
        section = [self.sections lastObject];
        
        if ([section.sectionName isEqualToString:firstLetter]) {
            
            [section.items addObject:user];
            
        } else {
            
            section = [[VKSection alloc]init];
            section.sectionName = firstLetter;
            section.items = [NSMutableArray array];
            [section.items addObject:user];
            
            [self.sections addObject:section];
            
        }
        
    }
    
}

-(void)loadWithGroup:(kVKUsersGroup)userGroup {
    
    [self.models loadWithUsersGroup:userGroup];
}

- (void)performPushViewControllerWithUserID:(NSString *)userID {
    
    VKUserProfileController *vc = [self.storyboard instantiateViewControllerWithIdentifier:kVKUserProfileController];
    self.models.userID = userID;
    self.models.delegate = vc;
    vc.models = self.models;
    [vc loadUserInfo];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                      style:
                                           UIBarButtonItemStylePlain target: nil
                                                                     action: nil];

    self.navigationItem.backBarButtonItem = backBarButton;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)home {

    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:1];
    self.models.userID = self.models.prevUserID = [[VKSdk getAccessToken] userId];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)initCellWithVKUser:(VKFriendCell *)cell user:(VKUser *)user {
    
    NSString *firstName = user.first_name;
    NSString *lastName = user.last_name;
    NSString *photoURL = user.photo_50;
    NSString *lastSeen = [self.models onlineUser:user];
    
    NSLog(@"%@ %@ - %@",firstName,lastName,lastSeen);
    
    cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@",firstName, lastName];
    cell.userOnlineLabel.text = lastSeen;
    
    
    if (!cell.imageModel) {
        [cell initImageModel];
    }
    cell.cellIndicatorView.hidden = NO;
    cell.activityIndicator.hidden = NO;
    [cell.activityIndicator startAnimating];
    cell.userImageView.image = nil;
    cell.imageModel.imageUrl = photoURL;
    

}


#pragma mark - UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (VKSection *section in self.sections) {
        [array addObject:section.sectionName];
    }
    
    return array;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    VKSection *sec = [self.sections objectAtIndex:section];
    return sec.sectionName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    VKSection *sec = [self.sections objectAtIndex:section];
    return [sec.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"VKFriendCell";
    
    VKFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[VKFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        NSLog(@"created new cell");
    }else {
        NSLog(@"reused cell");
    }
    
    VKUser *user = [self getModelByIndexPath:indexPath];
    
    [self initCellWithVKUser:cell user:user];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //UserProfileController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileController"];
    
    //[self.navigationController showViewController:vc sender:self];
    
    //[self performSegueWithIdentifier:NEXT_CONTROLLER_SEGUE_ID sender:self];
    
    VKUser *user = [self getModelByIndexPath:indexPath];
    self.models.prevUserID = self.models.userID;
    [self performPushViewControllerWithUserID:user.id.stringValue];

    
}

#pragma mark - VKModelsProtocolDelegate

- (void)processCompleted {
    [self creatSections];
    self.indicatorView.hidden = YES;
    [self.tableView reloadData];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSLog(@"textDidChange - %@",searchText);
    
    if ([searchText length]) {
        [self.models performFilteringWithFilter:searchText];
    }
    else {
        [self loadWithGroup:self.segmentedControl.selectedSegmentIndex];
    }
    
    
}


#pragma mark - Actions

- (IBAction)actionSegmentedControl:(UISegmentedControl *)sender {
    
    NSLog(@"segment = %ld",sender.selectedSegmentIndex);
    [self loadWithGroup:sender.selectedSegmentIndex];
}
@end

