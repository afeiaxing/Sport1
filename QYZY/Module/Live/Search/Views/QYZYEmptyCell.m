//
//  QYZYEmptyCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/3.
//

#import "QYZYEmptyCell.h"

@interface QYZYEmptyCell ()

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation QYZYEmptyCell

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
        [self.contentView addSubview:self.iconImgView];
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(120);
            make.width.mas_offset(206);
            make.height.mas_offset(151);
            make.bottom.equalTo(self.contentView).offset(-25);
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
        
    }
    return self;
}

- (void)setType:(EmptyType)type {
    _type = type;
    if (type == EmptyTypeNoData) {
        self.iconImgView.image = [UIImage imageNamed:@"empty_noData"];
        self.titleLab.text = @"暂无数据~";
    }else {
        self.iconImgView.image = [UIImage imageNamed:@"empty_noResult"];
        self.titleLab.text = @"结果空空如也~";
    }
}


@end
