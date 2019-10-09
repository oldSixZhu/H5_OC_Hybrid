//
//  ViewController.m
//  H5_OC_Hybrid
//
//  Created by 朱玉顺 on 2019/10/9.
//  Copyright © 2019 oldSix. All rights reserved.
//

#import "ViewController.h"
#import "WebVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100,100,200,30)];
    [button setTitle:@"跳转web页面" forState:UIControlStateNormal];
    button.backgroundColor =[UIColor whiteColor];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(modalWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

//跳出webView
-(void)modalWebView {
    WebVC *webVc = [[WebVC alloc]init];
    [self presentViewController:webVc animated:YES completion:nil];
}


@end
