//
//  QYZYCircleCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCircleCell.h"

@interface QYZYCircleCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UIView *mediaView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mediaHeight;

@property (nonatomic, strong) UIView *mutiplePicsView;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *commendBtn;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (nonatomic, strong) NSMutableArray *imgViews;

@end

@implementation QYZYCircleCell

- (UIView *)mutiplePicsView {
    if (!_mutiplePicsView) {
        _mutiplePicsView = [[UIView alloc] init];
        _mutiplePicsView.layer.cornerRadius = 5;
        _mutiplePicsView.layer.masksToBounds = YES;
    }
    return _mutiplePicsView;
}

- (NSMutableArray *)imgViews {
    if (!_imgViews) {
        _imgViews = [[NSMutableArray alloc] init];
    }
    return _imgViews;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    self.subTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    self.contentLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    [self.mediaView addSubview:self.mutiplePicsView];
    [self.mutiplePicsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mediaView);
    }];
    
    self.shareBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.commendBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.commendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.commendBtn.userInteractionEnabled = NO;
    
    self.likeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.likeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)];
    [self.headImgView addGestureRecognizer:avatarTap];
    
    [self layoutIfNeeded];
}

- (void)setModel:(QYZYCircleContentModel *)model {
    _model = model;
    self.nameLabel.text = model.nickname;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    self.subTitleLabel.text = model.createdDate;
    self.contentLab.text = [model.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.commendBtn setTitle:model.sonNum forState:UIControlStateNormal];
    [self.shareBtn setTitle:model.sharesCount forState:UIControlStateNormal];
    [self.likeBtn setTitle:model.likeCount forState:UIControlStateNormal];
    
    if (model.isLike) {
        [self.likeBtn setImage:[UIImage imageNamed:@"utils_like_select"] forState:UIControlStateNormal];
    }else {
        [self.likeBtn setImage:[UIImage imageNamed:@"utils_like_normal"] forState:UIControlStateNormal];
    }

    [self removeSubViews];
    
    if (model.postImgLists) {
        if (model.postImgLists.count == 1) {
            self.mediaHeight.constant = 140;
            self.mutiplePicsView.hidden = NO;
            
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.tag = 9000;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.layer.masksToBounds = YES;
            [imgView sd_setImageWithURL:[NSURL URLWithString:model.postImgLists.firstObject] placeholderImage:QYZY_DEFAULT_LOGO];
            [self.mutiplePicsView addSubview:imgView];
            
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.mutiplePicsView);
            }];
        }else if (model.postImgLists.count > 1) {

            CGFloat imgWidth = (ScreenWidth - 54 - 12 - 5*4)/3.0;
            __block CGFloat height = 0;
            [model.postImgLists enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (self.imgViews.count > idx) {
                    UIImageView *imgView = self.imgViews[idx];
                    imgView.hidden = NO;
                    [imgView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:QYZY_DEFAULT_LOGO];
                }else {
                    UIImageView *imgView = [[UIImageView alloc] init];
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    imgView.layer.masksToBounds = YES;
                    imgView.tag = 8000 + idx;
                    imgView.layer.cornerRadius = 5;
                    [imgView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:QYZY_DEFAULT_LOGO];
                    [self.mutiplePicsView addSubview:imgView];

                    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.height.mas_offset(imgWidth);
                        make.left.equalTo(self.mutiplePicsView).offset(idx%3*(5 + imgWidth));
                        make.top.equalTo(self.mutiplePicsView).offset(idx/3*(5 + imgWidth));
                    }];
                    
                    [self.imgViews addObject:imgView];
                }

                
                if (idx == model.postImgLists.count - 1) {
                    height = idx/3*(5 + imgWidth) + imgWidth;
                }
            }];

            self.mediaHeight.constant = height;
            self.mutiplePicsView.hidden = NO;
            
        }else {
            self.mediaHeight.constant = 1;
            self.mutiplePicsView.hidden = YES;
        }
    }else {
        self.mediaHeight.constant = 1;
        self.mutiplePicsView.hidden = YES;
    }
}

- (void)removeSubViews {
    UIImageView *imgView = [self.mutiplePicsView viewWithTag:9000];
    [imgView removeFromSuperview];
    
    self.mediaHeight.constant = 1;
    
    [self.imgViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgView = obj;
        imgView.hidden = YES;
    }];
}


- (void)avatarTap:(UITapGestureRecognizer *)tap {
    !self.avatarTapBlock?:self.avatarTapBlock(self.model.userId);
}

- (void)shareAction:(UIButton *)sender {
    !self.shareTapBlock?:self.shareTapBlock(self.model);
}

- (void)likeClick:(UIButton *)sender {
//    self.model.isLike = !self.model.isLike;
    !self.likeTapBlock?:self.likeTapBlock(self.model);
}


@end
