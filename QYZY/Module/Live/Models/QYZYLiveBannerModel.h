//
//  QYZYLiveBannerModel.h
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveBannerModel : NSObject
@property (nonatomic ,strong) NSString *bannerId;
@property (nonatomic ,strong) NSString *relateType;//8直播间，6图文/视频
@property (nonatomic ,strong) NSString *mediaType;
@property (nonatomic ,strong) NSString *img;
@property (nonatomic ,strong) NSString *link;
@property (nonatomic ,strong) NSString *title;
@end

NS_ASSUME_NONNULL_END
