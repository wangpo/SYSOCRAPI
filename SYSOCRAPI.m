//
//  SYSOCRAPI.m
//  SGCC
//
//  Created by wangpo on 2018/7/9.
//  Copyright © 2018年 SGCC. All rights reserved.
//

#import "SYSOCRAPI.h"

@implementation SYSOCRAPI

- (void)ocrIdentityCard:(UIImage *)image
                   side:(NSString *)side
        successCallback:(SuccessCallback)successBlock
        failureCallback:(FailureCallback)failureBlock
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    float fileLength = [imageData length];
    float maxLength = 100 * 1024; //上传图片大小不超过 4mb
    if (fileLength > maxLength) {
        imageData = UIImageJPEGRepresentation(image, maxLength / fileLength);
    }
    
    NSString *base64String = [imageData base64EncodedString];
    
    NSString *appcode = KAliyunOcrCode;
    NSString *host = @"https://dm-51.data.aliyun.com";
    NSString *path = @"/rest/160601/ocr/ocr_idcard.json";
    NSString *method = @"POST";
    NSString *querys = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    
    NSString *bodys = [NSString stringWithFormat:@"{\"image\":\"%@\",\"configure\":\"{\\\"side\\\":\\\"%@\\\"}\"}",base64String,side];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval: 5];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    //根据API的要求，定义相对应的Content-Type
    [request addValue: @"application/json; charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    NSData *data = [bodys dataUsingEncoding: NSUTF8StringEncoding];
    [request setHTTPBody: data];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                       NSLog(@"Response object: %@" , response);
                                                       NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
                                                       //打印应答中的body
                                                       NSLog(@"Response body: %@" , bodyString);
                                                       if (!body) {
                                                           failureBlock();
                                                           return;
                                                       }
                                                       NSError *err;
                                                       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:body
                                                                                     options:NSJSONReadingMutableContainers
                                                                                                             error:&err];
                                                       if(err){
                                                           NSLog(@"json解析失败：%@",err);
                                                          
                                                       }else{
                                                           SYSIdentityCardModel *model = [[SYSIdentityCardModel alloc] initWithDictionary:dict];
                                                           if (model && model.success) {
                                                               successBlock(model);
                                                           }else{
                                                               failureBlock();
                                                           }
                                                           
                                                           
                                                       }
                                                       
                                                      
                                                   }];
    
    [task resume];
}


@end

@implementation SYSIdentityCardModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]){
       
        _address = [dictionary objectForKey:@"address"];
        _name = [dictionary objectForKey:@"name"];
        _nationality = [dictionary objectForKey:@"nationality"];
        _num = [dictionary objectForKey:@"num"];
        _sex = [dictionary objectForKey:@"sex"];
        _birth = [dictionary objectForKey:@"birth"];
        _issue = [dictionary objectForKey:@"issue"];
        _start_date = [dictionary objectForKey:@"start_date"];
        _end_date = [dictionary objectForKey:@"end_date"];
        _success = [[dictionary objectForKey:@"success"] boolValue];
    }
    return self;
}

@end
