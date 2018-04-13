## 笔声SDK集成文档
[![Version](https://img.shields.io/cocoapods/v/ABCPaiti.svg?style=flat)](http://cocoapods.org/pods/ABCPaiti)
[![License](https://img.shields.io/cocoapods/l/ABCPaiti.svg?style=flat)](http://cocoapods.org/pods/ABCPaiti)
[![Platform](https://img.shields.io/cocoapods/p/ABCPaiti.svg?style=flat)](http://cocoapods.org/pods/ABCPaiti)

[TOC]

### REVISION HISTORY
Version | Date |Changed By |Changes
------|------|------|------
0.0.1 | 2018-03-26|Bing|init
0.0.2 | 2018-04-13|Bing|fix

### 准备环境
请确保满足以下开发环境要求：
- Apple XCode 6.0或以上版本
- iOS 9.0或以上版本

### pod导入
~~~
pod 'ABCPaiti', '~>0.0.2'
~~~

### 快速集成

1. ABCPaitiManager 是SDK中的核心类
     1. 所有关于ABCPaitiManager的操作，都通过sharedInstance方法发起，ABCPaitiManager维护一个全局单例
~~~
 // 引用ABCPaitiKit头文件
 #import <ABCPaitiKit/ABCPaitiKit.h>

 // 尽可能早得调用这个接口，对SDK进行初始化，如果不调用此方法，拍题功能将无法正常启动
 // 建议在AppDelegate的didFinishLaunchingWithOptions中调用。
 [[ABCPaitiManager sharedInstance] startWithAppKey:@"********" secret:@"********"];
~~~

2. 拍题操作
    1. 上传图片：
        ~~~
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
        ~~~
    2. 添加demo中www文件和config.xml到主工程中

3. TODO
    1. 相机ABCCaptureSessionManager使用
    2. 图片处理
