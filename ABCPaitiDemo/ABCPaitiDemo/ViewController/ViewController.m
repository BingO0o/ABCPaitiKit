//
//  ViewController.m
//  ABCPaitiDemo
//
//  Created by bingo on 2018/3/18.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import <ABCPaitiKit/ABCPaitiKit.h>
#import "DemoCameraViewController.h"
#import <MJExtension/MJExtension.h>
#import "ABCQuestionAnswersMo.h"
#import "ABCQuestionDetailViewController.h"

#define ABC_APP_KEY     @"5aac840df1664467549b1fba"
#define ABC_APP_SECRET  @"F0B732122E7CADAC4D857E2C25050C7C"

////教师端
//#define ABC_APP_KEY     @"5554527E474347F01EDB267A"
//#define ABC_APP_SECRET  @"BDECB2E9C8F6887FF31D5AC6DA312D85";

////对外
//#define ABC_APP_KEY     @"5577E6CCE4B0CDD74AE31C7E"
//#define ABC_APP_SECRET  @"64F682C06F2A719D1902CE7C8E5CAA07";

@interface ViewController ()<ABCPaitiManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ABCPaitiManager sharedInstance].delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
//    [[LOTLib sharedInstance] startWithAppKey:ABC_APP_KEY secret:ABC_APP_SECRET];
}
- (IBAction)startPaiti:(id)sender {
    BOOL isCamrma = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamrma) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_title", @"alert_title") message:NSLocalizedString(@"alert_no_backcamera", @"alert_no_backcamera") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    DemoCameraViewController *cameraViewController = [[DemoCameraViewController alloc] init];
    
    [self presentViewController:cameraViewController animated:YES completion:nil];
//    [self.navigationController pushViewController:cameraViewController animated:YES];
}

#pragma mark - ABCPaitiManagerDelegate
-(void) onQuestionAnswersData:(id)answerData
{
    ABCQuestionAnswersMo *qaMo = [ABCQuestionAnswersMo mj_objectWithKeyValues:answerData];
    ABCQuestionDetailViewController *qDetailViewCtrl = [[ABCQuestionDetailViewController alloc] init];
    qDetailViewCtrl.imageId = qaMo.question.image_id;
    qDetailViewCtrl.questionAnswersMo = qaMo;
    [self.navigationController pushViewController:qDetailViewCtrl animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
