//
//  QYZYBasketballOverViewCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYBasketballOverViewCell.h"

@interface QYZYBasketballOverViewCell ()

@property (nonatomic, strong) QYZYBasketballScoreView *scoreView;

@end

@implementation QYZYBasketballOverViewCell

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
        self.contentView.backgroundColor = UIColor.redColor;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.scoreView];
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (QYZYBasketballScoreView *)scoreView {
    if (!_scoreView) {
        _scoreView = [[QYZYBasketballScoreView alloc] init];
        _scoreView.backgroundColor = UIColor.whiteColor;
        _scoreView.detailModel = self.detailModel;
    }
    return _scoreView;
}

- (void)setPeriodModel:(QYZYPeriodModel *)periodModel {
    _periodModel = periodModel;
    self.scoreView.periodModel = periodModel;
    self.scoreView.detailModel = self.detailModel;
}


@end
