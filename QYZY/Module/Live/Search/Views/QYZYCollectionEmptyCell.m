//
//  QYZYCollectionEmptyCell.m
//  QYZY
//
//  Created by jspollo on 2022/10/4.
//

#import "QYZYCollectionEmptyCell.h"
@interface QYZYCollectionEmptyCell ()

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *titleLab;

@end
@implementation QYZYCollectionEmptyCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.iconImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImgView];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).offset(-30);
        make.width.mas_offset(210);
        make.height.mas_offset(154);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    self.titleLab.textColor = rgb(97, 112, 152);
    [self.contentView addSubview:self.titleLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImgView);
        make.top.equalTo(self.iconImgView.mas_bottom).offset(16);
    }];
    
    self.backgroundColor = UIColor.clearColor;
    
    self.iconImgView.image = [UIImage imageNamed:@"empty_noData"];
    self.titleLab.text = @"暂无数据~";
}

- (void)updateWithTop:(CGFloat)top {
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(100);
        make.width.mas_offset(210);
        make.height.mas_offset(154);
        make.centerX.equalTo(self.contentView);
    }];
}





@end
