//
//  TestViewController.h
//  VODUploadDemo
//
//  Created by Worthy on 2017/11/9.
//

#import <UIKit/UIKit.h>

@interface SVideoViewController : UIViewController
@property(nonatomic, copy) NSString *keyId;
@property(nonatomic, copy) NSString *keySecret;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *expireTime;
@end
