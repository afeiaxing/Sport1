//
//  QYZYSearchCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/9/30.
//

#import "QYZYSearchCell.h"

@interface QYZYSearchCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, strong) NSMutableArray *buttonsArray;

@end

@implementation QYZYSearchCell

#pragma mark - lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _titleLabel.text = @"";
    }
    return _titleLabel;
}

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearBtn.layer.borderWidth = 1;
        _clearBtn.layer.borderColor = rgb(41, 69, 192).CGColor;
        _clearBtn.layer.cornerRadius = 11;
        [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        [_clearBtn setTitleColor:rgb(41, 69, 192) forState:UIControlStateNormal];
        _clearBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        [_clearBtn addTarget:self action:@selector(clearClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (NSMutableArray *)buttonsArray {
    if (!_buttonsArray) {
        _buttonsArray = [[NSMutableArray alloc] init];
    }
    return _buttonsArray;
}

#pragma mark - setter
- (void)setType:(SearchType)type {
    _type = type;
    if (type == SearchHistoryType) {
        self.titleLabel.text = @"搜索历史";
        self.clearBtn.hidden = NO;
    }else {
        self.titleLabel.text = @"猜你想搜";
        self.clearBtn.hidden = YES;
    }
    
    [self.buttonsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj;
        [button removeFromSuperview];
    }];
    
    __block CGFloat y = 40.f + 12.f;
    __block CGFloat x = 12.f;
    [self.searchKeys enumerateObjectsUsingBlock:^(NSString *searchKey, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize size = [searchKey sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:10]}];
        if (x + size.width + 12 >= SCREEN_WIDTH-12) {
            x = 12.f;
            y += 40.f;
        }

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, size.width + 20.f, 30.f);
        button.backgroundColor = self.type==SearchHistoryType?rgba(97, 112, 152, 0.11):UIColor.whiteColor;
        button.layer.borderWidth = 1;
        button.layer.borderColor =  self.type==SearchHistoryType?UIColor.clearColor.CGColor:rgba(196, 220, 255, 1).CGColor;
        button.layer.cornerRadius = 15.0;
        [button setTitle:searchKey forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [button setTitleColor:rgb(109, 118, 160) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10000 + idx;
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(y);
            make.left.mas_equalTo(x);
            make.width.mas_equalTo(size.width+20.f);
            make.height.mas_equalTo(30);
            if (idx == self.searchKeys.count-1) {
                make.bottom.equalTo(self.contentView).offset(-12);
            };
        }];
        [self.buttonsArray addObject:button];

        x = CGRectGetMaxX(button.frame) + 12.f;
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:nil];
    if (self) {
        [self configCell];
    }
    return self;
}

- (void)configCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(12);
    }];
    
    [self.contentView addSubview:self.clearBtn];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(53);
        make.height.mas_offset(22);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-12);
    }];
}

- (void)buttonClick:(UIButton *)sender {
    NSInteger index = sender.tag - 10000;
    !self.searchKeyBlock?:self.searchKeyBlock(self.searchKeys[index]);
}

- (void)clearClick:(UIButton *)sender {
    !self.clearClickBlock?:self.clearClickBlock();
}

@end
