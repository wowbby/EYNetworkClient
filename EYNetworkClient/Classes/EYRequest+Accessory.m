//
//  EYRequest+Accessory.m
//  AFNetworking
//
//  Created by 振兴郑 on 2019/2/23.
//

#import "EYRequest+Accessory.h"
#import "UpLogManager.h"
@protocol EYRequestDelegate;

@implementation EYRequest (Accessory)
- (void)toggleAccessoriesStart
{
    NSArray<id<EYRequestDelegate>> *accessories = self.accessories.allObjects;

    [accessories enumerateObjectsUsingBlock:^(id<EYRequestDelegate> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

      if ([obj respondsToSelector:@selector(requestStart:)]) {
          [obj requestStart:self];
      }
    }];

    UpLogInfo(@"%@", self.description);
}
- (void)toggleAccessoriesCancle
{
    NSArray<id<EYRequestDelegate>> *accessories = self.accessories.allObjects;

    [accessories enumerateObjectsUsingBlock:^(id<EYRequestDelegate> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

      if ([obj respondsToSelector:@selector(requestCancle:)]) {
          [obj requestCancle:self];
      }
    }];
    UpLogInfo(@"%@", self.description);
}
- (void)toggleAccessoriesSuspend
{
    NSArray<id<EYRequestDelegate>> *accessories = self.accessories.allObjects;

    [accessories enumerateObjectsUsingBlock:^(id<EYRequestDelegate> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

      if ([obj respondsToSelector:@selector(requestSuspend:)]) {
          [obj requestSuspend:self];
      }
    }];
    UpLogInfo(@"%@", self.description);
}
- (void)toggleAccessoriesResume
{
    NSArray<id<EYRequestDelegate>> *accessories = self.accessories.allObjects;

    [accessories enumerateObjectsUsingBlock:^(id<EYRequestDelegate> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

      if ([obj respondsToSelector:@selector(requestResume:)]) {
          [obj requestResume:self];
      }
    }];
    UpLogInfo(@"%@", self.description);
}
- (void)toggleAccessoriesFinished
{
    NSArray<id<EYRequestDelegate>> *accessories = self.accessories.allObjects;

    [accessories enumerateObjectsUsingBlock:^(id<EYRequestDelegate> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

      if ([obj respondsToSelector:@selector(requestFinished:)]) {
          [obj requestFinished:self];
      }
    }];
    UpLogInfo(@"%@", self.description);
}
- (void)toggleAccessoriesFailed
{
    NSArray<id<EYRequestDelegate>> *accessories = self.accessories.allObjects;

    [accessories enumerateObjectsUsingBlock:^(id<EYRequestDelegate> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

      if ([obj respondsToSelector:@selector(requestFailed:)]) {
          [obj requestFailed:self];
      }
    }];
    UpLogInfo(@"%@", self.description);
}
@end
