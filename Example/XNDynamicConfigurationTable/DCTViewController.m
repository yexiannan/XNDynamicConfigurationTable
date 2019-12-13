//
//  DCTViewController.m
//  XNDynamicConfigurationTable
//
//  Created by yexiannan on 11/23/2019.
//  Copyright (c) 2019 yexiannan. All rights reserved.
//

#import "DCTViewController.h"
#import "Target_DynamicConfigurationTable.h"
#import "XNHTTPManage.h"
#import "XNBaseUtils.h"
#import "Masonry.h"
#import "CFYiNuoPreliminaryApplicationModel.h"
#import "YYModel.h"

@interface DCTViewController ()

@end

@implementation DCTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /*
    根据配置表创建自定义表格 @{ @"params" : @{ @"configurationInfo" : @{},
                                           @"dataInfo" : @{} },
                            @"block" : @{ @"saveBlock" : saveBlock,
                                          @"nextBlock" : nextBlock,
                                          @"userInfoBlock" : userInfoBlock }
                         }
    */
    
    
    //创建并注入操作
    void (^saveBlock)(NSDictionary *) = ^(NSDictionary *saveData){
        NSLog(@"-----saveData = %@", saveData);
    };
    
    void (^nextBlock)(NSDictionary *) = ^(NSDictionary *nextData){
        NSLog(@"-----nextData = %@", nextData);
    };
    
    id (^userInfoBlock)(NSString *) = ^(NSString *keyPath){
        return [NSString stringWithFormat:@"keyPath = %@, userInfo = %d", keyPath, arc4random()%10];
    };
    
    NSDictionary *block = @{ @"saveBlock":saveBlock,
                             @"nextBlock":nextBlock,
                             @"userInfoBlock":userInfoBlock };
    __block NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSDictionary *data = [[CFYiNuoPreliminaryApplicationModel new] yy_modelToJSONObject];
    [params setObject:data forKey:@"dataInfo"];

    @weakify(self)
    [XNHTTPManage Post:@"https://rest.apizza.net/mock/20430e46d0052bdbd4acbac3c55e7c51/ApplicationMockData"
            parameters:nil
          hudAnimation:YES
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [params setObject:responseObject[@"tableInfo"] forKey:@"configurationInfo"];
        Target_DynamicConfigurationTable *target = [Target_DynamicConfigurationTable new];
        UIView *view = [target Action_createDynamicConfigurationTable:@{@"params":params, @"block":block}];

        @strongify(self)
        if ([view isKindOfClass:[UIView class]]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.view addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.bottom.equalTo(self.view);
                }];
            }];
        }

    }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
    
    

}

- (void)saveConfConfigurationTable {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
