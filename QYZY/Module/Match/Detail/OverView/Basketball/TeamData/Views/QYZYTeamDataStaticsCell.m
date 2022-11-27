//
//  QYZYTeamDataStaticsCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYTeamDataStaticsCell.h"

@interface QYZYTeamDataStaticsCell ()

@property (nonatomic, strong) UILabel *centerLab;

@property (nonatomic, strong) UILabel *leftInfoLab;

@property (nonatomic, strong) UILabel *rightInfoLab;

@property (nonatomic, strong) UIView *barBgView;

@property (nonatomic, strong) UIImageView *leftImgView;

@property (nonatomic, strong) UIImageView *rightImgView;

@property (nonatomic, strong) UIView *leftShapeView;

@property (nonatomic, strong) UIView *rightShapeView;

@property (nonatomic, strong) CAShapeLayer *rightShapeLayer;

@property (nonatomic, strong) CAShapeLayer *leftShapeLayer;

@property (nonatomic,assign) CGFloat rightSideWidth;

@property (nonatomic, copy) NSString *markLeftInfo;

@property (nonatomic, copy) NSString *markRightInfo;


@end

@implementation QYZYTeamDataStaticsCell

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
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.centerLab];
    [self.contentView addSubview:self.barBgView];
    [self.contentView addSubview:self.leftInfoLab];
    [self.contentView addSubview:self.rightInfoLab];
    
    [self.contentView addSubview:self.leftShapeView];
    [self.contentView addSubview:self.rightShapeView];
    [self.contentView addSubview:self.leftImgView];
    [self.contentView addSubview:self.rightImgView];
    
    [self.centerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(8);
    }];
    
    [self.barBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerLab.mas_bottom).offset(0);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.mas_offset(4);
    }];
    
    [self.leftInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.barBgView);
        make.centerY.equalTo(self.centerLab);
    }];
    
    [self.rightInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.barBgView);
        make.centerY.equalTo(self.centerLab);
    }];
    
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX);
        make.height.equalTo(self.barBgView);
        make.width.mas_offset(0);
        make.centerY.equalTo(self.barBgView);
    }];
    
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX);
        make.height.equalTo(self.barBgView);
        make.width.mas_offset(0);
        make.centerY.equalTo(self.barBgView);
    }];
    
    [self.leftShapeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftImgView.mas_left);
        make.centerY.equalTo(self.leftImgView);
        make.size.mas_equalTo(CGSizeMake(4, 4));
    }];
    [self.rightShapeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImgView.mas_right);
        make.centerY.equalTo(self.rightImgView);
        make.size.mas_equalTo(CGSizeMake(4, 4));
    }];
}

- (void)updateLeftPercent:(CGFloat)leftPercent {
    CGFloat width = (SCREEN_WIDTH - 24)/2.0 *leftPercent;
    [self.leftImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(width);
    }];
    
//    self.leftImgView.backgroundColor = [UIColor my_gradientFromColor:rgb(<#r#>, <#g#>, <#b#>)(56, 127, 210)
//                                                             toColor:rgb(108, 171, 255) withWidth:width];
    self.leftImgView.backgroundColor = UIColor.redColor;
    self.leftShapeView.backgroundColor = rgb(246, 77, 77);
}

- (void)updateRightPercent:(CGFloat)RightPercent {
    
    CGFloat width = (SCREEN_WIDTH - 24)/2.0 *RightPercent;
    self.rightSideWidth = width;
    
    [self.rightImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(width);
    }];
    
//    self.rightImgView.backgroundColor = [UIColor my_gradientFromColor:rgb(251, 132, 132)
//                                                              toColor:rgb(246, 77, 77) withWidth:width];
    self.rightImgView.backgroundColor = UIColor.blueColor;
    self.rightShapeView.backgroundColor = rgb(56, 127, 210);
    
//    [self updateRightShaperLayer];
}

