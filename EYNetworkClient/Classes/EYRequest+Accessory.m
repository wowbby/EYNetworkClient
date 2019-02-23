//
//  EYRequest+Accessory.m
//  AFNetworking
//
//  Created by 振兴郑 on 2019/2/23.
//

#import "EYRequest+Accessory.h"
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
}
- (void)toggleAccessoriesCancle
{
    NSArray<id<EYRequestDelegate>> *accessories = self.accessories.allObjects;

    [accessories enumerateObjectsUsingBlock:^(id<EYRequestDelegate> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

      if ([obj respondsToSelector:@selector(requestCancle:)]) {
          [obj requestCancle:self];
      }
    }];
}
- (void)toggleAccessoriesSuspend
{
    NSArray<id<EYRequestDelegate>> *accessories = self.accessories.allObjects;

    [accessories enumerateObjectsUsingBlock:^(id<EYRequestDelegate> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

      if ([obj respondsToSelector:@selector(requestSuspend:)]) {
          [obj requestSuspend:self];
      }
    }];
}
- (void)toggleAccessoriesResume
{
    NSArray<id<EYRequestDelegate>> *accessories = self.accessories.allObjects;

    [accessories enumerateObjectsUsingBlock:^(id<EYRequestDelegate> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

      if ([obj respondsToSelector:@selector(requestResume:)]) {
          [obj requestResume:self];
      }
    }];
}
- (void)toggleAccessoriesFinished
{
    NSArray<id<EYRequestDelegate>> *accessories = self.accessories.allObjects;

    [accessories enumerateObjectsUsingBlock:^(id<EYRequestDelegate> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

      if ([obj respondsToSelector:@selector(requestFinished:)]) {
          [obj requestFinished:self];
      }
    }];
}
- (void)toggleAccessoriesFailed
{
    NSArray<id<EYRequestDelegate>> *accessories = self.accessories.allObjects;

    [accessories enumerateObjectsUsingBlock:^(id<EYRequestDelegate> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

      if ([obj respondsToSelector:@selector(requestFailed:)]) {
          [obj requestFailed:self];
      }
    }];
}
@end
