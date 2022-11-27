//
//  QYZYTableEmptyCell.m
//  QYZY
//
//  Created by jspollo on 2022/10/4.
//

#import "QYZYTableEmptyCell.h"

@interface QYZYTableEmptyCell ()

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation QYZYTableEmptyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconImgView = [[UIImageView alloc] init];
        self.iconImgView.contentMode = UIViewContentModeScaleAspectFit;
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
            make.top.equalTo(self.iconImgView.mas_bottom).offset(8);
        }];
        
        self.backgroundColor = UIColor.clearColor;
        self.iconImgView.image = [UIImage imageNamed:@"empty_noData"];
        self.titleLab.text = @"暂无数据~";
    }
    return self;
}

@end
