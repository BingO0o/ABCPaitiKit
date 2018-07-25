//
//  ABCImageUtil.h
//  ABCPaitiKit
//
//  Created by bingo on 2018/4/12.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABCImageUtil : NSObject

/*!
 图片尺寸压缩到1500*1500范围内
 */
+(UIImage *)constraintToMaxLength:(UIImage *) input;

+(UIImage *)fixOrientation:(UIImage *) input;

/*!
 矫正图片方向。
 大于45°不处理
 */
+ (UIImage *)adjustImageWithAngle:(UIImage *)input;

/*!
 矫正图片方向
 @param maxAngle 大于maxAngle 不处理
 */
+ (UIImage *)adjustImageWithAngle:(UIImage *)input withMaxAngle:(double) maxAngle;

/*!
 图片二值化，如果失败返回nil
 */
+ (NSString *)genBinPathForImage:(UIImage *)image;

/*!
 图片是否清晰
 */
+ (BOOL)isImageBlur:(UIImage *)image;

+ (UIImage*)crop:(UIImage *)image rect:(CGRect)rect;

@end
