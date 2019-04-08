//
//  ViewController.h
//  VODUploadDemo
//
//  Created by Leigang on 16/4/19.
//  上传主界面
//

#import <UIKit/UIKit.h>

@interface AVC_VU_MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableFiles;

@end

