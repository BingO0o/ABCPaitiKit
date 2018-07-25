//
//  DemoCameraViewController.m
//  ABCPaitiDemo
//
//  Created by bingo on 2018/4/12.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import "DemoCameraViewController.h"
#import <ABCPaitiKit/ABCPaitiKit.h>
#import <BFKit/BFKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MDEditPhotoViewController.h"


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define kNotificationOrientationChange          @"kNotificationOrientationChange"

#define CAMERA_TOPVIEW_HEIGHT   44  //title
#define CAMERA_MENU_VIEW_HEIGH  44  //menu

#define CAMERA_TOP_BTN_SIZE     40  // top button
#define CAMERA_MENU_BTN_SIZE    60  //button

BOOL CanUseCamera() {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return NO;
    }
    
    return YES;
}

@interface DemoCameraViewController ()<ABCCaptureSessionManager,UIImagePickerControllerDelegate, UINavigationControllerDelegate, MDEditPhotoViewControllerDelegate>

@property (nonatomic, strong) ABCCaptureSessionManager *captureManager;

@property (nonatomic, strong) UILabel *operLb;          // 中央区域“请横屏拍摄”提示
@property (nonatomic, strong) UIImageView *operBgImgV;  // 中央区域蓝色背景
@property (nonatomic, strong) UIView *flashCover;       // 拍照瞬间闪光的效果

@property (nonatomic, strong) NSMutableSet *cameraBtnSet;

@property (nonatomic, strong) UIView *topContainerView;//顶部view

@property (nonatomic, strong) UIView *bottomContainerView;//除了顶部标题、拍照区域剩下的所有区域

@property (nonatomic, strong) UILabel *remindLabel; // 提示用户对准白线的Label

@property (nonatomic, strong) UIView *coverV;

@property (nonatomic, strong) UIImageView *focusImageView;//对焦


// 相册按钮
@property (nonatomic, strong) UIButton *albumBtn;
// 关闭按钮
@property (nonatomic, strong) UIButton *dismissBtn;
// 相机按钮
@property (nonatomic, strong) UIButton *cameraButton;
// 闪光灯按钮
@property (nonatomic, strong) UIButton *flashButton;

@end

@implementation DemoCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //notification
    _cameraBtnSet = [[NSMutableSet alloc] init];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOrientationChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:kNotificationOrientationChange object:nil];
    
    [self.captureManager startCameraCompletion:^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[_captureManager.inputDevice device]];
        
        self.view.backgroundColor = [UIColor clearColor];
    }];
    
    [self.captureManager switchGridLines:YES];
    //设置默认相机照片方向
    self.captureManager.defaultOrientation = CAMERA_ORI_PORTRAIT;

    [self addTopViewWithText:@"拍照"];
    [self addbottomContainerView];
    [self addCameraMenuView];
    [self addFocusView];
    [self orientationDidChange:[NSNumber numberWithDouble:M_PI_2]];
  
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.captureManager startGravityDetecting];
    
    if (!CanUseCamera()) {
        [self showCentralInfoArea:@"拍题前请先允许访问相机" autoDisappear:YES];
    }
    else {
        [self showCentralInfoArea:@"请横屏拍摄" autoDisappear:YES];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.captureManager configKVO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.captureManager clearKVO];
}

- (void)subjectAreaDidChange:(NSNotification *)notification
{
    CGPoint devicePoint = CGPointMake(.5, .5);
    [self.captureManager focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

#pragma mark -
#pragma mark - Properties
- (UIView *)flashCover
{
    if (!_flashCover) {
        _flashCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 60)];
        _flashCover.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_flashCover];
        [self.view bringSubviewToFront:_flashCover];
    }
    
    return _flashCover;
}

- (UILabel *)operLb
{
    if (!_operLb) {
        CGFloat width = 120;
        CGFloat height = 40;
        _operLb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 60, (ScreenHeight - 60) / 2 - 20, width, height)];
        _operLb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _operLb.textAlignment = NSTextAlignmentCenter;
        _operLb.font = [UIFont boldSystemFontOfSize:18];
        _operLb.numberOfLines = 2;
        _operLb.text = @"请横屏拍摄";
        _operLb.textColor = [UIColor whiteColor];
        _operLb.alpha = 0;
        _operLb.layer.cornerRadius = 4.0f;
        _operLb.clipsToBounds = YES;
    }
    
    return _operLb;
}

