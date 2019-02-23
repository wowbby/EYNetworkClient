//
//  EYRequest+Accessory.h
//  AFNetworking
//
//  Created by 振兴郑 on 2019/2/23.
//

#import "EYRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface EYRequest (Accessory)
- (void)toggleAccessoriesStart;
- (void)toggleAccessoriesCancle;
- (void)toggleAccessoriesSuspend;
- (void)toggleAccessoriesResume;
- (void)toggleAccessoriesFinished;
- (void)toggleAccessoriesFailed;
@end

NS_ASSUME_NONNULL_END
