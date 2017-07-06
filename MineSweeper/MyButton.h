//
//  MyButton.h
//  MineSweeper
//
//  Created by 施翔日 on 2017/3/22.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton
@property (nonatomic) BOOL isClick;
@property (nonatomic) BOOL isBoom;
-(void) initButtonLayer;
-(void) initButtonInfo;
@end

