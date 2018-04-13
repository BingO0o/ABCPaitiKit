//
//  ABCQuestionPlugin.h
//  ABCPaitiDemo
//
//  Created by bingo on 2018/4/13.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import <Cordova/CDVCommandDelegateImpl.h>
#import "ABCQuestionAnswersMo.h"



@interface ABCQuestionPlugin : CDVPlugin
@property(nonatomic, strong)NSDictionary *queParams;
@property(nonatomic, strong)ABCQuestionAnswersMo *question;

- (void)showQuestion:(CDVInvokedUrlCommand*)command;

- (void)showPhoto:(CDVInvokedUrlCommand*)command;

@end

@interface MDQuestionCommandDelegate : CDVCommandDelegateImpl

@end

@interface MDQuestionCommandQueue : CDVCommandQueue

@end
