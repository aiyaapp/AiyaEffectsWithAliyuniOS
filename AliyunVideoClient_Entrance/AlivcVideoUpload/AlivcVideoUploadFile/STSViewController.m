//
//  STSViewController.m
//  VODUploadDemo
//
//  Created by Worthy on 2018/1/5.
//

#import "STSViewController.h"
#import "DemoApi.h"
#import "VODViewController.h"
#import "SVideoViewController.h"
#import "OSSViewController.h"
@interface STSViewController ()

@end

@implementation STSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *fetch = [UIButton buttonWithType:UIButtonTypeSystem];
    fetch.frame = CGRectMake(100, 100, 60, 44);
    [fetch setTitle:@"获取STS" forState:UIControlStateNormal];
    [fetch addTarget:self action:@selector(fetchClicked) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:fetch];

    
    if(_type == UploadTypeVOD){
        self.navigationItem.title = @"VOD列表上传";
    }else if(_type == UploadTypeOSS){
        self.navigationItem.title = @"OSS列表上传";
    }else{
        self.navigationItem.title = @"短视频场景上传";
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];


}


- (void)fetchClicked {
    
    if (_type == UploadTypeOSS) {
        OSSViewController *oss = [OSSViewController new];

        oss.title = @"OSS列表上传";
        [self.navigationController pushViewController:oss animated:YES];
        
    }else{
        [DemoApi requestSTSWithHandler:^(NSString *keyId, NSString *keySecret, NSString *token, NSString *expireTime, NSError *error) {
            if (error) {
                NSLog(@"GET STS FAILED:%@", error.description);
                return;
            };
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_type == UploadTypeSVideo) {
                    SVideoViewController *vc = [SVideoViewController new];
                    vc.title = @"短视频场景上传";

                    vc.keyId = keyId;
                    vc.keySecret = keySecret;
                    vc.token = token;
                    vc.expireTime = expireTime;
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    VODViewController *vc = [VODViewController new];

                    vc.title = @"VOD列表上传";

                    vc.keyId = keyId;
                    vc.keySecret = keySecret;
                    vc.token = token;
                    vc.expireTime = expireTime;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            });
        }];
    }
    
}
- (BOOL)shouldAutorotate
{
    return NO;
}
@end