- (UIImageView *)operBgImgV
{
    if (!_operBgImgV) {
        CGFloat width = ScreenWidth / 3;
        CGFloat height = (ScreenHeight - 60) / 3;
        _operBgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(width + 1, height + 1 - 20, width - 1, height - 1 + 40)];
//        _operBgImgV.backgroundColor = [COLOR_XUEXIBAO_TINT colorWithAlphaComponent:0.3];
        _operBgImgV.alpha = 0;
    }
    
    return _operBgImgV;
}

- (UIView *)coverV {
    if (!_coverV) {
        _coverV = [[UIView alloc] initWithFrame:self.view.bounds];
        _coverV.backgroundColor = [UIColor blackColor];
        _coverV.alpha = 0;
        
        [self.view addSubview:_coverV];
        [self.view bringSubviewToFront:_coverV];
    }
    
    return _coverV;
}


#pragma mark -------------UI---------------
//顶部标题
- (void)addTopViewWithText:(NSString*)text {
    if (!_topContainerView) {
        CGRect topFrame = CGRectMake(0, 0, ScreenWidth, CAMERA_TOPVIEW_HEIGHT);
        
        UIView *tView = [[UIView alloc] initWithFrame:topFrame];
        tView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tView];
        self.topContainerView = tView;
    }
}

// 中央区域提示
- (void)addCentralDisplay {
    //    [self.view addSubview:self.operBgImgV];
    
    [self.view addSubview:self.operLb];
    [self.view bringSubviewToFront:self.operLb];
}

// 拍照提示中文
- (void)addRemindLabel
{
    UILabel *label = nil;
    

    CGFloat bottomY = (ScreenHeight - 60) / 2 - 19;
    CGRect labelFrame = CGRectMake(-65, bottomY, 190, 40);
    
    label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];

    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    label.clipsToBounds = YES;
    label.layer.cornerRadius = 5.0f;
    label.text = NSLocalizedString(@"camera_remind", @"");
    label.alpha = 0.85;
    [self.view addSubview:label];
    self.remindLabel = label;
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2);
    _remindLabel.transform = transform;
}

//bottomContainerView，总体
- (void)addbottomContainerView {
    
    CGFloat bottomH = 60;
    CGRect bottomFrame = CGRectMake(0, ScreenHeight - bottomH, ScreenWidth, bottomH);
    
    UIView *view = [[UIView alloc] initWithFrame:bottomFrame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.8;
    [self.view addSubview:view];
    self.bottomContainerView = view;
}

//拍照菜单栏
- (void)addCameraMenuView {
    
    //拍照按钮
    CGFloat cameraBtnLength = 60;
    CGRect cameraBtnFrame = CGRectMake((ScreenWidth + 2 - cameraBtnLength) / 2, 0, 60, 60);
    UIButton *cameraBtn = [self buildButton:cameraBtnFrame
                               normalImgStr:@"camera_55"
                            highlightImgStr:@"camera_55_h"
                             selectedImgStr:@"camera_55_h"
                                     action:@selector(takePictureBtnPressed:)
                                 parentView:_bottomContainerView];
    cameraBtn.showsTouchWhenHighlighted = YES;
    self.cameraButton = cameraBtn;
    
    [self addMenuViewButtons];
}

//拍照菜单栏上的按钮
- (void)addMenuViewButtons {
    NSMutableArray *normalArr = [[NSMutableArray alloc] initWithObjects:@"camera_cancle", @"camera_album", @"camera_flash_off", @"camera_help", nil];
    NSMutableArray *highlightArr = [[NSMutableArray alloc] initWithObjects:@"camera_cancle_hi", @"camera_album_h", @"", @"camera_help_hi", nil];
    NSMutableArray *selectedArr = [[NSMutableArray alloc] initWithObjects:@"camera_cancle_hi", @"camera_album_h", @"", @"camera_help_hi", nil];
    
    NSMutableArray *actionArr = [[NSMutableArray alloc] initWithObjects:@"dismissBtnPressed:", @"albumBtnPressed:", @"flashBtnPressed:", @"helpBtnPressed:", nil];
    
    // 相册按钮
    UIButton *btn = [self buildButton:CGRectMake(_bottomContainerView.bounds.origin.x + 5, _bottomContainerView.bounds.size.height - CAMERA_MENU_BTN_SIZE, CAMERA_MENU_BTN_SIZE, CAMERA_MENU_BTN_SIZE)
                         normalImgStr:@"camera_album"
                      highlightImgStr:@"camera_album_h"
                       selectedImgStr:@"camera_album_h"
                               action:NSSelectorFromString(@"albumBtnPressed:")
                           parentView:_bottomContainerView];
    [_bottomContainerView bringSubviewToFront:btn];
    [_cameraBtnSet addObject:btn];
    _albumBtn = btn;
    
    // 关闭按钮
    btn = [self buildButton:CGRectMake(_bottomContainerView.bounds.size.width - CAMERA_MENU_BTN_SIZE - 5, _bottomContainerView.bounds.size.height - CAMERA_MENU_BTN_SIZE, CAMERA_MENU_BTN_SIZE, CAMERA_MENU_BTN_SIZE)
               normalImgStr:@"camera_cancle"
            highlightImgStr:@"camera_cancle_h"
             selectedImgStr:@"camera_cancle_h"
                     action:NSSelectorFromString(@"dismissBtnPressed:")
                 parentView:_bottomContainerView];
    [_bottomContainerView bringSubviewToFront:btn];
    [_cameraBtnSet addObject:btn];
    _dismissBtn = btn;
    
    // 闪光灯按钮
    btn = [self buildButton:CGRectMake(0, 0, CAMERA_TOP_BTN_SIZE + 10, CAMERA_TOP_BTN_SIZE + 10)
               normalImgStr:[normalArr objectAtIndex:2]
            highlightImgStr:[highlightArr objectAtIndex:2]
             selectedImgStr:[selectedArr objectAtIndex:2]
                     action:NSSelectorFromString([actionArr objectAtIndex:2])
                 parentView:_topContainerView];
    btn.showsTouchWhenHighlighted = YES;
    [_cameraBtnSet addObject:btn];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2);
    btn.transform = transform;
    _flashButton = btn;
}

