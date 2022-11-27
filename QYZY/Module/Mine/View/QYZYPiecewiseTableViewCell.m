//
//  QYZYPiecewiseTableViewCell.m
//  QYZY
//
//  Created by jspatches on 2022/10/3.
//

#import "QYZYPiecewiseTableViewCell.h"

@implementation QYZYPiecewiseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addConstraintsAndActions];
    }
    return self;
}

- (void)addConstraintsAndActions
{
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    
    [self addSubview:self.lineView2];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-1);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    [self.contentView addSubview:self.postButton];
    [self.postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.top.equalTo(self.lineView.mas_bottom).mas_offset(13);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(22);
    }];
    
    [self.contentView addSubview:self.articleButton];
    [self.articleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.postButton.mas_right).mas_equalTo(36);
        make.top.equalTo(self.lineView.mas_bottom).mas_offset(13);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(22);
    }];
    
    
    [self.contentView addSubview:self.boomLineView];
    
}

//每次cell 刷新时
- (void)ispost:(BOOL)post
{
    if (post == YES) {
        [self.postButton setTitleColor:rgb(41, 69, 192) forState:UIControlStateNormal];
        [self.articleButton setTitleColor:rgb(34, 34, 34) forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            [self.boomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.postButton.mas_centerX).mas_equalTo(0);
                make.top.equalTo(self.postButton.mas_bottom).mas_equalTo(7);
                make.width.mas_equalTo(15);
                make.height.mas_equalTo(3);
            }];

        }];
    }
    else
    {
        [self.postButton setTitleColor:rgb(34, 34, 34) forState:UIControlStateNormal];
        [self.articleButton setTitleColor:rgb(41, 69, 192) forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            [self.boomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.articleButton.mas_centerX).mas_equalTo(0);
                make.top.equalTo(self.articleButton.mas_bottom).mas_equalTo(7);
                make.width.mas_equalTo(15);
                make.height.mas_equalTo(3);
            }];

        }];
    }
}



- (void)Ckick:(UIButton *)button
{
    if (button == self.postButton) {
        [self.postButton setTitleColor:rgb(41, 69, 192) forState:UIControlStateNormal];
        [self.articleButton setTitleColor:rgb(34, 34, 34) forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.boomLineView.frame = CGRectMake(self.postButton.frame.origin.x+8, self.postButton.frame.size.height + 28, 15, 3);
        }];
    }
    else
    {
        [self.postButton setTitleColor:rgb(34, 34, 34) forState:UIControlStateNormal];
        [self.articleButton setTitleColor:rgb(41, 69, 192) forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.boomLineView.frame = CGRectMake(self.articleButton.frame.origin.x+8, self.articleButton.frame.size.height + 28, 15, 3);
        }];
        
    }
    
    if (self.buttonBlock) {
        self.buttonBlock(button);
    }
    
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = rgb(247, 248, 254);
    }
    return _lineView;
}

- (UIView *)lineView2
{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc]init];
        _lineView2.backgroundColor = rgb(229, 229, 234);
    }
    return _lineView2;
}


- (UIButton *)postButton
{
    if (!_postButton) {
        _postButton = [[UIButton alloc]init];
        [_postButton setTitle:@"帖子" forState:UIControlStateNormal];
        _postButton.selected = YES;
        [_postButton setTitleColor:rgb(41, 69, 192) forState:UIControlStateNormal];
        _postButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        [_postButton addTarget:self action:@selector(Ckick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postButton;
}

- (UIButton *)articleButton
{
    if (!_articleButton) {
        _articleButton = [[UIButton alloc]init];
        [_articleButton setTitle:@"文章" forState:UIControlStateNormal];
        [_articleButton setTitleColor:rgb(34, 34, 34) forState:UIControlStateNormal];
        _articleButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        [_articleButton addTarget:self action:@selector(Ckick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _articleButton;
}


- (UIView *)boomLineView
{
    if (!_boomLineView) {
        _boomLineView = [[UIView alloc]init];
        _boomLineView.backgroundColor = rgb(41, 69, 192);
        _boomLineView.layer.masksToBounds = YES;
        _boomLineView.layer.cornerRadius = 3.0;
    }
    
    return _boomLineView;
}
@end
