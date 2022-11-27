//
//  QYZYMatchOverHelpCell.h
//  QYZY
//
//  Created by jsgordong on 2022/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchOverHelpCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconIv;
@property (nonatomic, strong) NSDictionary *dict;
@end

NS_ASSUME_NONNULL_END
