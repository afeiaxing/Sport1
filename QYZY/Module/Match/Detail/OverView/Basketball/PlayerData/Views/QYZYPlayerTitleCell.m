//
//  QYZYPlayerTitleCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/25.
//

#import "QYZYPlayerTitleCell.h"

@interface QYZYPlayerTitleCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation QYZYPlayerTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - getter
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"    #  球员";
        _label.textColor = rgb(149, 157, 176);
        _label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    }
    return _label;
}

@end
