//
//  DCTBaseTableViewModel.h
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCTBaseTableViewModel : NSObject<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSArray<NSDictionary *> *tableViewConfiguration;

@property (nonatomic, assign) BOOL canSave;//页面是否可保存
@property (nonatomic, assign) BOOL canNext;//页面是否可提交至下一步

@property (nonatomic, strong) RACCommand *submitCommand;
- (instancetype)initWithConfigurationInfo:(NSDictionary *)configurationInfo
                                SaveBlock:(nullable id)saveBlock
                                NextBlock:(nullable id)nextBlock
                            DataInfoBlock:(nullable DataInfoBlock)dataInfoBlock
                            UserInfoBlock:(nullable UserInfoBlock)userInfoBlock
                             DataInfoBind:(nullable DataInfoBind)dataInfoBind
                             UserInfoBind:(nullable UserInfoBind)userInfoBind
                         SetDataInfoBlock:(nullable SetDataInfoBlock)setDataInfoBlock NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (NSDictionary *)sectionConfigurationWithSection:(NSInteger)section;
- (id)cellConfigurationWithIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
