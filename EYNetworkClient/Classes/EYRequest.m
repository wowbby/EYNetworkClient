//
//  EYRequest.m
//  AFNetworking
//
//  Created by 振兴郑 on 2018/9/20.
//

#import "EYRequest.h"
#import "EYNetwokAgent.h"
@interface EYRequest()
@property(nonatomic,strong,readwrite,nonnull)NSURLSessionTask *task;
@property(nonatomic,strong,readwrite,nonnull)NSURLRequest * currentRequest;
@property(nonatomic,strong,readwrite,nonnull)NSURLRequest * originalRequest;
@property(nonatomic,strong,readwrite,nullable)NSURLResponse * response;
@property(nonatomic,assign,readwrite)NSInteger statusCode;
@property(nonatomic,strong,readwrite,nullable)NSDictionary*reponseHeaders;
@property(nonatomic,strong,readwrite,nullable)NSData * responseData;
@property(nonatomic,strong,readwrite,nullable)NSString * responseString;
@property(nonatomic,strong,readwrite,nullable)id responseObject;
@property(nonatomic,strong,readwrite,nullable)id responseJSONObject;
@property(nonatomic,strong,readwrite,nullable)NSError * error;
@end

@implementation EYRequest
-(RACSignal *)start{
    
    return [[EYNetwokAgent shareAgent] addRequest:self];
}
-(NSString *)baseURL{
    
    return @"http://api01.bitspaceman.com:8000";
}
-(NSString *)path{
    return @"/news/qihoo";
}
-(EYRequestSerializerType)requestSerializerType{
    return EYRequestSerializerTypeHTTP;
}
-(EYResponseSerializerType)responseSerializerType{
    return EYResponseSerializerTypeJSON;
}
-(id)requestArgument{
    
    return @{@"apikey":@"6Vw54sUQ1woFrPFsUeRtjPk6CSWIJRBnQKJV6DJ1BjD5Xo4zDyLpE38w7R8nkjUs"};
}
@end
