//
//  ViewController.m
//  js与oc交互练习2
//
//  Created by Mac on 2017/1/13.
//  Copyright © 2017年 JDXX. All rights reserved.
//http://blog.csdn.net/y550918116j/article/details/49020809#comments
//http://blog.csdn.net/hbblzjy/article/details/52796687

//1.点击oc按钮,oc切换页面  实现
//2.点击html按钮,js切换页面  实现
//3.点击html按钮,oc的控制器dismiss掉  实现 
//4.点击oc按钮,js切换页面  实现
//5.点击html标签,oc切换界面  

#import "ViewController.h"
#import "WebVC.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(100,100,200,30);
    UIButton *button = [[UIButton alloc]initWithFrame:rect];
    [button setTitle:@"跳转web页面" forState:UIControlStateNormal];
    button.backgroundColor =[UIColor lightGrayColor];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(modalWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
 
    
}

//跳出webView
-(void)modalWebView
{
    WebVC *webVc = [[WebVC alloc]init];
    [self presentViewController:webVc animated:YES completion:nil];
}





@end
