## 笔声SDK集成文档
[![Version](https://img.shields.io/cocoapods/v/ABCIM.svg?style=flat)](http://cocoapods.org/pods/ABCPaiti)
[![License](https://img.shields.io/cocoapods/l/ABCIM.svg?style=flat)](http://cocoapods.org/pods/ABCPaiti)
[![Platform](https://img.shields.io/cocoapods/p/ABCIM.svg?style=flat)](http://cocoapods.org/pods/ABCPaiti)

[TOC]

### REVISION HISTORY
Version | Date |Changed By |Changes
------|------|------|------
0.0.1 | 2018-03-26|Bing|init

### 准备环境
请确保满足以下开发环境要求：
- Apple XCode 6.0或以上版本
- iOS 9.0或以上版本

### pod导入
~~~
pod 'ABCPaiti', '~>0.0.1'
~~~

### 快速集成

1. LOTLib 是SDK中的核心类
     1. 所有关于LOTLib的操作，都通过sharedInstance方法发起，LOTLib维护一个全局单例
~~~
 // 引用ABCPaitiKit头文件
 #import <ABCPaitiKit/ABCPaitiKit.h>

 // 尽可能早得调用这个接口，对SDK进行初始化，如果不调用此方法，拍题功能将无法正常启动
 // 建议在AppDelegate的didFinishLaunchingWithOptions中调用。
 [[LOTLib sharedInstance] startWithAppKey:@"********" secret:@"********"];
~~~

2. 拍题操作
    1. 创建题目列表页面：
        ~~~
         // 引用ABCPaitiKit头文件
         #import <ABCPaitiKit/ABCPaitiKit.h>

         // 将题目列表也推入页面堆栈
         [self.navigationController pushViewController:[MDQueListViewController sharedInstance] animated:YES];
        ~~~
    2. 添加demo中www文件和config.xml到主工程中


### Notification name
状态通知name
~~~
// 题目进入“上传中”
#define kNTF_QUE_NEW_START @"ntf_que_new_start"
// 题目“上传失败”
#define kNTF_QUE_NEW_UPDFAIL @"ntf_que_new_updfail"
// 题目进入“重新上传中”
#define kNTF_QUE_REUPLOAD @"ntf_que_reupload"
// 通知程序刷新题目列表
#define kNTF_REFRESH_QUESTIONLIST @"ntf_refresh_questionlist"
// 通知imageId上传成功，userInfo中带imageId
#define kNTF_QUE_UPDSUCCEED @"ntf_que_updsucceed"
~~~
