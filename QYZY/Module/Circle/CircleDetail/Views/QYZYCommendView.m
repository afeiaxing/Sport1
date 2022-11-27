//
//  QYZYCommendView.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/3.
//

#import "QYZYCommendView.h"
#import "QYZYCommendInputView.h"
#import "QYZYCommendReplyApi.h"
#import "QYZYCommendListCell.h"
#import "QYZYMsgInspectionApi.h"
#import "QYZYCommendSendApi.h"

@interface QYZYCommendView ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) QYZYCommendInputView *commendInputView;

@property (nonatomic, assign) CGFloat bottomArea;

@property (nonatomic, strong) QYZYCircleCommendModel *model;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *replyList;
// 当前需要回复的
@property (nonatomic, strong) QYZYCircleCommendModel *currentReply;

@end

@implementation QYZYCommendView

#pragma mark - lazy load
- (QYZYCommendInputView *)commendInputView {
    if (!_commendInputView) {
        _commendInputView = [[QYZYCommendInputView alloc] init];
        _commendInputView.backgroundColor = UIColor.whiteColor;
        _commendInputView.parentView = self;
        weakSelf(self)
        _commendInputView.msgSendBlock = ^(NSString * _Nonnull msg) {
            strongSelf(self)
            [self textInspection:msg];
        };
    }
    return _commendInputView;
}

- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = UIColor.whiteColor;
        _container.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 120);
    }
    return _container;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"QYZYCommendListCell" bundle:nil] forCellReuseIdentifier:@"QYZYCommendListCell"];
        _tableView.backgroundColor = rgb(248, 250, 255);
    }
    return _tableView;
}

- (NSMutableArray *)replyList {
    if (!_replyList) {
        _replyList = [[NSMutableArray alloc] init];
    }
    return _replyList;
}

- (instancetype)initWithBottomArea:(CGFloat)safeBottom model:(QYZYCircleCommendModel *)model {
    self = [super init];
    if (self) {
        self.bottomArea = safeBottom;
        self.model = model;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - Notify
- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notify {
    CGFloat keyboardHeight = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self.commendInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-keyboardHeight);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.commendInputView updateInputViewWithStatus:YES];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notify {
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self.commendInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.container).offset(0);
        make.width.mas_offset(ScreenWidth);
        make.height.mas_offset(52 + self.bottomArea);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.commendInputView updateInputViewWithStatus:NO];
    }];
    
    self.currentReply = nil;
}

- (void)showView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [window addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [self addSubview:self.container];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight-120) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(12,12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-120);
    maskLayer.path = maskPath.CGPath;
    self.container.layer.mask = maskLayer;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = rgb(216, 216, 216);
    line.layer.cornerRadius = 2;
    [self.container addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(48);
        make.height.mas_offset(4);
        make.top.equalTo(self.container).offset(16);
        make.centerX.equalTo(self.container);
    }];
    
    [self.container addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(6);
        make.left.bottom.right.equalTo(self.container);
    }];
    
    [self.container addSubview:self.commendInputView];
    [self.commendInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.container).offset(0);
        make.width.mas_offset(ScreenWidth);
        make.height.mas_offset(52 +self.bottomArea );
    }];
    
    [self animation];
    [self addObserver];
    [self loadDataAtPage:1];
}

- (void)removeView {
    [UIView animateWithDuration:0.35f animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.container.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 120);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)animation {

    [UIView animateWithDuration:0.35f animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.container.frame = CGRectMake(0, 120, ScreenWidth, ScreenHeight - 120);
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self) {
        return YES;
    }
    return NO;
}

#pragma mark - request
- (void)loadDataAtPage:(NSInteger)page {
    QYZYCommendReplyApi *api = [QYZYCommendReplyApi new];
    api.pageNum = page;
    api.pageSize = 15;
    api.postId = self.model.Id;
    api.order = @"desc";

    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        id data = request.responseObject;
        if ([data isKindOfClass:[NSDictionary class]]) {
            id subData = [data valueForKey:@"data"];
            if ([subData isKindOfClass:[NSDictionary class]]) {
                id son = [subData valueForKey:@"son"];
                if ([son isKindOfClass:[NSDictionary class]]) {
                    id list = [son valueForKey:@"list"];
                    NSArray *models = [NSArray yy_modelArrayWithClass:[QYZYCircleCommendModel class] json:list];
                    self.replyList = models.mutableCopy;
                }
            }
            
            [self.tableView reloadData];
        }
        
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
}

- (void)textInspection:(NSString *)msg {
    QYZYMsgInspectionApi *api = [QYZYMsgInspectionApi new];
    api.text = msg;
    [self qyzy_showMsg:@"发布中!"];
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            strongSelf(self)
        id data = request.responseObject;
        if ([data isKindOfClass:[NSDictionary class]]) {
            id subData = [data valueForKey:@"data"];
            if ([subData isKindOfClass:[NSString class]]) {
                NSString *str = subData;
                if (str.length == 0) {
                    [self commendPost:msg];
                }else {
                    [self qyzy_showMsg:str];
                }
            }else {
                if (subData == nil ||subData == [NSNull null]) {
                    [self commendPost:msg];
                }
            }
        }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        }];
}

- (void)commendPost:(NSString *)content {
    QYZYCommendSendApi *api = [QYZYCommendSendApi new];
    api.isComment = @"1";
    api.content = content;
    if (self.currentReply == nil) {
        self.currentReply = self.model;
    }
    api.replyId = self.currentReply.Id;
        
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        [self endEditing:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self qyzy_showMsg:@"发布成功"];
        });
        [self loadDataAtPage:1];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self qyzy_showMsg:@"发布失败"];
            });
        }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.replyList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYZYCommendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYCommendListCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.needAtReply = NO;
        cell.model = self.model;
    }else {
        cell.needAtReply = YES;
        cell.model = self.replyList[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==1) {
        return 50;
    }else {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = rgb(248, 250, 255);
    
    if (section == 1) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
        header.backgroundColor = UIColor.whiteColor;
        [view addSubview:header];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = [NSString stringWithFormat:@"%@条回复",@"0"];
        titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [header addSubview:titleLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(header);
            make.left.equalTo(header).offset(12);
        }];
    }

    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        self.currentReply = self.model;
    }else {
        self.currentReply = self.replyList[indexPath.row];
    }
    
    [self.commendInputView.textView becomeFirstResponder];
}


@end
