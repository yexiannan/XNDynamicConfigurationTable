//
//  DCTViewController.m
//  XNDynamicConfigurationTable
//
//  Created by yexiannan on 11/23/2019.
//  Copyright (c) 2019 yexiannan. All rights reserved.
//

#import "DCTViewController.h"
#import "Target_DynamicConfigurationTable.h"
#import "XNBaseUtils.h"
#import "Masonry.h"
#import "CFYiNuoPreliminaryApplicationModel.h"
#import "YYModel.h"
#import "XNHTTPManage.h"
#import "ReactiveObjC.h"

//获取数据
typedef id _Nullable (^UserInfoBlock)(NSString *_Nonnull);
typedef id _Nullable (^DataInfoBlock)(NSString *_Nonnull);

//设置数据
typedef id _Nullable (^SetDataInfoBlock)(NSString *_Nonnull, id _Nullable);

//监听数据
typedef RACSignal * _Nullable (^UserInfoBind)(NSString *_Nonnull);
typedef RACSignal * _Nullable (^DataInfoBind)(NSString *_Nonnull);


@interface DCTViewController ()
@property (nonatomic, strong) CFYiNuoPreliminaryApplicationModel *dataInfo;
@end

@implementation DCTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /*
    根据配置表创建自定义表格 @{ @"params" : @{ @"configurationInfo" : @{} },
                            @"block" : @{ @"saveBlock" : saveBlock,
                                          @"nextBlock" : nextBlock,
                                          @"dataInfoBlock" : dataInfoBlock
                                          @"userInfoBlock" : userInfoBlock
                                          @"dataInfoBind" : dataInfoBind
                                          @"userInfoBind" : userInfoBInd
                                          @"setDataInfoBlock" : setDataInfoBlock }
                         }
    */
    

    
    //创建并注入操作
    void (^saveBlock)(NSDictionary *) = ^(NSDictionary *saveData){
        NSLog(@"-----saveData = %@", saveData);
    };
    
    void (^nextBlock)(NSDictionary *) = ^(NSDictionary *nextData){
        NSLog(@"-----nextData = %@", nextData);
    };
    
    @weakify(self)
    UserInfoBlock userInfoBlock = ^(NSString *keyPath){
        return [NSString stringWithFormat:@"keyPath = %@, userInfo = %d", keyPath, arc4random()%10];
    };
    
    DataInfoBlock dataInfoBlock = ^(NSString *keyPath){
        @strongify(self)
        return [self.dataInfo valueForKeyPath:keyPath];
    };
    
    DataInfoBind dataInfoBind = ^RACSignal *(NSString *keyPath){
        @strongify(self)
        __weak id target_ = self.dataInfo;
        return [target_ rac_valuesForKeyPath:keyPath observer:self];
    };
    
    SetDataInfoBlock setDataInfoBlock = ^id (NSString *keyPath, id dataInfo){
        @strongify(self)
        [self.dataInfo setValue:dataInfo forKeyPath:keyPath];
        return @(YES);
    };
    
    
    NSDictionary *block = @{ @"saveBlock":saveBlock,
                             @"nextBlock":nextBlock,
                             @"userInfoBlock":userInfoBlock,
                             @"setDataInfoBlock":setDataInfoBlock,
                             @"dataInfoBind":dataInfoBind,
                             @"dataInfoBlock":dataInfoBlock,
    };
    __block NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSDictionary *data = [[CFYiNuoPreliminaryApplicationModel new] yy_modelToJSONObject];
    [params setObject:data forKey:@"dataInfo"];

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
                    make.left.right.equalTo(self.view);
                    if (@available(iOS 11.0, *)) {
                        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                    } else {
                        make.top.equalTo(self.mas_topLayoutGuide);
                        make.bottom.equalTo(self.mas_bottomLayoutGuide);
                    }
                    
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
