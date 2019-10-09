//
//  WKDelegateController.m
//  js与oc交互练习
//
//  Created by Mac on 2017/1/13.
//  Copyright © 2017年 JDXX. All rights reserved.
//

#import "WKDelegateController.h"

@interface WKDelegateController ()

@end

@implementation WKDelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)])
    {
        [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}


@end
