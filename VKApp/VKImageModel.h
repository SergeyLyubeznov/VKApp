//
//  VKImageModel.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 28.05.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VKModelsProtocolDelegate.h"

@interface VKImageModel : NSObject

@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) id<VKModelsProtocolDelegate> delegate;

- (void)load;

@end
