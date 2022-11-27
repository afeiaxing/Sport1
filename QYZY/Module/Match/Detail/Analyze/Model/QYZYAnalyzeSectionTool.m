//
//  QYZYAnalyzeSectionTool.m
//  QYZY
//
//  Created by jsgordong on 2022/10/25.
//

#import "QYZYAnalyzeSectionTool.h"

@implementation QYZYAnalyzeSectionTool

+ (NSMutableArray *)handleData {
    NSMutableArray *muarr = [NSMutableArray array];
    
    QYZYAnalyzeSectionModel *model0 = [[QYZYAnalyzeSectionModel alloc] init];
    model0.isMatchBtnSelect = NO;
    model0.isHomeAwayBtnSelect = NO;
    
    model0.isMatchBtnHidden = YES;
    model0.isHomeAwayBtnHidden = NO;
    [muarr addObject:model0];
    
    QYZYAnalyzeSectionModel *model1 = [[QYZYAnalyzeSectionModel alloc] init];
    model1.isMatchBtnSelect = NO;
    model1.isHomeAwayBtnSelect = NO;
    model1.isMatchBtnHidden = NO;
    model1.isHomeAwayBtnHidden = NO;
    [muarr addObject:model1];
    
    QYZYAnalyzeSectionModel *model2 = [[QYZYAnalyzeSectionModel alloc] init];
    model2.isMatchBtnSelect = NO;
    model2.isHomeAwayBtnSelect = NO;
    model2.isMatchBtnHidden = NO;
    model2.isHomeAwayBtnHidden = NO;
    [muarr addObject:model2];
    
    QYZYAnalyzeSectionModel *model3 = [[QYZYAnalyzeSectionModel alloc] init];
    model3.isMatchBtnSelect = NO;
    model3.isHomeAwayBtnSelect = NO;
    model3.isMatchBtnHidden = NO;
    model3.isHomeAwayBtnHidden = NO;
    [muarr addObject:model3];
    
    QYZYAnalyzeSectionModel *model4 = [[QYZYAnalyzeSectionModel alloc] init];
    model4.isMatchBtnSelect = NO;
    model4.isHomeAwayBtnSelect = NO;
    model4.isMatchBtnHidden = YES;
    model4.isHomeAwayBtnHidden = YES;
    [muarr addObject:model4];
    
    QYZYAnalyzeSectionModel *model5 = [[QYZYAnalyzeSectionModel alloc] init];
    model5.isMatchBtnSelect = NO;
    model5.isHomeAwayBtnSelect = NO;
    model5.isMatchBtnHidden = YES;
    model5.isHomeAwayBtnHidden = YES;
    [muarr addObject:model5];
    
    return muarr;
}

@end
