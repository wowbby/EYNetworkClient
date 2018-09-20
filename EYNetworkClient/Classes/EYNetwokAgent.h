//
//  EYNetwokAgent.h
//  AFNetworking
//
//  Created by 振兴郑 on 2018/9/20.
//

#import <Foundation/Foundation.h>
#import "EYNetwork.h"
#import "EYRequest.h"
@interface EYNetwokAgent : NSObject
+(instancetype)shareAgent;
-(RACSignal *)addRequest:(EYRequest *)request;
@end
