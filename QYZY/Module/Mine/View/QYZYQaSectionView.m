//
//  QYZYQaSectionView.m
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import "QYZYQaSectionView.h"
#import "QYZYQaModel.h"

@interface QYZYQaSectionView()

@property (nonatomic, strong) UIButton *arrowBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation QYZYQaSectionView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];


    }
    return self;
}

#pragma mark - Public Methods
- (void)setModel:(QYZYQaModel *)model {
    if (model) {
        _model = model;
        [self.titleLabel setText:model.question];
        [self.arrowBtn setSelected:model.isOpen];
    }
}


#pragma mark - Private Methods
- (void)setupSubviews {
    
    [self addSubview:self.arrowBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
    
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self.mas_trailing);
        make.size.mas_equalTo(50);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(20);
        make.trailing.equalTo(self.arrowBtn.mas_leading).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAndCloseAction)];
    [self addGestureRecognizer:tapGR];
}

#pragma mark - Action Event
- (void)openAndCloseAction {
    BOOL isSelect = self.arrowBtn.isSelected;
    [self.arrowBtn setSelected:!isSelect];
    if ([self.delegate respondsToSelector:@selector(clickedSection:)]) {
        [self.delegate clickedSection:self];
    }
}

#pragma mark - Setter& Getter
- (UIButton *)arrowBtn {
    if (!_arrowBtn) {
        _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowBtn setImage:[UIImage imageNamed:@"xm_database_arrow_down"] forState:UIControlStateNormal];
        [_arrowBtn setImage:[UIImage imageNamed:@"xm_database_arrow_up"] forState:UIControlStateSelected];
        _arrowBtn.selected = NO;
        [_arrowBtn addTarget:self action:@selector(openAndCloseAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _arrowBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}



@end
