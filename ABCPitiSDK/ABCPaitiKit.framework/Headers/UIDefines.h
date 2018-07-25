//
//  UIDefines.h
//  ABCPaitiKit
//
//  Created by bingo on 2018/4/12.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#ifndef UIDefines_h
#define UIDefines_h

// 旋转方向
typedef enum {
    CAMERA_ORI_PORTRAIT = 1,
    CAMERA_ORI_LANDSCAPE_LEFT = 2,
    CAMERA_ORI_LANDSCAPE_RIGHT = 3,
    CAMERA_ORI_UPSIDEDOWN = 4,
}CameraOriType;

// 拍题：相机，原始图片最大边长限制
#define SCREEN_IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define CAM_CROP_MAXLENGTH (SCREEN_IS_IPHONE_4 ? 2000 : 4000)
// 拍题：相机，原始图片最大像素（2000 * 2000）
#define CAM_CROP_MAX_BINPIXEL 2250000

#endif /* UIDefines_h */
