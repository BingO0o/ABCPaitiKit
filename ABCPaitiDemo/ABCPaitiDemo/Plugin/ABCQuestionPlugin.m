//
//  ABCQuestionPlugin.m
//  ABCPaitiDemo
//
//  Created by bingo on 2018/4/13.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import "ABCQuestionPlugin.h"
#import "ABCQuestionDetailViewController.h"

@implementation ABCQuestionPlugin
@synthesize queParams=_queParams;
@synthesize question=_question;

- (void)requestCourseFail:(CDVInvokedUrlCommand *)command {
    NSLog(@"requestCourseFail command: %@", command.arguments);
    
    NSNumber *httpStatus = command.arguments.firstObject;
    NSNumber *respStatus = [command.arguments objectAtIndex:1];
    if (([httpStatus isKindOfClass:[NSNumber class]] && httpStatus.integerValue == 401) ||
        ([respStatus isKindOfClass:[NSNumber class]] && respStatus.integerValue == -3)) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNTF_REQ_401 object:nil];
    }
}

- (void)showLoading:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        ABCQuestionDetailViewController  *controller =(ABCQuestionDetailViewController *)self.viewController;
        id params=[controller getQueLoadingParams];
        if (params) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:params];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            
        }else{
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT] callbackId:command.callbackId];
        }
    }];
}

- (void)showQuestion:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        ABCQuestionDetailViewController  *controller =(ABCQuestionDetailViewController *)self.viewController;
        [controller getQueDetailWithCallBack:^(id sender) {
            _queParams=sender;
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:sender];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
        
    }];
}

- (void)showPhoto:(CDVInvokedUrlCommand*)command
{
    
}

-(void)showNewAnswer:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)reTryLink:(CDVInvokedUrlCommand*)command
{
    //     NSLog(@"reTryLink");
    //    command.methodName=@"reTryLink";
    //    [self showQuestion:command];
}

-(void)reTakePhoto:(CDVInvokedUrlCommand*)command
{
    NSLog(@"reTakePhoto");
    ABCQuestionDetailViewController  *controller =(ABCQuestionDetailViewController *)self.viewController;
    [controller retakePhoto];
    
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

-(void)changeTitle:(CDVInvokedUrlCommand*)command
{
    NSLog(@"changeTitle");
    
    ABCQuestionDetailViewController  *controller =(ABCQuestionDetailViewController *)self.viewController;
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber *page=(command.arguments&&command.arguments.count>0)?command.arguments[0]:@(-1);
            [controller changeTitle:page];
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        });
    }];
    
    
}


-(void)cacheIndex:(CDVInvokedUrlCommand *)command
{
    ABCQuestionDetailViewController  *controller =(ABCQuestionDetailViewController *)self.viewController;
    NSString *imgId=controller.imageId;
    NSNumber *cacheIndex=command.arguments.firstObject;
    if (imgId && cacheIndex) {
        [self.commandDelegate runInBackground:^{
            dispatch_async(dispatch_get_main_queue(), ^{
            });
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
}

-(void)cacheImg:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        ABCQuestionDetailViewController  *controller =(ABCQuestionDetailViewController *)self.viewController;
        NSData* imageData = [NSData dataFromBase64String:[command.arguments objectAtIndex:0]];
        if (imageData && imageData.length>0) {
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            [controller cacheImg:image];
        }
        
    }];
}


@end




@implementation MDQuestionCommandDelegate

-(id)getCommandInstance:(NSString *)pluginName
{
    return [super getCommandInstance:pluginName];
}

/*
 NOTE: this will only inspect execute calls coming explicitly from native plugins,
 not the commandQueue (from JavaScript). To see execute calls from JavaScript, see
 MainCommandQueue below
 */
//- (BOOL)execute:(CDVInvokedUrlCommand*)command
//{
//
//    return [super execute:command];
//}

- (NSString*)pathForResource:(NSString*)resourcepath;
{
    return [super pathForResource:resourcepath];
}


@end

@implementation MDQuestionCommandQueue

/* To override, uncomment the line in the init function(s)
 in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end




