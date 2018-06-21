//
//  ABCPaitiManager.h
//  ABCPaitiKit
//
//  Created by bingo on 2018/4/12.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ABCPaitiManagerDelegate<NSObject>

@optional

/*!
 返回配对结果
 */
-(void) onQuestionAnswersData:(id) answerData;

-(void) onAuthFailure:(NSString *) failure;

@end

@interface ABCPaitiManager : NSObject

@property(nonatomic, weak) id<ABCPaitiManagerDelegate> delegate;
/*!
 @method sharedInstance
 @return 返回实例
 */
+ (instancetype)sharedInstance;

/*!
 *  @method sharedInstance
 *
 *  @abstract
 *  进行ABCPaitiManager的初始化工作
 *
 *  @discussion
 *  尽可能在App运行早期调用
 *  推荐：UIApplicationDelegate -> didFinishLaunchingWithOptions
 */
- (void)startWithAppKey:(NSString *)appKey secret:(NSString *)secret;

/*!
 *  @method uploadSubjectPicture:progress:success:failure:
 *
 *  @abstract
 *  上传图片
 *
 *  @discussion
 *  此接口会对上传的图片进行压缩等处理
 */
-(void) uploadSubjectPicture:(UIImage *)image
                    progress:(void (^)(float progress)) progress
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSString *strMsg))fail;

/*!
 *  @method getQuestionList:failure:
 *
 *  @abstract
 *  获取本地题目列表（跟机器绑定）
 */
-(void) getQuestionList:(void (^)(id responseObject))success
                failure:(void (^)(NSString *strMsg))fail;

/*!
 *  @method getQuestionAnswers:success:failure:
 *
 *  @abstract
 *  根据imageId获取配对结果
 */
-(void) getQuestionAnswers:(NSString *) imageId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSString *strMsg))fail;

@end
