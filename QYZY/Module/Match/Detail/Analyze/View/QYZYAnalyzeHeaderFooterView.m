//
//  QYZYAnalyzeHeaderFooterView.m
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import "QYZYAnalyzeHeaderFooterView.h"

@implementation QYZYAnalyzeHeaderFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.matchBtn.layer.cornerRadius = 2;
    self.matchBtn.layer.masksToBounds = YES;
    self.homeAwayBtn.layer.cornerRadius = 2;
    self.homeAwayBtn.layer.masksToBounds = YES;
    [self.matchBtn setTitleColor:rgb(255, 255, 255) forState:UIControlStateSelected];
    [self.matchBtn setTitleColor:rgb(149, 157, 176) forState:UIControlStateNormal];
    [self.homeAwayBtn setTitleColor:rgb(255, 255, 255) forState:UIControlStateSelected];
    [self.homeAwayBtn setTitleColor:rgb(149, 157, 176) forState:UIControlStateNormal];
}

- (void)setModel:(QYZYAnalyzeSectionModel *)model {
    if (model == nil) return;
    _model = model;
    self.matchBtn.selected = model.isMatchBtnSelect;
    self.homeAwayBtn.selected = model.isHomeAwayBtnSelect;
    self.matchBtn.hidden = model.isMatchBtnHidden;
    self.homeAwayBtn.hidden = model.isHomeAwayBtnHidden;
    [self.matchBtn setBackgroundColor:model.isMatchBtnSelect ? rgb(41, 69, 192) : rgb(246, 247, 249)];
    [self.homeAwayBtn setBackgroundColor:model.isHomeAwayBtnSelect ? rgb(41, 69, 192) : rgb(246, 247, 249)];
}

- (IBAction)matchAction:(id)sender {
    !self.matchBlock ?: self.matchBlock(sender);
}

- (IBAction)hostGuessAction:(id)sender {
    !self.matchBlock ?: self.hostGuessBlock(sender);
}


@end
