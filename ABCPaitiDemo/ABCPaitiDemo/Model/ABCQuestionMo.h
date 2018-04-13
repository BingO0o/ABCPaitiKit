//
//  ABCQuestionMo.h
//  ABCPaitiDemo
//
//  Created by bingo on 2018/4/13.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABCQuestionMo : NSObject

@property(nonatomic,assign) long long create_time;
@property(nonatomic,assign) long long update_time;
@property(nonatomic,strong) NSString *image_path;
@property(nonatomic,strong) NSString *image_id;
@property(nonatomic,assign) int search_type;
@property(nonatomic,strong) NSString *from_id;
@end
