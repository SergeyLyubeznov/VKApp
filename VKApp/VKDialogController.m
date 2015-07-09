//
//  VKDialogController.m
//  VKApp
//
//  Created by Sergey Lyubeznov on 04.06.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import "VKDialogController.h"
#import "VKDialogMyCell.h"
#import "VKDialogUserCell.h"
#import "VKMessagesModel.h"
#import "VKModelsProtocolDelegate.h"
#import "VKHelpMethods.h"

#import <VKSdk/VKSdk.h>

const CGFloat kVKTableCellHeight = 44.f;
const CGFloat kVKTableCellDeltaHeight = 17.f;

NSString *const messages [] = {@"12312312",@"asdasdasdas",@"123123sa",@"123",@"dgfsdgdggs43rdsfфывфывфывфывфыпфыпыфвфывыпфыв"};

@interface VKDialogController() <UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate, VKModelsProtocolDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) NSMutableArray *messages;

@property (assign, nonatomic) CGFloat keyboardHeight;

- (IBAction)actionSend:(UIButton *)sender;

@end

@implementation VKDialogController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:self.models.currentUser.first_name
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:nil];
    
    self.navigationItem.rightBarButtonItem  = item;
    
    
    if (self.models) {
        
        if (self.models.delegate != self) {
            __weak id weakSelf = self;
            self.models.delegate = weakSelf;
        }
        
        self.models.messages = [NSArray array];
        [self loadMessages];
    }
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    
//    self.messages = [NSMutableArray array];
//
//    for (int i = 0; i< 5; i++) {
//    
//        [self.messages addObject:messages[i]];
//    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//   self.tableView.rowHeight = UITableViewAutomaticDimension;
//  self.tableView.estimatedRowHeight = 17.f;
}

- (void)dealloc {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    
    NSLog(@"VKDialogController dead");
    
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

#pragma mark - Actions

- (void)actionSend:(UIButton *)sender {
    
    NSString *newMessage = self.textField.text;
    
    if ([newMessage length] == 0) {
        return;
    }
    [self.models addMessage:newMessage];
    self.textField.text = @"";
    
    [self updateTableView];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *message = [self.models.messages objectAtIndex:indexPath.row];
    
    
    NSString *messageBody = [message objectForKey:@"body"];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:messageBody];
    NSRange all = NSMakeRange(0, text.length);
    
    UIFont *font = [UIFont systemFontOfSize:14];
    
    UIColor *color = (indexPath.row % 2 == 0) ? [UIColor whiteColor] : [UIColor blackColor];
    
    [text addAttribute:NSFontAttributeName value:font range:all];
    [text addAttribute:NSForegroundColorAttributeName value:color range:all];
    
    CGSize theSize = [text boundingRectWithSize:CGSizeMake(220, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    CGFloat height;
    
    if (theSize.height == 0) {
        height = kVKTableCellHeight;
    } else {
        height = theSize.height + kVKTableCellDeltaHeight;
    }
    
    return height;

    return kVKTableCellDeltaHeight;

  
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.models.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return [self configureCellforIndexPath:indexPath];

}


#pragma mark - VKModelsProtocolDelegate

- (void)processCompleted {
    
    
    [self updateTableView];
}



#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self.textField becomeFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.textField resignFirstResponder];
    //[self changeContentViewPositionWithDirectionUP:NO];
    return YES;
}

#pragma mark - Private

- (void)loadMessages {
    
    [self.models loadUserMessages];
}

- (void)updateTableView {
    
    [self.tableView reloadData];
//    
//    if (self.models.messages.count > 0) {
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.models.messages.count-1 inSection:0]
//                              atScrollPosition:UITableViewScrollPositionBottom
//                                      animated:YES];
//    }
    
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
    
    
}

- (UITableViewCell *)configureCellforIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifierMy= @"VKDialogMyCell";
    static NSString *identifierUser= @"VKDialogUserCell";
    
    NSDictionary *message = [self.models.messages objectAtIndex:indexPath.row];
    

    NSString *messageBody = [message objectForKey:@"body"];
    
    NSNumber *dateN = [message objectForKey:@"date"];
    double dateD = dateN.doubleValue;
    
    NSString *date = [VKHelpMethods getStringDateByTimeInterval:dateD];
    
    NSString *fromID = [[message objectForKey:@"from_id"] stringValue];
    NSString *userID = [[message objectForKey:@"user_id"] stringValue];

    NSLog(@"row = %ld, text = %@",indexPath.row,messageBody);

    if (![fromID isEqualToString:userID]) {
        
        VKDialogMyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifierMy];
        cell.myMessageLabel.text = messageBody;
        cell.myDateMessageLabel.text = date;
        cell.rowLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        return cell;
        
    } else {
        
        VKDialogUserCell *cell =  [self.tableView dequeueReusableCellWithIdentifier:identifierUser];
        cell.userMessageLabel.text = messageBody;
        cell.userDateMessageLabel.text = date;
        cell.rowLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        return cell;
    }
    
    
}

-(void)keyboardShow:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    self.keyboardHeight = CGRectGetHeight(keyboardFrame);
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    [self changeContentViewPositionWithDirectionUP:YES];
}

-(void)keyboardHide:(NSNotification *)notification
{

    [self changeContentViewPositionWithDirectionUP:NO];
}

- (void)changeContentViewPositionWithDirectionUP:(BOOL)directUP {
        
        CGRect rect = [self getNewFrameWithFrame:self.tableView.frame andDirectUp:directUP];
        CGRect rect2 = [self getNewFrameWithFrame:self.toolBar.frame andDirectUp:directUP];
        
        [UIView animateWithDuration:0.3f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                         
                             self.tableView.frame = rect;
                             self.toolBar.frame = rect2;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             NSLog(@"finished animation");
                        
            
                         }
         ];
        
    
}

- (CGRect)getNewFrameWithFrame:(CGRect)frame andDirectUp:(BOOL)directUP {
    
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    CGFloat keyboardHeight = self.keyboardHeight;
    
    if (directUP) {
        keyboardHeight = -keyboardHeight;
    }
    
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y + keyboardHeight, width, height);
    
    return rect;
    
}


@end
