//
//  ABCQuestionAnswersMo.m
//  ABCPaitiDemo
//
//  Created by bingo on 2018/4/13.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import "ABCQuestionAnswersMo.h"
#import <MJExtension/MJExtension.h>

@implementation ABCQuestionAnswersMo

-(NSArray *) answerMos
{
    return [ABCAnswerMo mj_objectArrayWithKeyValuesArray:self.answers];
}
@end
