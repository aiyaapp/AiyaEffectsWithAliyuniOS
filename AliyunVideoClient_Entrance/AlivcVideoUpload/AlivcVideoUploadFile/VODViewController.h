//
//  ViewController.h
//  VODUploadDemo
//
//  Created by Leigang on 16/4/19.
//
//

#import <UIKit/UIKit.h>

@interface VODViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, copy) NSString *keyId;
@property(nonatomic, copy) NSString *keySecret;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *expireTime;
@end

