//
//  QYZYHotHeadView.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYHotHeadView.h"

@interface QYZYHotHeadView ()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIScrollView *scorllView;

@end

@implementation QYZYHotHeadView

#pragma mark - lazy load
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = [UIImage imageNamed:@"circle_header_bg"];
    }
    return _bgImgView;
}

- (UIScrollView *)scorllView {
    if (!_scorllView) {
        _scorllView = [[UIScrollView alloc] init];
        _scorllView.contentSize = CGSizeMake(0, 96);
        _scorllView.showsHorizontalScrollIndicator = NO;
    }
    return _scorllView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self configCell];
    }
    return self;
}

- (void)configCell {
    [self addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self).offset(-12);
        make.left.equalTo(self).offset(12);
        make.height.mas_offset(96);
        make.top.equalTo(self).offset(12);
    }];
    
    [self addSubview:self.scorllView];
    [self.scorllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgImgView);
    }];
}

- (void)setDatas:(NSMutableArray *)datas {
    _datas = datas;
    
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        QYZYCircleListModel *model = obj;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor = rgb(196, 220, 255);
        [imgView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:QYZY_DEFAULT_LOGO];
        imgView.layer.borderWidth = 2;
        imgView.layer.borderColor = UIColor.whiteColor.CGColor;
        imgView.layer.cornerRadius = 20;
        imgView.userInteractionEnabled = YES;
        imgView.tag = 10000 + idx;
        [self.scorllView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_offset(40);
            make.top.equalTo(self.scorllView).offset(14);
            make.left.equalTo(self.scorllView).offset(19+idx*(28+40));
        }];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = model.circleName;
        titleLab.userInteractionEnabled = YES;
        titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        titleLab.textColor = UIColor.whiteColor;
        [self.scorllView addSubview:titleLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imgView);
            make.top.equalTo(imgView.mas_bottom).offset(11);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagView:)];
        [imgView addGestureRecognizer:tap];
        
        if (idx == datas.count - 1) {
            self.scorllView.contentSize = CGSizeMake(19+idx*(28+40) + 40 + 19, 96);
        }
    }];
}

- (void)tagView:(UITapGestureRecognizer *)tap {
    NSInteger idx = tap.view.tag - 10000;
    if (self.datas.count > idx) {
        QYZYCircleListModel *model = self.datas[idx];
        !self.tapCircleBlock?:self.tapCircleBlock(model);
    }
}

@end
