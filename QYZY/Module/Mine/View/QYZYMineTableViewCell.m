//
//  QYZYMineTableViewCell.m
//  QYZY
//
//  Created by jspatches on 2022/10/3.
//

#import "QYZYMineTableViewCell.h"
#import "QYZYButton.h"
#define Start_X          QYZY_SCALE(34.0f)   // 第一个按钮的X坐标
#define Start_Y          QYZY_HEIGHT_SCALE(16.0f)     // 第一个按钮的Y坐标
#define Width_Space      QYZY_SCALE(70.0f)     // 2个按钮之间的横间距
#define Height_Space    QYZY_HEIGHT_SCALE(40.0f)     // 竖间距
#define Button_Height   24.0f  // 高
#define Button_Width    24.0f    // 宽

@implementation QYZYMineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addConstraintsAndActions];
    }
    return self;
}

- (void)addConstraintsAndActions
{
    NSArray *imageArray = [NSArray arrayWithObjects:@"iconMeSc",@"iconMeYuey",@"iconMeKef",@"iconMeWenti", nil];
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"我的收藏",@"我的预约",@"常见问题", nil];
    

    for (int i = 0 ; i < titleArray.count; i++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        QYZYButton *mapBtn = [QYZYButton buttonWithType:UIButtonTypeRoundedRect];
        mapBtn.tag = i;
        [mapBtn setBackgroundImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [self.contentView addSubview:mapBtn];
        [mapBtn addTarget:self action:@selector(mapBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        mapBtn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        UILabel *label = [[UILabel alloc]init];
        label.text = titleArray[i];
        label.textColor = rgb(34, 34, 34);
        label.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:10];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(mapBtn.mas_centerX).mas_offset(0);
            make.top.equalTo(mapBtn.mas_bottom).mas_equalTo(6);
        }];
    }
    
}


-(void)mapBtnClick:(UIButton *)sender{
    
    if (self.actionBlock) {
        self.actionBlock(sender.tag);
    }
}





@end
