//
//  ABCAnswerMo.h
//  ABCPaitiDemo
//
//  Created by bingo on 2018/4/13.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABCAnswerMo : NSObject

@property(nonatomic, strong) NSString *question_id;

@property(nonatomic, strong) NSString *question_body;

@property(nonatomic, strong) NSString *question_body_html;

@property(nonatomic, strong) NSString *question_tag;

@property(nonatomic, strong) NSString *question_answer;

@property(nonatomic, strong) NSString *answer_analysis;

@property(nonatomic, strong) NSString *subject;

@end
