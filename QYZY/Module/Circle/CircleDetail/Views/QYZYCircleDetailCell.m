//
//  QYZYCircleDetailCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCircleDetailCell.h"

@interface QYZYCircleDetailCell ()

@property (nonatomic, strong) UIView *mutiplePicsView;

@property (nonatomic, strong) NSMutableArray *imgViews;

@end

@implementation QYZYCircleDetailCell

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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.followBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.contentLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    self.timeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    self.viewsView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.viewsView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    
    [self.mediaView addSubview:self.mutiplePicsView];
    [self.mutiplePicsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mediaView);
    }];
}

- (void)setModel:(QYZYCircleContentModel *)model {
    _model = model;
    self.titleLab.text = model.nickname;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    self.contentLab.text = model.content;
    self.timeLab.text = model.createdDate;
    [self.viewsView setTitle:model.pageViews forState:UIControlStateNormal];
    
    if (model.isAttention == false) {
        [self.followBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.followBtn.backgroundColor = rgb(41, 69, 192);
        self.followBtn.layer.borderWidth = 0;
        [self.followBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }else {
        [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.followBtn.backgroundColor = UIColor.whiteColor;
        self.followBtn.layer.borderWidth = 1;
        self.followBtn.layer.borderColor = rgb(149, 157, 176).CGColor;
        [self.followBtn setTitleColor:rgb(149, 157, 176) forState:UIControlStateNormal];
    }
    
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


- (IBAction)followAction:(id)sender {
    !self.followBlock?:self.followBlock(self.model);
}

@end