- (void)showFocusInPoint:(CGPoint)touchPoint {
    //对焦框
    [_focusImageView setCenter:touchPoint];
    _focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _focusImageView.alpha = 1.f;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _focusImageView.alpha = 0.f;
        } completion:nil];
    }];
}

//对焦的框
- (void)addFocusView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch_focus_x"]];
    imgView.alpha = 0;
    [self.view addSubview:imgView];
    self.focusImageView = imgView;
}

- (void)takePictureBtnPressed:(UIButton*)sender {
    [self enableButtons:NO];
    //    sender.userInteractionEnabled = NO;
    
    [_captureManager takePicture:^(UIImage *stillImage) {
        [self enableButtons:YES];
        //        sender.userInteractionEnabled = YES;
        
        if (!stillImage) {
            NSLog(@"获取照片异常，请重新拍摄");
            return;
        }
        
//        UIImageView *view = [UIImageView new];
//        view.image = stillImage;
//        [self.view addSubview:view];
//        view.frame = CGRectMake(50, 50, 275, 500);
        
        [_captureManager closeFlashIfPossible:_flashButton];
        
        MDEditPhotoViewController *editViewController = [[MDEditPhotoViewController alloc] initWithNibName:@"MDEditPhotoViewController" bundle:nil];
        NSLog(@"editVC setImage:%@", NSStringFromCGSize(stillImage.size));
        
        [editViewController setImage:stillImage];
        editViewController.delegate = self;
        
        //            editViewController.transitioningDelegate = (id<UIViewControllerTransitioningDelegate>)self;
        
        [self presentViewController:editViewController animated:YES completion:NULL];
        
        
    } isOperate:NO];
}

//拍照页面，网格按钮
- (void)gridBtnPressed:(UIButton*)sender {
    sender.selected = !sender.selected;
    [_captureManager switchAlphaCover:sender.selected];
}

//拍照页面，切换前后摄像头按钮按钮
- (void)switchCameraBtnPressed:(UIButton*)sender {
    sender.selected = !sender.selected;
    [_captureManager switchCamera:sender.selected];
}

//拍照页面，闪光灯按钮
- (void)flashBtnPressed:(UIButton*)sender {
    [_captureManager switchFlashMode:sender];
}

//拍照页面，"X"按钮
- (void)dismissBtnPressed:(id)sender {
    [self enableButtons:NO];
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [self enableButtons:YES];
            }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [self enableButtons:YES];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            [self enableButtons:YES];
        }];
    }
}

