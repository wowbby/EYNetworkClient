//
//  EYViewController.m
//  EYNetworkClient
//
//  Created by wowbby on 09/20/2018.
//  Copyright (c) 2018 wowbby. All rights reserved.
//

#import "EYViewController.h"
#import "EYRequest.h"
#import "RACSignal+RACSupport.h"
@interface EYViewController ()
@property (nonatomic, strong) EYRequest *request;
@end

@implementation EYViewController
- (IBAction)btnAction:(id)sender
{

    [self.request suspend];
}
- (IBAction)re:(id)sender
{
    [self.request resume];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    http://api01.bitspaceman.com:8000/news/qihoo?apikey=6Vw54sUQ1woFrPFsUeRtjPk6CSWIJRBnQKJV6DJ1BjD5Xo4zDyLpE38w7R8nkjUs

    self.request = [EYRequest new];

    [[self.request start] subscribeStart:^(NSURLSessionTask *task) {
      NSLog(@"start");
    }
        Next:^(EYRequest *_Nullable x) {
          NSLog(@"%@", x.responseObject);
        }
        progress:^(NSProgress *progress) {
          NSLog(@"progress:%f", progress.fractionCompleted);
        }
        error:^(NSError *_Nullable error) {
          NSLog(@"error:%@", error);
        }
        completed:^{
          NSLog(@"completed");
        }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
