//
//  VKFriendCell.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 27.05.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKModelsProtocolDelegate.h"
#import "VKImageModel.h"

@interface VKFriendCell : UITableViewCell <VKModelsProtocolDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userOnlineLabel;
@property (weak, nonatomic) IBOutlet UIView *cellIndicatorView;
@property (strong, nonatomic) VKImageModel *imageModel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)initImageModel;

@end