//拍照页面，相册按钮
- (void)albumBtnPressed:(UIButton *)sender {
    [self enableButtons:NO];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.navigationBar.tintColor = [UIColor whiteColor];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // PathViewController被放到Container中之后，不能直接使用pathVC来present
    [self presentViewController:imagePicker animated:YES completion:^{
        [self enableButtons:YES];
    }];
}

- (void)enableButtons:(BOOL)enable {
    if (_dismissBtn) {
        _dismissBtn.enabled = enable;
    }
    
    if (_cameraButton) {
        _cameraButton.enabled = enable;
    }
    
    if (_flashButton) {
        _flashButton.enabled = enable;
    }
}

#pragma mark - MDEditPhotoViewControllerDelegate
- (void)willRepickPhoto
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didSelectPhoto:(UIImage *)image
{
    //TODO 编辑照片
    //demo upload test
    
     //图片尺寸压缩到1500*1500范围内
    image = [ABCImageUtil constraintToMaxLength:image];

    NSLog(@"After constraint:%@", NSStringFromCGSize(image.size));
                //纠正方向
    image = [ABCImageUtil fixOrientation:image];

    UIImage *stillImage = [ABCImageUtil adjustImageWithAngle:image];//矫正图片

    [self dismissViewControllerAnimated:YES completion:^{
        [[ABCPaitiManager sharedInstance] uploadSubjectPicture:stillImage progress:^(float progress) {
            NSLog(@"uploadSubjectPicture progress %f",progress);
        } success:^(id responseObject) {
            NSLog(@"uploadSubjectPicture response %@",responseObject);
            [self dismissBtnPressed:nil];
        } failure:^(NSString *strMsg) {
            NSLog(@"uploadSubjectPicture failure %@",strMsg);
        }];
    }];
}

#pragma mark - get&&set
-(ABCCaptureSessionManager *) captureManager
{
    if (!_captureManager) {
        _captureManager = [[ABCCaptureSessionManager alloc] init];
        _captureManager.delegate = self;
        [_captureManager configureWithParentLayer:self.view previewRect:[[UIScreen mainScreen] bounds]];
    }
    return _captureManager;
}

- (UIButton*)buildButton:(CGRect)frame
            normalImgStr:(NSString*)normalImgStr
         highlightImgStr:(NSString*)highlightImgStr
          selectedImgStr:(NSString*)selectedImgStr
                  action:(SEL)action
              parentView:(UIView*)parentView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (normalImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:normalImgStr] forState:UIControlStateNormal];
    }
    if (highlightImgStr.length > 0) {
        UIImage *img = [UIImage imageNamed:highlightImgStr];
        [btn setImage:img forState:UIControlStateHighlighted];
    }
    if (selectedImgStr.length > 0) {
        UIImage *img = [UIImage imageNamed:selectedImgStr];
        [btn setImage:img forState:UIControlStateSelected];
    }
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:btn];
    
    return btn;
}

#pragma mark SCCaptureSessionManager delegate
- (void)didCapturePhoto:(UIImage*)stillImage
{

}

- (void)sessionManagerError:(ABCCaptureSessionManager *)sessionManager
{
}

- (void)didStartTakingPicture:(ABCCaptureSessionManager *)sessionMgr
{
}

- (void)didCometoSteadyForTakingPicture:(ABCCaptureSessionManager *)sessionMgr
{

}

- (void)didGotPhotoData:(ABCCaptureSessionManager *)sessionMgr
{
}

- (void)didDetectShake:(ABCCaptureSessionManager *)sessionMgr
{
    //    [self switchShakeCover:YES];
    //    [self showCentralInfoArea:@"请勿抖动相机" autoDisappear:NO];
}

- (void)didDetectSteady:(ABCCaptureSessionManager *)sessionMgr
{
    //    [self switchShakeCover:NO];
    //    [self showCentralInfoArea:@"" autoDisappear:NO];
}

- (void)didAutoFocusStarted:(ABCCaptureSessionManager *)sessionMgr {
    //    MDLog(@"didAutoFocusStarted");
    
    CGPoint previewCenter = CGPointMake(ScreenWidth / 2, (ScreenHeight - self.bottomContainerView.bounds.size.height) / 2);
    
    [self showFocusInPoint:previewCenter];
}

- (void)didAutoFocusSucceed:(ABCCaptureSessionManager *)sessionMgr {
    //    MDLog(@"didAutoFocusSucceed");
}

