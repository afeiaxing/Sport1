//
//  QYZYTeamStaticShowupModel.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYTeamStaticShowupModel.h"

@implementation QYZYTeamStaticShowupModel

+ (QYZYTeamStaticShowupModel *)configWithHostTeamValue:(NSString *)hostTeamValue
                                                 guestTeamValue:(NSString *)guestTeamValue
                                                  itemNameValue:(NSString *)itemNameValue {
    QYZYTeamStaticShowupModel *tmpViewModel = [[QYZYTeamStaticShowupModel alloc] init];
    tmpViewModel.itemNameValue = itemNameValue;
    tmpViewModel.hostTeamValue = [QYZYTeamStaticShowupModel showMatchNumWithMatchNumString:hostTeamValue];
    tmpViewModel.guestTeamValue = [QYZYTeamStaticShowupModel showMatchNumWithMatchNumString:guestTeamValue];
    NSInteger shootOnGoalTotalCount = tmpViewModel.hostTeamValue.integerValue + tmpViewModel.guestTeamValue.integerValue;
    tmpViewModel.hostTeamValueRate =  [QYZYTeamStaticShowupModel rateWithDivisorCount:tmpViewModel.hostTeamValue.integerValue totalCount:shootOnGoalTotalCount];
    tmpViewModel.guestTeamValueRate =  [QYZYTeamStaticShowupModel rateWithDivisorCount:tmpViewModel.guestTeamValue.integerValue totalCount:shootOnGoalTotalCount];
    return tmpViewModel;
}

+ (NSString *)showMatchNumWithMatchNumString:(NSString *)numString {
    if (!numString.length) {
        numString = @"0";
    }
    return numString;
}

+ (CGFloat)rateWithDivisorCount:(NSUInteger)divisorCount totalCount:(NSUInteger)totalCount {
    if (totalCount <= 0) {
        return 0;
    }
    return divisorCount / (totalCount * 1.0);
}



@end
