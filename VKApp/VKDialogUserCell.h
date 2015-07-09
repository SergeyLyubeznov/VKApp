//
//  VKDialogUserCell.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 07.06.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKDialogUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDateMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowLabel;

@end
