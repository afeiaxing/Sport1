//
//  GeneralMacroHeader.h
//  Test
//
//  Created by 樊盛 on 2019/5/7.
//  Copyright © 2019年 樊盛. All rights reserved.
//

#ifndef CalendarMacroHeader_h
#define CalendarMacroHeader_h

#define kScreenWidth   [[UIScreen mainScreen]bounds].size.width
#define kScreenHeight  [[UIScreen mainScreen]bounds].size.height

// 日历头的高度
#define kCalendarHeaderViewHeight 135
// 日历自定义view高度
#define kCalendarCustomViewHeight 80

// 日历头 文字的颜色
#define Color_Text_CalendarHeaderView_Label [UIColor colorWithRed:(153)/255.0f green:(153)/255.0f blue:(153)/255.0f alpha:1]
// 上月||下月 文字的颜色
#define Color_Text_PreviousOrNextMonth [UIColor clearColor]
// 不可点击按钮的颜色
#define Color_Text_itemDisable [UIColor colorWithRed:(217)/255.0f green:(217)/255.0f blue:(217)/255.0f alpha:1]
// 当前月 选中的日期 文字的颜色
#define Color_Text_CurrentMonth_Selected [UIColor colorWithRed:(227)/255.0f green:(172)/255.0f blue:(114)/255.0f alpha:1]
// 当前月 未选中日期 文字的颜色
#define Color_Text_CurrentMonth_UnSelected [UIColor colorWithRed:(149)/255.0f green:(157)/255.0f blue:(176)/255.0f alpha:1]

// 日历头背景色
#define Color_CalendarHeaderView_Bg [UIColor colorWithRed:(248)/255.0f green:(250)/255.0f blue:(255)/255.0f alpha:1]
// collectionView 的背景色
#define Color_collectionView_Bg [UIColor colorWithRed:(255)/255.0f green:(255)/255.0f blue:(255)/255.0f alpha:1]
// currentSelectView 当前日期的边框颜色
#define Color_currentSelectView_Border_CurrentDay [UIColor whiteColor]
// currentSelectView 选中时的背景色
#define Color_currentSelectView_Bg_Selected [UIColor colorWithRed:(255)/255.0f green:(243)/255.0f blue:(232)/255.0f alpha:1]

// 日历头 label的字体大小
#define Font_CalendarHeaderLabel [UIFont systemFontOfSize:14]
// 阳历label的字体大小
#define Font_solarDateLabel [UIFont systemFontOfSize:13]
// 农历label的字体大小
#define Font_lunarDateLabel [UIFont systemFontOfSize:13]



#endif /* CalendarMacroHeader_h */
