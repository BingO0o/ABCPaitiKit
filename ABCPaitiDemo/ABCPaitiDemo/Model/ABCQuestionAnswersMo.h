//
//  ABCQuestionAnswersMo.h
//  ABCPaitiDemo
//
//  Created by bingo on 2018/4/13.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCQuestionMo.h"
#import "ABCAnswerMo.h"

@interface ABCQuestionAnswersMo : NSObject

@property(nonatomic, strong) ABCQuestionMo *question;

@property(nonatomic, strong) NSArray *answers;

@property(nonatomic, strong) NSArray *answerMos;

@end
