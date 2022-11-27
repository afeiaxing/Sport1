//
//  QYZYPlayerDataHeaderCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/25.
//

#import "QYZYPlayerDataHeaderCell.h"

@interface QYZYPlayerDataHeaderCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation QYZYPlayerDataHeaderCell

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

- (void)setModel:(QYZYPlayerInfoModel *)model {
    _model = model;
    self.label.text = [NSString stringWithFormat:@"    %@  %@",model.shirtNumber,model.name];
}

#pragma mark - getter
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"";
        _label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _label.textColor = rgb(34, 34, 34);
    }
    return _label;
}

@end
