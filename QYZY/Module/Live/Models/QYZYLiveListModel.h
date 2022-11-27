//
//  QYZYLiveListModel.h
//  QYZY
//
//  Created by jspollo on 2022/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveListModel : NSObject
//@property (nonatomic ,strong) NSString *liveHeadImage;
@property (nonatomic ,strong) NSString *liveImage;
@property (nonatomic ,strong) NSString *nickname;
@property (nonatomic ,strong) NSString *liveTitle;
@property (nonatomic ,strong) NSString *matchId;
@property (nonatomic ,strong) NSString *userId;
@property (nonatomic ,strong) NSString *anchorId;
@property (nonatomic ,strong) NSString *anchorHot;
@end

NS_ASSUME_NONNULL_END
