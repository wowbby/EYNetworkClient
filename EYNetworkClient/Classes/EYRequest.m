//
//  EYRequest.m
//  AFNetworking
//
//  Created by 振兴郑 on 2018/9/20.
//

#import "EYRequest.h"
#import "EYNetwokAgent.h"
#import "RACSignal+RACSupport.h"
#import "EYNetwork.h"
#import "EYRACSubscriber.h"
@interface EYRequest ()
@property (nonatomic, strong, readwrite, nonnull) NSURLSessionTask *task;
@property (nonatomic, strong, readwrite, nonnull) NSURLRequest *currentRequest;
@property (nonatomic, strong, readwrite, nonnull) NSURLRequest *originalRequest;
@property (nonatomic, strong, readwrite, nullable) NSURLResponse *response;
@property (nonatomic, assign, readwrite) NSInteger statusCode;
@property (nonatomic, strong, readwrite, nullable) NSDictionary *reponseHeaders;
@property (nonatomic, strong, readwrite, nullable) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSError *error;
@end

@implementation EYRequest
- (void)setTask:(NSURLSessionTask *)task
{
    _task = task;
    self.currentRequest = task.currentRequest;
    self.originalRequest = task.originalRequest;
    self.response = task.response;
    if ([task.response isKindOfClass:NSHTTPURLResponse.class]) {
        self.statusCode = [(NSHTTPURLResponse *)task.response statusCode];
        self.requestHeaders = [(NSHTTPURLResponse *)task.response allHeaderFields];
    }
}
- (RACSignal *)start
{

    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {

      return [[[EYNetwokAgent shareAgent] addRequest:self] subscribeNext:^(id _Nullable x) {

        if ([x isKindOfClass:[RACTuple class]]) {
            RACTupleUnpack(NSURLSessionDataTask * task, id responseObject) = x;
            self.task = task;
            self.responseObject = responseObject;
        }
        [subscriber sendNext:self];
      }
          progress:^(NSProgress *progress) {
            [(EYRACSubscriber *)subscriber sendProgress:progress];
          }
          error:^(NSError *_Nullable error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
          }
          completed:^{
            [subscriber sendCompleted];
          }];
    }];
}
- (NSString *)baseURL
{

    return @"http://api01.bitspaceman.com:8000";
}
- (NSString *)path
{
    return @"/news/qihoo";
}
- (EYRequestSerializerType)requestSerializerType
{
    return EYRequestSerializerTypeHTTP;
}
- (EYResponseSerializerType)responseSerializerType
{
    return EYResponseSerializerTypeJSON;
}
- (id)requestArgument
{

    return @{ @"apikey" : @"6Vw54sUQ1woFrPFsUeRtjPk6CSWIJRBnQKJV6DJ1BjD5Xo4zDyLpE38w7R8nkjUs",
              @"kw" : @"腾讯" };
}
@end
