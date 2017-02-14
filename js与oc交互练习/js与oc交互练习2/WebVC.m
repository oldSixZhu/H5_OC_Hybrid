//
//  webVC.m
//  js与oc交互练习2
//
//  Created by Mac on 2017/1/13.
//  Copyright © 2017年 JDXX. All rights reserved.
//

#import "WebVC.h"
#import <WebKit/WebKit.h>
#import "WKDelegateController.h"

@interface WebVC ()<WKUIDelegate,WKNavigationDelegate,WKDelegate>

@property (strong, nonatomic) WKWebView *webView;

@property (strong, nonatomic) WKUserContentController *userContent;

@property (weak, nonatomic) UIButton *backBtn;
@end

@implementation WebVC

- (void)dealloc
{
    NSLog(@"无循环引用");
    //这里需要注意，前面增加过的方法一定要remove掉。
    //addScriptMessageHandler要和removeScriptMessageHandlerForName配套出现，否则会造成内存泄漏。
    [self.userContent removeScriptMessageHandlerForName:@"ocMethod"];
    [self.userContent removeScriptMessageHandlerForName:@"presentMethod"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //创建配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //创建UserContentController(提供javaScript向webView发送消息的方法)
    self.userContent = [[WKUserContentController alloc] init];
    //添加消息处理，
    //注意： addScriptMessageHandler后面的参数指代的是需要遵守WKScriptMessageHandler协议，结束时需要移除
    //但无论在哪里移除都会发现dealloc并不会执行，这样肯定是不行的，会造成内存泄漏
    //试了下用weak指针还是不能释放，不知道是什么原因
    //因此参考百度上的写法是用一个新的controller来处理,新的controller再绕用delegate绕回来,即使没移除也会走dealloc了
    WKDelegateController * delegateController = [[WKDelegateController alloc]init];
    delegateController.delegate = self;
    [self.userContent addScriptMessageHandler:delegateController  name:@"ocMethod"];
    [self.userContent addScriptMessageHandler:delegateController  name:@"presentMethod"];
    //将UserContent设置到配置文件中
    config.userContentController = self.userContent;
    //配置webView
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    //加载本地html
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
    //添加一个返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 35, 50, 50)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = backBtn;
    [self.webView addSubview:backBtn];
}

//这里就是使用高端配置，js调用oc的处理地方。我们可以根据name和body，进行桥协议的处理。
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSString *messageName = message.name;
    if ([@"ocMethod" isEqualToString:messageName])
    {
        id messageBody = message.body;
        NSLog(@"%@",messageBody);
        //点击html按钮,让当前webView页面dismiss掉
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else if([@"presentMethod" isEqualToString:messageName])
    {
        id messageBody = message.body;
        NSLog(@"%@",messageBody);
        //弹出一个新的控制器
        UIViewController *newVC = [[UIViewController alloc]init];
        newVC.view.backgroundColor = [UIColor redColor];
        
        CGRect rect = CGRectMake(100,100,100,50);
        UIButton *button = [[UIButton alloc]initWithFrame:rect];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        [button addTarget:self action:@selector(dismissNewVC) forControlEvents:UIControlEventTouchUpInside];
        [newVC.view addSubview:button];
        
        [self presentViewController:newVC animated:YES completion:nil];
    }
}

-(void)dismissNewVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//点击oc按钮,调用js方法
-(void)back
{
    //第一种:直接调用
    //无论web页面跳转多少次,只要按钮存在,js都可以生效
    [self.webView evaluateJavaScript:@"function sayHello(){     \
                                            alert('jack')     \
                                        }                       \
                                        sayHello()"
                   completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
    
    //第二种:直接调用html文件中的js代码
    //注意:这种方式只有在第一个web页面js才能生效,跳转到第二个web页面就无效了
    //因为页面跳转后,就不是我们引入的本地的html页面了,自然也就引入不了我们本地的js代码
    //不过也正常,我们一般只需要在第一个页面添加一个返回按钮,dismiss掉这个webView,其他的功能都可以用html的按钮实现
    [self.webView evaluateJavaScript:@"hello()"completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
    
    //第三种:调用html文件中引入的js文件的js代码
    //注意:js效果与第二种相同
    [self.webView evaluateJavaScript:@"back()"completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
}

//wkWebView直接调用js的弹窗是无效的,需要拦截js中的alert,用oc的方式展现出来
//该方法中的message参数就是我们JS代码中alert函数里面的参数内容
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"----------%@",message);
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"js的弹窗" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //一定要调用下这个block,否则会崩
        //API说明：The completion handler to call after the alert panel has been dismissed
        completionHandler();
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}




@end
