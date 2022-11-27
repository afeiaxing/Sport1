//
//  QYZYPlayerContentCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/25.
//

#import "QYZYPlayerContentCell.h"

@interface QYZYPlayerContentCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation QYZYPlayerContentCell

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

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _label.textColor = rgb(51, 51, 51);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (indexPath.row == 0) {
        self.label.text = self.title;
        self.label.textColor = rgb(149, 157, 176);
    }else {
        self.label.textColor = rgb(51, 51, 51);
        self.label.text = self.content;
    }
}

@end
