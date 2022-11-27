//
//  QYZYLiveCell.m
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import "QYZYLiveCell.h"
#import "QYZYLiveItemView.h"
#import <Masonry.h>

@interface QYZYLiveCell ()

@property (nonatomic ,strong) QYZYLiveItemView *itemView;

@end

@implementation QYZYLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.itemView];
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    self.itemView.layer.cornerRadius = 4;
    self.itemView.layer.masksToBounds = YES;
}

- (void)setListModel:(QYZYLiveListModel *)listModel {
    _listModel = listModel;
    self.itemView.listModel = listModel;
}

- (QYZYLiveItemView *)itemView {
    if (!_itemView) {
        NSArray *nibViews = [NSBundle.mainBundle loadNibNamed:@"QYZYLiveItemView" owner:self options:nil];
        _itemView = nibViews.firstObject;
    }
    return _itemView;
}

@end
