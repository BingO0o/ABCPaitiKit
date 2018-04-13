//
//  ABCCaptureSessionManager.h
//  ABCPaitiKit
//
//  Created by bingo on 2018/4/12.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define MAX_PINCH_SCALE_NUM   3.f
#define MIN_PINCH_SCALE_NUM   1.f

// 布局需要增加的额外高度
#define LAYOUT_ADDITIONAL_H (isHigherThaniPhone4_SC ? 160 : 80)

@protocol ABCCaptureSessionManager;

typedef void(^DidCapturePhotoBlock)(UIImage *stillImage);

@interface ABCCaptureSessionManager : NSObject

@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDeviceInput *inputDevice;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
//@property (nonatomic, strong) UIImage *stillImage;

//pinch
@property (nonatomic, assign) CGFloat preScaleNum;
@property (nonatomic, assign) CGFloat scaleNum;


@property (nonatomic, assign) id <ABCCaptureSessionManager> delegate;

- (CGImageRef)imageRefFromBufferRef:(CMSampleBufferRef)buffer;

- (void)configureWithParentLayer:(UIView*)parent previewRect:(CGRect)preivewRect;

//- (void)startGravityDetecting;
//- (void)stopGravityDetecting;

- (void)takePicture:(DidCapturePhotoBlock)block;
- (void)switchCamera:(BOOL)isFrontCamera;
- (void)pinchCameraViewWithScalNum:(CGFloat)scale;
- (void)pinchCameraView:(UIPinchGestureRecognizer*)gesture;

- (void)switchFlashMode:(UIButton*)sender;
// 如果开了闪光灯，尝试关闭
- (void)closeFlashIfPossible:(UIButton *)button;

- (void)focusInPoint:(CGPoint)devicePoint;

// V2.3 显示网格
- (void)switchGridLines:(BOOL)toShow;
// 显示半透明边界
- (void)switchAlphaCover:(BOOL)toShow;

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange;

- (void)startCameraCompletion:(void (^)())completion;
- (void)stopCamera;

// V3.1 配置KVO
- (void)configKVO;
- (void)clearKVO;

@end

@protocol ABCCaptureSessionManager <NSObject>

@optional
- (void)didCapturePhoto:(UIImage*)stillImage;

- (void)sessionManagerError:(ABCCaptureSessionManager *)sessionManager;

// Anti-shake
- (void)didDetectShake:(ABCCaptureSessionManager *)sessionMgr;
- (void)didDetectSteady:(ABCCaptureSessionManager *)sessionMgr;

- (void)didStartTakingPicture:(ABCCaptureSessionManager *)sessionMgr;
- (void)didCometoSteadyForTakingPicture:(ABCCaptureSessionManager *)sessionMgr;
- (void)didGotPhotoData:(ABCCaptureSessionManager *)sessionMgr;

- (void)didAutoFocusStarted:(ABCCaptureSessionManager *)sessionMgr;
- (void)didAutoFocusSucceed:(ABCCaptureSessionManager *)sessionMgr;

// V2.9
- (void)sessionMgr:(ABCCaptureSessionManager *)manager didDetectOrientation:(NSInteger)orientation;

@end
