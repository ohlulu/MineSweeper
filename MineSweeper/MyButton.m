//
//  MyButton.m
//  MineSweeper
//
//  Created by 施翔日 on 2017/3/22.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

-(void) initButtonInfo {
    self.isBoom = false;
    self.isClick = false;
    self.backgroundColor = [UIColor blackColor];
    [self setTitle:@"" forState:UIControlStateNormal];
    
}

-(void) initButtonLayer {
    [self initButtonInfo];
    
    self.layer.cornerRadius = 15;
    self.layer.shadowOffset=CGSizeMake(5, 5);
    self.layer.shadowOpacity = 0.2;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
