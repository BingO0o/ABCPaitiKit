//
//  ABCQuestionDetailViewController.h
//  ABCPaitiDemo
//
//  Created by bingo on 2018/4/13.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Cordova/CDV.h>
#import <Cordova/CDVCommandDelegateImpl.h>
#import "ABCQuestionAnswersMo.h"

@interface ABCQuestionDetailViewController : CDVViewController

@property (nonatomic, strong) NSString *imageId;
@property (nonatomic, strong) NSNumber *updateTime;
@property(nonatomic, strong)  NSString *localImgPath;
@property (nonatomic, strong) ABCQuestionAnswersMo *questionAnswersMo;

-(NSDictionary *)getQueLoadingParams;
-(void)getQueDetailWithCallBack:(void(^)(id sender))callBack;
-(void)retakePhoto;
-(void)changeTitle:(NSNumber *)page;
-(void)cacheImg:(UIImage *)image;

@end
