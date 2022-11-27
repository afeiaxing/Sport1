//
//  QYZYCommendListCell.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import <UIKit/UIKit.h>
#import "QYZYCircleCommendModel.h"
#import "QYZYNewsCommentModel.h"
#import "QYZYNewsCommentSubParentModel.h"
#import "QYZYNewsCommentSubSonCommentsModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface QYZYCommendListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (weak, nonatomic) IBOutlet UILabel *likeLab;

@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (nonatomic, strong) QYZYCircleCommendModel *model;

@property (nonatomic, strong) QYZYNewsCommentModel *newsCommentModel;

@property (nonatomic, strong) QYZYNewsCommentSubParentModel *parentModel;

@property (nonatomic, strong) QYZYNewsCommentSubSonCommentsModel *sonCommentsModel;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *replyLab;

@property (weak, nonatomic) IBOutlet UILabel *atLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *atContentHeight;

@property (nonatomic, assign) BOOL needAtReply;

@end

NS_ASSUME_NONNULL_END