- (void)sessionMgr:(ABCCaptureSessionManager *)manager didDetectOrientation:(NSInteger)orientation {
  
}

- (BOOL)shouldAutorotate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark ------------notification-------------
- (void)orientationDidChange:(NSNumber *)angle
{
    if (!_cameraBtnSet || _cameraBtnSet.count <= 0) {
        return;
    }
    
    if (!angle || ![angle isKindOfClass:[NSNumber class]]) {
        return;
    }
    
    //    __block CGAffineTransform transform = CGAffineTransformMakeRotation(0);
    //    transform = CGAffineTransformMakeRotation(angle.doubleValue);
    
    __block CGAffineTransform transform;
    
    [_cameraBtnSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UIButton *btn = ([obj isKindOfClass:[UIButton class]] ? (UIButton*)obj : nil);
        if (!btn) {
            *stop = YES;
            return ;
        }
        
        transform = btn.transform;
        transform = CGAffineTransformMakeRotation(angle.doubleValue);
        
        btn.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        [UIView animateWithDuration:0.3f animations:^{
            btn.transform = transform;
        }];
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        transform = self.cameraButton.transform;
        transform = CGAffineTransformMakeRotation(angle.doubleValue);
        self.cameraButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.cameraButton.transform = transform;
        
        transform = self.operLb.transform;
        transform = CGAffineTransformMakeRotation(angle.doubleValue);
        self.operLb.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.operLb.transform = transform;
    }];
}

- (void)dealloc {
    
    [self.captureManager stopCamera];
    
    NSLog(@"+++++++++++++NSCaptureCameraController dealloc++++++++++++++");
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[_captureManager.inputDevice device]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOrientationChange object:nil];
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device removeObserver:self forKeyPath:ADJUSTINT_FOCUS context:nil];
    }
#endif
    
    self.captureManager = nil;
}

- (void)showCentralInfoArea:(NSString *)text autoDisappear:(BOOL)isAuto
{
    // 1. 如果没有设置文字，认为需要隐藏
    if (!text || text.length <= 0) {
        [UIView animateWithDuration:0.15 animations:^{
            self.operLb.alpha = self.operBgImgV.alpha = 0;
        } completion:^(BOOL finished) {
            self.operLb.hidden = self.operBgImgV.hidden = YES;
        }];
        
        return;
    }
    
    // 2. 如果之前是隐藏，显示展现过程
    if (self.operLb.alpha == 0 || self.operBgImgV.alpha == 0) {
        self.operLb.text = text;
        
        self.operLb.hidden = self.operBgImgV.hidden = NO;
        [UIView animateWithDuration:0.15 animations:^{
            self.operLb.alpha = self.operBgImgV.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    // 3. 如果是定时自动消失，安排定时任务
    if (isAuto) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.15 animations:^{
                self.operLb.alpha = self.operBgImgV.alpha = 0;
            } completion:^(BOOL finished) {
                self.operLb.hidden = self.operBgImgV.hidden = YES;
            }];
        });
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (!info || [info count] <= 0)
        return;
    
    NSLog(@"didFinishPickingMediaWithInfo:%@", info);
    __block UIImage *oriImage = info[UIImagePickerControllerOriginalImage];
    
    __block UIImage *image = oriImage; //[oriImage rotate90Clockwise];
    [self dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"Before constraint:%@", NSStringFromCGSize(oriImage.size));
            // 0.1. 图片尺寸压缩到1500*1500范围内
//            oriImage = [ABCImageUtil constraintToMaxLength:oriImage];
//
//            NSLog(@"After constraint:%@", NSStringFromCGSize(oriImage.size));
//
//            //纠正方向
//            image = [ABCImageUtil fixOrientation:oriImage];
//
//            UIImage *stillImage = [ABCImageUtil adjustImageWithAngle:image];//矫正图片
            
            MDEditPhotoViewController *editViewController = [[MDEditPhotoViewController alloc] initWithNibName:@"MDEditPhotoViewController" bundle:nil];
            NSLog(@"editVC setImage:%@", NSStringFromCGSize(oriImage.size));
            
            [editViewController setImage:oriImage];
            editViewController.delegate = self;
            
            //            editViewController.transitioningDelegate = (id<UIViewControllerTransitioningDelegate>)self;
            
            [self presentViewController:editViewController animated:YES completion:NULL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTakePicture object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:stillImage, kImage, nil]];
            });
        });
        
        //TODO 编辑图片
        //             }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
