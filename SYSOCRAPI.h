//
//  SYSOCRAPI.h
//  SGCC
//
//  Created by wangpo on 2018/7/9.
//  Copyright © 2018年 SGCC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SYSIdentityCardModel;

static NSString * const KAliyunOcrCode = @"8292ddac4d164671925e1dc06b1ec350";

typedef void (^SuccessCallback)(SYSIdentityCardModel *model);//成功回调
typedef void (^FailureCallback)(void);//失败回调

@interface SYSOCRAPI : NSObject

/**
 ocr识别
 
 @param image 选择的身份证图片
 @param side 身份证正反面类型:face/back
 */
- (void)ocrIdentityCard:(UIImage *)image
                   side:(NSString *)side
        successCallback:(SuccessCallback)successBlock
        failureCallback:(FailureCallback)failureBlock;

@end

@interface SYSIdentityCardModel : NSObject

@property (nonatomic, strong) NSString *address;//地址信息
@property (nonatomic, strong) NSString *name;//姓名
@property (nonatomic, strong) NSString *nationality;//民族
@property (nonatomic, strong) NSString *num;//身份证号
@property (nonatomic, strong) NSString *sex;//性别
@property (nonatomic, strong) NSString *birth;//出生日期
@property (nonatomic, strong) NSString *issue;//签发机关
@property (nonatomic, strong) NSString *start_date;//有效期起始时间
@property (nonatomic, strong) NSString *end_date;//有效期结束时间
@property (nonatomic, assign) BOOL success;// #识别结果，true表示成功，false表示失败
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
