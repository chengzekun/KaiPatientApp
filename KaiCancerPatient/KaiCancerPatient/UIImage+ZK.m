//
//  UIImage+ZK.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/7/28.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "UIImage+ZK.h"

@implementation UIImage (ZK)
- (UIImage *)cropImageWithSize:(CGSize)size {
    float scale = self.size.width/self.size.height;
    CGRect rect = CGRectMake(0, 0, 0, 0);
    if (scale > size.width/size.height) {
        rect.origin.x = (self.size.width - self.size.height * size.width/size.height)/2;
        rect.size.width  = self.size.height * size.width/size.height;
        rect.size.height = self.size.height;
    }else {
        rect.origin.y = (self.size.height - self.size.width/size.width * size.height)/2;
        rect.size.width  = self.size.width;
        rect.size.height = self.size.width/size.width * size.height;
    }
    CGImageRef imageRef   = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
   return croppedImage;
}
@end
