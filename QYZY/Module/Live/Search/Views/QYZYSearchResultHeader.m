//
//  QYZYSearchResultHeader.m
//  QYZY
//
//  Created by jsmatthew on 2022/9/30.
//

#import "QYZYSearchResultHeader.h"

@interface QYZYSearchResultHeader ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation QYZYSearchResultHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self configCell];
    }
    return self;
}

- (void)configCell {
    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    self.label.textColor = rgb(34, 34, 34);
    [self.contentView addSubview:self.label];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-5);
        make.left.equalTo(self.contentView).offset(12);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.label.text = title;
}

@end
