//
//  UIImage+AlivcHelper.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/9.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "UIImage+AlivcHelper.h"

@implementation UIImage (AlivcHelper)

+ (UIImage *)avc_imageWithColor:(UIColor *)color {
    return [self avc_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)avc_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}@end
