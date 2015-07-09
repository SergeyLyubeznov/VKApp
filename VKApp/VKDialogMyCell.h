//
//  VKDialogCell.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 06.06.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKDialogMyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *myMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *myDateMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowLabel;


@end
