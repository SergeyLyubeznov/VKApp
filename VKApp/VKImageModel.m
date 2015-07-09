//
//  VKImageModel.m
//  VKApp
//
//  Created by Sergey Lyubeznov on 28.05.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

// return true if the device has a retina display, false otherwise
#define IS_RETINA_DISPLAY() [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f

// return the scale value based on device's display (2 retina, 1 other)
#define DISPLAY_SCALE IS_RETINA_DISPLAY() ? 2.0f : 1.0f

// if the device has a retina display return the real scaled pixel size, otherwise the same size will be returned
#define PIXEL_SIZE(size) IS_RETINA_DISPLAY() ? CGSizeMake(size.width/2.0f, size.height/2.0f) : size

#import "VKImageModel.h"

@implementation VKImageModel


#pragma mark - Accessors

- (void)setImageUrl:(NSString *)imageUrl {
    
    _imageUrl = imageUrl;
    
    if (_imageUrl) {
        [self load];
    }
    
}
#pragma mark - Public Methods

- (void)load {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        /* Код, который должен выполниться в фоне */
        NSURL* aURL = [NSURL URLWithString:self.imageUrl];
        NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
        UIImage *helpImage = [UIImage imageWithData:data];
         UIImage *image = [UIImage imageWithCGImage:helpImage.CGImage scale:DISPLAY_SCALE orientation:UIImageOrientationUp];
        
        self.image = image;
        
        
       // sleep(arc4random_uniform(2));
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate processCompletedImage];
        });
    });
    
}

@end
