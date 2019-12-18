//
//  DCTPickTypeView.m
//  Pods
//
//  Created by Luigi on 2019/12/18.
//

#import "DCTPickTypeView.h"

@interface DCTPickTypeView ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> *dataArray;
@property (nonatomic, copy) NSArray<NSString *> *allTitleArray;
@property (nonatomic, copy) NSArray<NSString *> *allValueArray;

@property (nonatomic, strong)   UIPickerView    *pickerView;
@property (nonatomic, copy)     NSString        *pickerTitle;
@property (nonatomic, assign)   NSInteger       selectedRow;
@end

@implementation DCTPickTypeView
- (instancetype)initWithTitle:(NSString *)title DataArray:(NSArray<NSDictionary<NSString *,NSString *> *> *)dataArray {
    if (self = [super init]) {
        self.dataArray = dataArray;
        self.pickerTitle = STRING_Safe(title);
        self.selectedValue = @"";
        self.selectedTitle = @"";
        [self createUI];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutUI];
}

#pragma mark - SetData
- (void)setSelectedTitle:(NSString *)selectedTitle {
    _selectedTitle = selectedTitle;
    if (!STRING_IsNull(selectedTitle)) {
        if ([self.allTitleArray containsObject:self.selectedTitle]) {
            NSInteger index = [self.allTitleArray indexOfObject:self.selectedTitle];
            self.selectedRow = index;
            [self.pickerView selectRow:index inComponent:0 animated:NO];
        }
    }
}

- (void)setSelectedValue:(NSString *)selectedValue {
    _selectedValue = selectedValue;
    if (!STRING_IsNull(selectedValue)) {
        if ([self.allValueArray containsObject:self.selectedValue]) {
            NSInteger index = [self.allValueArray indexOfObject:self.selectedValue];
            self.selectedRow = index;
            [self.pickerView selectRow:index inComponent:0 animated:NO];
        }
    }
}

- (void)setDataArray:(NSArray<NSDictionary<NSString *,NSString *> *> *)dataArray{
    _dataArray = dataArray;
    
    NSMutableArray *allTitle, *allValue;
    allTitle = [[NSMutableArray alloc] initWithCapacity:dataArray.count];
    allValue = [[NSMutableArray alloc] initWithCapacity:dataArray.count];
    
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [allTitle addObject:[[obj allKeys] firstObject]];
        [allValue addObject:[[obj allValues] firstObject]];
    }];
    
    self.allTitleArray = allTitle;;
    self.allValueArray = allValue;
}

#pragma mark - LayoutUI
- (void)createUI{
    self.backgroundColor = cHEXACOLOR(0x333333, 0.5);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    self.pickerView = [UIPickerView new];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView selectRow:0 inComponent:0 animated:NO];

    
    self.titleLabel = [UILabel initWithText:@""
                                  TextColor:COLOR_BLACK_2C
                                       Font:RFont(14)
                            BackgroundColor:COLOR_GARY_BG
                              TextAlignment:NSTextAlignmentCenter];
    self.titleLabel.text = self.pickerTitle;
    self.titleLabel.userInteractionEnabled = YES;
    
    self.confirmButton = [UIButton new];
    [self.confirmButton setBackgroundImage:[UIImage imageWithColor:COLOR_GARY_BG] forState:UIControlStateNormal];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton.titleLabel setFont:MFont(15)];
    [self.confirmButton setTitleColor:cHEXCOLOR(#004FA1) forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton = [UIButton new];
    [self.cancelButton setBackgroundImage:[UIImage imageWithColor:COLOR_GARY_BG] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:MFont(15)];
    [self.cancelButton setTitleColor:cHEXCOLOR(#004FA1) forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.confirmButton];
    [self addSubview:self.cancelButton];
    [self addSubview:self.pickerView];
}

- (void)layoutUI{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.offset(43);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.titleLabel);
        make.width.offset(57);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.titleLabel);
        make.width.offset(57);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.offset(216);
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.pickerView] || [touch.view isDescendantOfView:self.titleLabel] || [touch.view isDescendantOfView:self.confirmButton]) {
        return NO;
    }
    return YES;
}

#pragma mark - UIPickerViewDataSource,UIGestureRecognizerDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.allValueArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 37.f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREEN_WIDTH;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 2)
        {
            singleLine.backgroundColor = [UIColor clearColor];
        }
    }
    //设置文字的属性（改变picker中字体的颜色大小）
    UILabel *pickerLabel = [UILabel new];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.text = [self.allValueArray objectAtIndex:row];
    pickerLabel.font = MFont(17);
    pickerLabel.textColor = COLOR_BLACK_4C;
    //改变选中行颜色（设置一个全局变量，在选择结束后获取到当前显示行，记录下来，刷新picker）
    if (row == self.selectedRow) {
        //改变当前显示行的字体颜色，如果你愿意，也可以改变字体大小，状态
        pickerLabel.textColor = cHEXCOLOR(#004FA1);
    }
    
    return pickerLabel;
}

// 选中行显示在label上
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //记录下滚动结束时的行数
    self.selectedRow = row;
    //刷新picker，看上面的代理
    [pickerView reloadComponent:component];
}

#pragma mark - Action
- (void)confirmButtonClickAction{
    [self disMissView];
    
    if (self.block) {
        self.block(STRING_Safe([self.allTitleArray objectAtIndex:self.selectedRow]), STRING_Safe([self.allValueArray objectAtIndex:self.selectedRow]));
    }
}

- (void)cancelButtonClickAction{
    [self disMissView];
}

#pragma mark - 动画效果
- (void)disMissView{
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


- (void)pickViewShow{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self layoutIfNeeded];
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-259);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}


@end
