//
//  QYZYPlayerDataHeader.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYPlayerDataHeader.h"

@interface QYZYPlayerDataHeader ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *categoryTitleLab;

@end

@implementation QYZYPlayerDataHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
        self.contentView .backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupSubViews {
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.categoryTitleLab];

    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(6);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.categoryTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(4);
        make.centerY.equalTo(self.imgView);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = rgba(182, 188, 203, 0.2);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - getter
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UILabel *)categoryTitleLab {
    if (!_categoryTitleLab) {
        _categoryTitleLab = [[UILabel alloc] init];
        _categoryTitleLab.text = @" ";
        _categoryTitleLab.textColor = rgb(51, 51, 51);
        _categoryTitleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _categoryTitleLab;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.categoryTitleLab.text = title;
}

- (void)setImg:(NSString *)img {
    _img = img;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@""]];
}

@end
