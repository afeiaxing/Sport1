//
//  QYZYTotalNewsUtil.m
//  QYZY
//
//  Created by jsgordong on 2022/10/2.
//

#import "QYZYTotalNewsUtil.h"
#import "QYZYTotalNewsLabelModel.h"

@implementation QYZYTotalNewsUtil

+ (NSArray *)loadTotalNewsLabelDataSource {
    NSMutableArray *muarr = [NSMutableArray array];
    
    QYZYTotalNewsLabelModel *model0 = [[QYZYTotalNewsLabelModel alloc] init];
    model0.categoryId = @"2";
    model0.ID = @"3";
    model0.jumpUrl = @"";
    model0.mediaType = -1;
    model0.name = @"英超";
    model0.sportType = @"";
    [muarr addObject:model0];
    
    QYZYTotalNewsLabelModel *model2 = [[QYZYTotalNewsLabelModel alloc] init];
    model2.categoryId = @"10007";
    model2.ID = @"17";
    model2.jumpUrl = @"";
    model2.mediaType = -1;
    model2.name = @"NBA";
    model2.sportType = @"";
    [muarr addObject:model2];
    
    QYZYTotalNewsLabelModel *model9 = [[QYZYTotalNewsLabelModel alloc] init];
    model9.categoryId = @"6";
    model9.ID = @"28";
    model9.jumpUrl = @"";
    model9.mediaType = -1;
    model9.name = @"电竞";
    model9.sportType = @"";
    [muarr addObject:model9];
    
    QYZYTotalNewsLabelModel *model1 = [[QYZYTotalNewsLabelModel alloc] init];
    model1.categoryId = @"3";
    model1.ID = @"5";
    model1.jumpUrl = @"";
    model1.mediaType = -1;
    model1.name = @"西甲";
    model1.sportType = @"";
    [muarr addObject:model1];
    
    QYZYTotalNewsLabelModel *model10 = [[QYZYTotalNewsLabelModel alloc] init];
    model10.categoryId = @"10002";
    model10.ID = @"4";
    model10.jumpUrl = @"";
    model10.mediaType = -1;
    model10.name = @"意甲";
    model10.sportType = @"";
    [muarr addObject:model10];
    
    QYZYTotalNewsLabelModel *model3 = [[QYZYTotalNewsLabelModel alloc] init];
    model3.categoryId = @"5";
    model3.ID = @"7";
    model3.jumpUrl = @"";
    model3.mediaType = -1;
    model3.name = @"法甲";
    model3.sportType = @"";
    [muarr addObject:model3];
    
    QYZYTotalNewsLabelModel *model11 = [[QYZYTotalNewsLabelModel alloc] init];
    model11.categoryId = @"10003";
    model11.ID = @"24";
    model11.jumpUrl = @"";
    model11.mediaType = -1;
    model11.name = @"德甲";
    model11.sportType = @"";
    [muarr addObject:model11];
    
    QYZYTotalNewsLabelModel *model4 = [[QYZYTotalNewsLabelModel alloc] init];
    model4.categoryId = @"10001";
    model4.ID = @"26";
    model4.jumpUrl = @"";
    model4.mediaType = -1;
    model4.name = @"中超";
    model4.sportType = @"";
    [muarr addObject:model3];
    
    QYZYTotalNewsLabelModel *model5 = [[QYZYTotalNewsLabelModel alloc] init];
    model5.categoryId = @"10009";
    model5.ID = @"27";
    model5.jumpUrl = @"";
    model5.mediaType = -1;
    model5.name = @"世界杯";
    model5.sportType = @"";
    [muarr addObject:model5];
    
    QYZYTotalNewsLabelModel *model6 = [[QYZYTotalNewsLabelModel alloc] init];
    model6.categoryId = @"8";
    model6.ID = @"23";
    model6.jumpUrl = @"";
    model6.mediaType = -1;
    model6.name = @"CBA";
    model6.sportType = @"";
    [muarr addObject:model6];    
    
    QYZYTotalNewsLabelModel *model8 = [[QYZYTotalNewsLabelModel alloc] init];
    model8.categoryId = @"10004";
    model8.ID = @"21";
    model8.jumpUrl = @"";
    model8.mediaType = -1;
    model8.name = @"欧冠";
    model8.sportType = @"";
    [muarr addObject:model8];
    
    return muarr;
}

@end
