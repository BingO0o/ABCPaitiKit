//
//  ABCQuestionDetailViewController.m
//  ABCPaitiDemo
//
//  Created by bingo on 2018/4/13.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import "ABCQuestionDetailViewController.h"
#import "ABCQuestionPlugin.h"
#import <SDWebImage/SDImageCache.h>
#import <ABCPaitiKit/ABCPaitiKit.h>
#import <MJExtension/MJExtension.h>

@interface ABCQuestionDetailViewController ()

@property(nonatomic, strong) ABCQuestionPlugin *plugin;

@end

@implementation ABCQuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _plugin =  [self.commandDelegate getCommandInstance:@"ABCQuestionPlugin"];
    _plugin.viewController = self;
}

-(NSDictionary *)getQueLoadingParams
{
    if (_imageId==nil || _imageId.length==0) {
        return nil;
    }
    if ([_imageId  hasPrefix:@"'"]) {
        _imageId=[_imageId stringByReplacingOccurrencesOfString:@"'" withString:@""];
    }
    
    self.localImgPath=@"";
    
    return @{@"status":@0,
             @"question":@{@"update_time":self.updateTime?self.updateTime:[NSNull null],
                           @"image_path":_localImgPath?_localImgPath:@""},
             @"machine_answers":@[],
             @"human_answer":[NSNull null],
             @"local_img_path":_localImgPath};
}

-(NSArray *)fillterAnswers:(NSArray *)answers
{
    if (!answers || answers.count==0) {
        return nil;
    }
    NSMutableArray *results=[NSMutableArray array];
//    NSMutableArray *notEmptyAnswers=[NSMutableArray array];
    [answers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ABCAnswerMo *answer=obj;
        NSMutableDictionary *fillteredAnswer = @{@"questionId":answer.question_id,
                                                 @"answer":answer.question_answer,
                                                 @"image_id":self.imageId,
                                                 @"body":answer.question_body_html,
                                                 @"analysis":answer.answer_analysis,
                                                 @"tags":answer.question_tag,
                                                 @"subject":answer.subject}.mutableCopy;
        [results addObject:fillteredAnswer];
    }];
    return results;
}

-(void)getQueDetailWithCallBack:(void(^)(id sender))callBack
{
    if (_imageId==nil || _imageId.length==0) {
        return;
    }
    
    if ([_imageId  hasPrefix:@"'"]) {
        _imageId=[_imageId stringByReplacingOccurrencesOfString:@"'" withString:@""];
    }
    
    [[ABCPaitiManager sharedInstance] getQuestionAnswers:_imageId success:^(id responseObject) {
        ABCQuestionAnswersMo *qaMo = [ABCQuestionAnswersMo mj_objectWithKeyValues:responseObject];
        NSArray *answers= [self fillterAnswers:qaMo.answerMos];
        NSDictionary *quesion = [qaMo.question mj_keyValues];
        if ( (answers && answers.count>0)  && quesion) {
            if (callBack) {
                callBack(@{@"status":@2,
                           @"question":quesion?quesion:[NSNull null],
                           @"machine_answers":answers?answers:@[],}
                         );
            }else{
                callBack(@{@"status":@2,
                           @"question":quesion?quesion:[NSNull null],
                           @"machine_answers":answers?answers:@[],
                           @"cache_index":@(0),
                           @"is_ask":@(NO),
                           @"audio_top_index":@(0)});
            }
            
        }else if ( (answers==nil || answers.count==0)  && quesion) {
            if (callBack) {
                callBack(@{@"status":[NSNumber numberWithInteger:-1],
                           @"question":quesion?quesion:[NSNull null],
                           @"machine_answers":@[],
                           @"is_ask":@(NO)});
            }
            [self changeTitle:@0];
        }else {
            if (callBack) {
                callBack(@{@"status":[NSNumber numberWithInteger:-2]});
            }
        }
    } failure:^(NSString *strMsg) {
        if (callBack) {
            callBack(@{@"status":[NSNumber numberWithInteger:-2]});
        }
    }];
}

-(void)retakePhoto
{
    
}
-(void)changeTitle:(NSNumber *)page
{
    
}
-(void)cacheImg:(UIImage *)image
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
