//
//  OSSViewController.h
//  VODUploadDemo
//
//  Created by Worthy on 2018/1/8.
//

#import <UIKit/UIKit.h>

@interface OSSViewController : UIViewController
@property(nonatomic, copy) NSString *keyId;
@property(nonatomic, copy) NSString *keySecret;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *expireTime;
@property(nonatomic, copy) NSString* endpoint;
@property(nonatomic, copy) NSString* bucket;
@property(nonatomic, copy) NSString* prefix;
@end
