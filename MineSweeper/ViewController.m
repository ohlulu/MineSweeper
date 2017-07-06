//
//  ViewController.m
//  MineSweeper
//
//  Created by 施翔日 on 2017/3/22.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "ViewController.h"
#import "MyButton.h"

@interface ViewController (){
    NSMutableArray<MyButton *> *buttonArray;
    NSInteger row;
    BOOL isfirst;
    NSInteger isStep;
    int wh;
    int sp;
    int booms;
    //NSInteger columm;
}



@end

@implementation ViewController

-(void)curreninit {
    isStep = 0;
    isfirst = true;
    booms = 8;
    for (MyButton* x in buttonArray) {
        [x initButtonInfo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    row = 8;
    wh = 40;
    sp = 3;
    [self curreninit];
    buttonArray = [NSMutableArray new];
    MyButton *btn;
    for (int x=0; x<row*row; x++) {
        btn = [MyButton buttonWithType:UIButtonTypeRoundedRect];
        btn.tag = x;
        //[btn setTitle:[NSString stringWithFormat:@"%lu",btn.tag] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(50+(sp+wh)*(x%row), 50+(sp+wh)*(x/row), wh, wh)];
        [btn initButtonLayer];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick:)];
        singleTap.numberOfTapsRequired = 1;
        [btn addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
        doubleClick.numberOfTapsRequired = 2;
        [btn addGestureRecognizer:doubleClick];
        
        [singleTap requireGestureRecognizerToFail:doubleClick];
        
        //[btn addTarget:self action:@selector(singleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonArray addObject:btn];

        [self.view addSubview:btn];

    }
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self initBoomWithHowMuch:6];
}

-(void)singleClick:(UITapGestureRecognizer *)sender {
    if (isfirst) {
        [self initBoomWithHowMuch:booms myButton:buttonArray[sender.view.tag]];
        isfirst = false;
    }
    MyButton *button = buttonArray[sender.view.tag];
    [self displayNum:button];
}
-(void)doubleClick:(UITapGestureRecognizer *)sender {
    if (!buttonArray[sender.view.tag].isClick) {
        [buttonArray[sender.view.tag] setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
        [buttonArray[sender.view.tag] setTitle:@"Fg" forState:UIControlStateNormal];
        buttonArray[sender.view.tag].backgroundColor = [UIColor darkGrayColor];
    }
}

-(void) displayNum:(MyButton *) sender{
    if (sender.isClick) {
        //NSLog(@"isClick");
        return;
    }
    sender.isClick = YES;
    if (sender.isBoom) {
        [self lost:sender];
        return;
    }
    isStep++;
    if (isStep == row*row-booms) {
        [self win];
    }
    sender.backgroundColor = [UIColor grayColor];
    //NSLog(@"My tag : %ld",sender.tag);
    int count = 0;
    
    for (int x = -1; x <= 1; x+=2) {
        for (int y = (int)row-1;  y <= row+1 ; y++) {
            if((sender.tag%row == 0 && (x*y == row-1 || x*y == -(row+1))) || (sender.tag%row == row-1 && (x*y == -(row-1) || x*y == row+1))) {
                continue;
            }
            //NSLog(@"tag:%d",x*y);
            if (sender.tag+(x*y) < 0 || (sender.tag+(x*y) >= row*row)) {
                continue;
            } else {
                if (buttonArray[sender.tag+(x*y)].isBoom) {
                    count++;
                    //NSLog(@"c:%d",count);
                }
            }
        }
        //NSLog(@"tag:%lu",sender.tag+x);
        if (sender.tag+x < 0 || sender.tag+x >= row*row) {
            continue;
        } else if((sender.tag%row == 0 && x == -1) || (sender.tag%row == row-1 && x == 1)) {
            continue;
        } else{
            if (buttonArray[sender.tag+x].isBoom) {
                count++;
                //NSLog(@"c:%d",count);
            }
        }
    }
    
    if (count == 0) {
        buttonArray[sender.tag].backgroundColor = [UIColor lightGrayColor];
        for (int x = -1; x <= 1; x+=2) {
            for (int y = (int)row-1;  y <= row+1 ; y++) {
                if((sender.tag%row == 0 && (x*y == row-1 || x*y == -(row+1))) || (sender.tag%row == row-1 && (x*y == -(row-1) || x*y == row+1))) {
                    continue;
                }
                if (sender.tag+(x*y) < 0 || (sender.tag+(x*y) >= row*row)) {
                    continue;
                } else {
                    //if (!buttonArray[sender.tag+(x*y)].isBoom) {
                        if (sender.isClick) {
                            [self displayNum:buttonArray[sender.tag+(x*y)]];
                        }
                    //}
                }
            }
            if (sender.tag+x < 0 || sender.tag+x >= row*row) {
                continue;
            } else if((sender.tag%row == 0 && x == -1) || (sender.tag%row == row-1 && x == 1)) {
                continue;
            } else{
                //if (!buttonArray[sender.tag+x].isBoom) {
                    if (sender.isClick) {
                        [self displayNum:buttonArray[sender.tag+x]];
                    }
                //}
            }
        }
        return;
    }
    
    switch (count) {
        case 0:
            break;
        case 1:
            [buttonArray[sender.tag] setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            break;
        case 2:
            [buttonArray[sender.tag] setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            break;
        case 3:
            [buttonArray[sender.tag] setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            break;
        default:
            [buttonArray[sender.tag] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            break;
    }
    buttonArray[sender.tag].backgroundColor = [UIColor lightGrayColor];
    [buttonArray[sender.tag] setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
    
}
-(void)initBoomWithHowMuch:(NSInteger) boom myButton:(MyButton *)sender{
    
    NSMutableArray *all = [NSMutableArray new];
    for (int x = 0 ; x < buttonArray.count;  x++) {
        [all addObject:[NSString stringWithFormat:@"%d",x]];
    }
    [all removeObjectAtIndex:sender.tag];
    for (int x = 0 ; x < boom ; x++) {
        int a = arc4random()%(all.count);
        NSString *b = all[a];
        NSInteger ib = [b integerValue];
        buttonArray[ib].isBoom = true;
        [all removeObjectAtIndex:a];
        [buttonArray[ib] setTitle:@"B" forState:UIControlStateNormal];
    }
}
-(void) win {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congratulation !"
                                                                   message:@"You Win !"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *reset = [UIAlertAction actionWithTitle:@"ReSet!"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [self curreninit];
                                                  }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       for (MyButton *x in buttonArray) {
                                                           x.isClick = YES;
                                                       }
                                                   }];
    
    [alert addAction:reset];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) lost:(MyButton *) sender{
    [sender setTitle:@"Bm" forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor darkGrayColor];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BOOM !"
                                                                    message:@"You Lost !"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *reset = [UIAlertAction actionWithTitle:@"ReSet!"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [self curreninit];
                                                  }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       for (MyButton *x in buttonArray) {
                                                           x.isClick = YES;
                                                       }
                                                   }];
    
    [alert addAction:reset];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
