//
//  QYZYLiveChatViewController.m
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import "QYZYLiveChatViewController.h"
#import "QYZYLiveChatCell.h"
#import "QYZYRIMManager.h"
#import "QYZYLiveChatInputView.h"
#import <IQKeyboardManager.h>
#import "QYZYLiveDetailViewModel.h"
#import "QYZYChatGiftView.h"
#import "QYZYChargeViewController.h"

NSString *sendFailMsg = @"消息发送失败，请重试";
NSString *reConnectMsg = @"重连中...";

@interface QYZYLiveChatViewController ()<UITableViewDelegate ,UITableViewDataSource ,RCIMClientReceiveMessageDelegate>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray <QYZYLiveChatModel *>*chatArray;
@property (nonatomic ,strong) QYZYLiveChatInputView *putView;
@property (nonatomic ,assign) BOOL hasViewDidLayout;
@property (nonatomic ,assign) CGRect sectionRect;
@property (nonatomic ,strong) QYZYLiveDetailViewModel *viewModel;
@property (nonatomic ,strong) QYZYChatGiftView *giftView;
@property (nonatomic ,strong) NSMutableArray *rcUidArray;
@end

@implementation QYZYLiveChatViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setsubViews];
    [self setup];
    [self addNotification];
    [self requestGiftData];
}

- (void)viewDidLayoutSubviews {
    if (!self.hasViewDidLayout) {
        [super viewDidLayoutSubviews];
        self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - SafeAreaInsetsConstantForDeviceWithNotch.bottom - 52);
        self.hasViewDidLayout = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.putView.textView resignFirstResponder];
    [self.putView.textView endEditing:YES];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoginStatus) name:QYZYLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestBalanceData) name:QYZYIAPPaySuccessNotification object:nil];
    
}

- (void)requestGiftData {
    weakSelf(self);
    [self.viewModel requestGetGiftWithCompletion:^(NSArray<QYZYChatGiftModel *> * _Nonnull giftArray) {
        strongSelf(self);
        if (giftArray) {
            self.giftView.giftArray = giftArray;
        }
    }];
}

#pragma mark - Noti Methods
- (void)willShowKeyboard:(NSNotification *)notification {
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.putView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-keyboardHeight);
        }];
        CGFloat tableViewOffset = keyboardHeight;
        CGFloat boundsHeight = self.tableView.bounds.size.height;
        CGFloat sectionHeight = self.sectionRect.size.height + self.sectionRect.origin.y;
        if (keyboardHeight <= boundsHeight - sectionHeight) {
            tableViewOffset = 0;
        }
        else if (0 <= boundsHeight - sectionHeight) {
            tableViewOffset = keyboardHeight + sectionHeight - boundsHeight - SafeAreaInsetsConstantForDeviceWithNotch.bottom;
        }
        else {
            tableViewOffset = keyboardHeight - SafeAreaInsetsConstantForDeviceWithNotch.bottom;
        }
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, -tableViewOffset, self.tableView.frame.size.width, self.tableView.frame.size.height);
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)willHideKeyboard:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.putView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-SafeAreaInsetsConstantForDeviceWithNotch.bottom);
        }];
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)updateLoginStatus {
    [self.putView updateStatusWithUserModel:QYZYUserManager.shareInstance.userModel];
    if (QYZYUserManager.shareInstance.isLogin) {
        [self requestBalanceData];
    }
}

- (void)setsubViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.putView];
    [self.putView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-SafeAreaInsetsConstantForDeviceWithNotch.bottom);
        make.height.mas_equalTo(52);
    }];
    [self.view addSubview:self.giftView];
    [self.giftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(281 + SafeAreaInsetsConstantForDeviceWithNotch.bottom);
    }];
}

- (void)setup {
    [RCIMClient.sharedRCIMClient setReceiveMessageDelegate:self object:nil];
}

- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([message.content isKindOfClass:RCTextMessage.class]) {
            QYZYLiveChatModel *model = [QYZYLiveChatModel yy_modelWithJSON:((RCTextMessage *)message.content).content];
            model.messageUId = message.messageUId;
            if ([self.rcUidArray containsObject:model.messageUId]) {
                return;
            } else if (model.messageUId) {
                [self.rcUidArray addObject:model.messageUId];
            }
            NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.chatArray];
            if (model.type == 0 ||
                model.type == 1) {
                [mutableArray addObject:model];
            }
            self.chatArray = mutableArray;
            [self.tableView reloadData];
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0];
            if (indexpath.row <= [self.tableView numberOfRowsInSection:0]) {
                [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                self.sectionRect = [self.tableView rectForSection:0];
            }
        }
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYZYLiveChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYLiveChatCell.class) forIndexPath:indexPath];
    if (self.chatArray.count > indexPath.row) {
        cell.chatModel = self.chatArray[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatArray.count;
}

- (void)setChatId:(NSString *)chatId {
    _chatId = chatId;
    [self checkRIMConnectStatus];
    [RCIMClient.sharedRCIMClient joinChatRoom:chatId messageCount:50 success:^{
        
    } error:^(RCErrorCode status) {
        
    }];
}

- (BOOL)checkRIMConnectStatus {
    RCConnectionStatus status = RCIMClient.sharedRCIMClient.getConnectionStatus;
    if (status != ConnectionStatus_Connected) {
        [QYZYRIMManager.shareInstace requestKeyData];
        [self.view qyzy_showMsg:reConnectMsg];
        return NO;
    }
    return YES;
}

- (void)requestFilterWithContent:(NSString *)content {
    weakSelf(self);
    [self.viewModel requestFilterDataWithContent:content completion:^(QYZYLiveChatFilterModel * _Nonnull filterModel) {
        strongSelf(self);
        if (filterModel.success) {
            NSMutableDictionary *dict = @{}.mutableCopy;
            [dict setValue:@0 forKey:@"type"];
            [dict setValue:filterModel.pushTime forKey:@"pushTime"];
            [dict setValue:filterModel.userId forKey:@"userId"];
            [dict setValue:filterModel.sign forKey:@"sign"];
            [dict setValue:filterModel.nickname forKey:@"nickname"];
            [dict setValue:filterModel.content forKey:@"content"];
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            RCTextMessage *text = [RCTextMessage messageWithContent:content];
            weakSelf(self);
            __block RCMessage *message = [RCIMClient.sharedRCIMClient sendMessage:ConversationType_CHATROOM targetId:self.chatId content:text pushContent:nil pushData:nil success:^(long messageId) {
                strongSelf(self);
                [self onReceived:message left:1 object:nil];
            } error:^(RCErrorCode nErrorCode, long messageId) {
                strongSelf(self);
                [self.view qyzy_showMsg:sendFailMsg];
            }];
        }
        else {
            [self.view qyzy_showMsg:filterModel.desc];
        }
    }];
}

- (void)requestBalanceData {
    weakSelf(self);
    [self.viewModel requestBalanceWithCompletion:^(QYZYAmountwithModel * _Nonnull model) {
        strongSelf(self);
        if (model) {
            [self.giftView updateBalance];
        }
    }];
}

#pragma mark - get
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = rgb(248, 249, 254);
//        _tableView.rowHeight = 35;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYLiveChatCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYLiveChatCell.class)];
    }
    return _tableView;
}

- (QYZYLiveChatInputView *)putView {
    if (!_putView) {
        _putView = [[QYZYLiveChatInputView alloc] init];
        weakSelf(self);
        _putView.commentBlock = ^{
            strongSelf(self);
            if (![self checkRIMConnectStatus]) {
                return;
            }
            [self requestFilterWithContent:self.putView.textView.text];
        };
        _putView.giftBlock = ^{
            strongSelf(self);
            self.giftView.hidden = NO;
        };
    }
    return _putView;
}

- (QYZYLiveDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QYZYLiveDetailViewModel alloc] init];
    }
    return _viewModel;
}

- (QYZYChatGiftView *)giftView {
    if (!_giftView) {
        NSArray *array = [NSBundle.mainBundle loadNibNamed:@"QYZYChatGiftView" owner:self options:nil];
        _giftView = array.firstObject;
        _giftView.hidden = YES;
        weakSelf(self);
        _giftView.clickBlock = ^(QYZYChatGiftModel * _Nonnull giftModel) {
            strongSelf(self);
            weakSelf(self);
            [self.viewModel requestSendGiftWithAnchorId:self.anchorId giftId:giftModel.giftId chatId:self.chatId completion:^(NSString * msg) {
                strongSelf(self);
                if (!msg) {
                    QYZYUserManager.shareInstance.userModel.balance -= giftModel.price;
                    [self.giftView updateBalance];
                    //[self requestBalanceData];
                    [self.view qyzy_showMsg:@"已送礼"];
                } else {
                    [self.view qyzy_showMsg:msg];
                }
            }];
        };
        _giftView.chargeBlock = ^() {
            strongSelf(self);
            [self.navigationController pushViewController:QYZYChargeViewController.new animated:true];
        };
    }
    return _giftView;
}

- (NSMutableArray *)rcUidArray {
    if (!_rcUidArray) {
        _rcUidArray = [NSMutableArray array];
    }
    return _rcUidArray;
}

@end
