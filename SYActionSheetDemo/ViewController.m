//
//  ViewController.m
//  SYActionSheetDemo
//
//  Created by human on 2016/12/17.
//  Copyright © 2016年 human. All rights reserved.
//

#import "ViewController.h"
#import "SYActionSheet.h"

#define SCREEN_BOUNDS         [UIScreen mainScreen].bounds
#define SCREEN_WIDTH          [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT         [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor redColor];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    SYActionSheet *actionSheet=[[SYActionSheet alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) otherTitles:@[ @"主号拨打", @"副号2拨打副号2拨打副号2拨打", @"副号3拨打"] otherImages:@[[UIImage imageNamed:@"电话icon"],
                                                                                                                                              [UIImage imageNamed:@"电话icon"],
                                                                                                                                              [UIImage imageNamed:@"share_qq_friend"],
                                                                                                                                              ] selectSheetBlock:^(SYActionSheet *actionSheet, NSInteger index) {

                                                                                                                                              }];
    
    actionSheet.otherActionItemAlignment=SYActionItemAlignmentCenter;
    actionSheet.diretion=SYActionDownToUp;
    actionSheet.backGroundType=SYBackGroundBlur;
    [actionSheet show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
