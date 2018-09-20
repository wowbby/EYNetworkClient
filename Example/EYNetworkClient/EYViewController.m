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

@end

@implementation EYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    http://api01.bitspaceman.com:8000/news/qihoo?apikey=6Vw54sUQ1woFrPFsUeRtjPk6CSWIJRBnQKJV6DJ1BjD5Xo4zDyLpE38w7R8nkjUs
    
    [[[EYRequest new] start] subscribeNext:^(id  _Nullable x) {
        
    } progress:^(NSProgress *progress) {
        
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