- (void)setModel:(QYZYTeamStaticShowupModel *)model {
    _model = model;
    self.centerLab.text = model.itemNameValue;
    
    /// 清空动作
    self.leftInfoLab.text = @"";
    self.rightInfoLab.text = @"";
    
    self.leftInfoLab.text = model.hostTeamValue;
    self.rightInfoLab.text = model.guestTeamValue;
    self.markLeftInfo = self.leftInfoLab.text;
    self.markRightInfo = self.rightInfoLab.text;
    
    CGFloat leftData =  [self.leftInfoLab.text floatValue];
    CGFloat rightData = [self.rightInfoLab.text floatValue];
    
    CGFloat total = leftData + rightData;
    
    CGFloat leftPercent = leftData/total;
    CGFloat rightPercent = rightData/total;
    
    if (self.leftInfoLab.text.length == 0 || self.leftInfoLab.text.floatValue == 0) {
        self.leftInfoLab.text = @"0";
        self.leftImgView.hidden = YES;
    }else {
        self.leftImgView.hidden = NO;
        [self updateLeftPercent:leftPercent];
    }
    
    if (self.rightInfoLab.text.length == 0 || self.rightInfoLab.text.floatValue == 0) {
        self.rightInfoLab.text = @"0";
        self.rightImgView.hidden = YES;
    }else {
        self.rightImgView.hidden = NO;
        [self updateRightPercent:rightPercent];
    }
}

#pragma mark - getter
- (UILabel *)centerLab {
    if (!_centerLab) {
        _centerLab = [[UILabel alloc] init];
        _centerLab.textColor = rgb(51, 51, 51);
        _centerLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _centerLab;
}

- (UIView *)barBgView {
    if (!_barBgView) {
        _barBgView = [[UIView alloc] init];
        _barBgView.backgroundColor = rgb(231, 240, 252);
    }
    return _barBgView;
}

- (UILabel *)leftInfoLab {
    if (!_leftInfoLab) {
        _leftInfoLab = [[UILabel alloc] init];
        _leftInfoLab.text = @"0";
        _leftInfoLab.textColor = rgb(51, 51, 51);
        _leftInfoLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _leftInfoLab;
}

- (UILabel *)rightInfoLab {
    if (!_rightInfoLab) {
        _rightInfoLab = [[UILabel alloc] init];
        _rightInfoLab.text = @"0";
        _rightInfoLab.textColor = rgb(149, 157, 176);
        _rightInfoLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _rightInfoLab;
}

- (UIImageView *)leftImgView {
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc] init];
        _leftImgView.backgroundColor = rgb(108, 171, 255);
    }
    return _leftImgView;
}

- (UIImageView *)rightImgView {
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.backgroundColor = rgb(251, 132, 132);
    }
    return _rightImgView;
}

- (UIView *)leftShapeView {
    if (!_leftShapeView) {
        _leftShapeView = [UIView new];
        _leftShapeView.layer.cornerRadius = 2.f;
    }
    return _leftShapeView;
}

- (UIView *)rightShapeView {
    if (!_rightShapeView) {
        _rightShapeView = [UIView new];
        _rightShapeView.layer.cornerRadius = 2.f;
    }
    return _rightShapeView;
}

- (CAShapeLayer *)leftShapeLayer {
    if (!_leftShapeLayer) {
        _leftShapeLayer = [CAShapeLayer layer];
        [_leftShapeLayer setFillColor:rgb(231, 240, 252).CGColor];
        [_leftShapeLayer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
        [_leftShapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
    }
    return _leftShapeLayer;
}

- (CAShapeLayer *)rightShapeLayer {
    if (!_rightShapeLayer) {
        _rightShapeLayer = [CAShapeLayer layer];
        [_rightShapeLayer setFillColor:rgb(231, 240, 252).CGColor];
        [_rightShapeLayer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
        [_rightShapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
    }
    return _rightShapeLayer;
}



@end
