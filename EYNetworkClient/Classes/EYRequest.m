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
    NSLog(@"%@", self.description);
    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {
      return [[[EYNetwokAgent shareAgent] addRequest:self] subscribeStart:^(NSURLSessionTask *task) {
        self.task = task;
        [(EYRACSubscriber *)subscriber sendStart:task];
      }
          Next:^(id _Nullable x) {

            if ([x isKindOfClass:[RACTuple class]]) {
                RACTupleUnpack(NSURLSessionDataTask * task, id responseObject) = x;
                self.task = task;
                self.responseObject = responseObject;
            }
            [subscriber sendNext:self];
            [subscriber sendCompleted];
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
- (void)cancle
{
    if (self.task && (self.task.state == NSURLSessionTaskStateRunning || self.task.state == NSURLSessionTaskStateSuspended)) {
        [self.task cancel];
    }
}
- (void)suspend
{

    if (self.task && self.task.state == NSURLSessionTaskStateRunning) {
        [self.task suspend];
    }
}
- (void)resume
{
    if (self.task && self.task.state != NSURLSessionTaskStateRunning) {
        [self.task resume];
    }
}
- (NSTimeInterval)timeoutInterval
{

    return 15;
}
- (NSString *)baseURL
{
    return @"https://uhome.haier.net:7253";
}
- (NSString *)path
{
    return @"/acquisitionData/open/getCityWeatherList";
}
- (EYRequestMethod)method
{

    return EYRequestMethodPOST;
}
- (EYRequestSerializerType)requestSerializerType
{
    return EYRequestSerializerTypeJSON;
}
- (EYResponseSerializerType)responseSerializerType
{
    return EYResponseSerializerTypeJSON;
}
- (id)requestArgument
{

    return @{
        @"userId" : @"20567040",
        @"cityId" : @"101010100",
        @"language" : @"zh_cn"
    };
}
- (NSDictionary<NSString *, NSString *> *)requestHeaders
{

    return @{ @"appKey" : @"25f61cd00659b6e91c9d28c080c78e9a",
              @"appVersion" : @"2.27.0",
              @"sequenceId" : @"20180417141300000001",
              @"clientId" : @"356877020056553-08002700DC94",
              @"appId" : @"MB-AIRCONDITION1-0000",
              @"accessToken" : @"",
              @"Content-Type" : @"application/json; charset=utf-8"
    };
}
- (NSString *)description
{

    return [NSString stringWithFormat:@"EYRequest:\n name :{%@},\n baseURL:{%@},\n cdnURL:{%@},\n path:{%@},\n body:{%@},\n header:{%@},\n method:{%ld}", self.name, self.baseURL, self.cdnURL, self.path, self.requestArgument, self.requestHeaders, self.method];
}
@end
