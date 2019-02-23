//
//  EYRequest.m
//  AFNetworking
//
//  Created by 振兴郑 on 2018/9/20.
//

#import "EYRequest.h"
#import "EYNetwokAgent.h"
#import <EYNetwork/RACSignal+RACSupport.h>
#import <EYNetwork/EYNetwork.h>
#import <EYNetwork/EYRACSubscriber.h>
#import "NSString+Hash.h"
#import "EYRequestCache.h"
#import "EYRequestSampleCache.h"
#import "EYRequest+Accessory.h"
@interface EYRequest ()
@property (nonatomic, strong, readwrite, nonnull) NSURLSessionTask *task;
@property (nonatomic, strong, readwrite, nonnull) NSURLRequest *currentRequest;
@property (nonatomic, strong, readwrite, nonnull) NSURLRequest *originalRequest;
@property (nonatomic, strong, readwrite, nullable) NSURLResponse *response;
@property (nonatomic, assign, readwrite) NSInteger statusCode;
@property (nonatomic, strong, readwrite, nullable) NSDictionary *reponseHeaders;
@property (nonatomic, strong, readwrite, nullable) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSError *error;
@property (nonatomic, strong, nonnull) id<EYRequestCache> cache;
@property (strong, nonatomic, nullable) NSHashTable<id<EYRequestDelegate>> *accessories;
@end

@implementation EYRequest
- (instancetype)init
{
    if (self = [super init]) {

        self.cache = [[EYRequestSampleCache alloc] initWithCacheKey:self.cacheKey cacheTimeInSeconds:self.cacheTimeInSeconds responseSerializerType:self.responseSerializerType];
        self.accessories = [NSHashTable weakObjectsHashTable];
    }
    return self;
}
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

      if (!self.ignoreCache) {
          id cacheObject = [self.cache loadCachdata];
          if (cacheObject) {
              [(EYRACSubscriber *)subscriber sendStart:nil];
              [self toggleAccessoriesStart];
              self.responseObject = cacheObject;
              [subscriber sendNext:self];
              [subscriber sendCompleted];
              [self toggleAccessoriesFinished];
              return [RACDisposable disposableWithBlock:^{
              }];
          }
          else {
              return [self netwokAgentaddRequestSubscribeWithRACSubscriber:subscriber];
          }
      }
      return [self netwokAgentaddRequestSubscribeWithRACSubscriber:subscriber];
    }];
}
- (RACDisposable *)netwokAgentaddRequestSubscribeWithRACSubscriber:(id<RACSubscriber>)subscriber
{

    return [[[EYNetwokAgent shareAgent] addRequest:self] subscribeStart:^(NSURLSessionTask *task) {
      self.task = task;
      [(EYRACSubscriber *)subscriber sendStart:task];
      [self toggleAccessoriesStart];
    }
        Next:^(id _Nullable x) {

          if ([x isKindOfClass:[RACTuple class]]) {
              RACTupleUnpack(NSURLSessionDataTask * task, id responseObject) = x;
              self.task = task;
              self.responseObject = responseObject;
              [self saveResponseobject:responseObject];
          }
          [subscriber sendNext:self];
          [subscriber sendCompleted];
          [self toggleAccessoriesFinished];
        }
        progress:^(NSProgress *progress) {
          [(EYRACSubscriber *)subscriber sendProgress:progress];
        }
        error:^(NSError *_Nullable error) {
          [subscriber sendError:error];
          [subscriber sendCompleted];
          [self toggleAccessoriesFailed];
        }
        completed:^{
          [subscriber sendCompleted];
        }];
}
- (void)cancle
{
    if (self.task && (self.task.state == NSURLSessionTaskStateRunning || self.task.state == NSURLSessionTaskStateSuspended)) {
        [self.task cancel];
        [self toggleAccessoriesCancle];
    }
}
- (void)suspend
{

    if (self.task && self.task.state == NSURLSessionTaskStateRunning) {
        [self.task suspend];
        [self toggleAccessoriesSuspend];
    }
}
- (void)resume
{
    if (self.task && self.task.state != NSURLSessionTaskStateRunning) {
        [self.task resume];
        [self toggleAccessoriesResume];
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
- (BOOL)ignoreCache
{

    return NO;
}
- (NSString *)cacheKey
{

    NSString *keyString = [NSString stringWithFormat:@"%@%@%@%@", self.baseURL, self.path, self.requestArgument, self.requestHeaders];
    return keyString.md5String;
}
- (NSInteger)cacheTimeInSeconds
{

    return 60;
}
- (NSString *)description
{

    return [NSString stringWithFormat:@"EYRequest:\n name :{%@},\n baseURL:{%@},\n path:{%@},\n body:{%@},\n header:{%@},\n method:{%ld},\n response:{%@},\n error:{%@}", self.name, self.baseURL, self.path, self.requestArgument, self.requestHeaders, (long)self.method, self.responseObject, self.error];
}
- (void)saveResponseobject:(id)responseObject
{

    NSError *error;
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        [self.cache saveResponseDataToCacheFile:dataJson];
    }
}
- (void)addAccessory:(id<EYRequestDelegate>)accessory
{
    if (!accessory || [accessory conformsToProtocol:@protocol(EYRequestDelegate)]) {
        return;
    }
    if (![self.accessories containsObject:accessory]) {
        [self.accessories addObject:accessory];
    }
}
- (void)removeAccessory:(id<EYRequestDelegate>)accessory
{
    if (!accessory || [accessory conformsToProtocol:@protocol(EYRequestDelegate)]) {
        return;
    }
    if ([self.accessories containsObject:accessory]) {
        [self.accessories removeObject:accessory];
    }
}
@end
