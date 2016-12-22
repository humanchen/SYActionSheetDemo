//
//  ViewController.m
//  SYActionSheetDemo
//
//  Created by human on 2016/12/17.
//  Copyright © 2016年 human. All rights reserved.
//

#import "ViewController.h"
#import "SYActionSheet.h"
#import "UIImage+BoxBlur.h"
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
   
    
    UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBtn.frame =CGRectMake(100, 100, 100, 40);
//    otherBtn.backgroundColor = [UIColor whiteColor];
//    UIImage *cuttedImage = cutOriginalBackgroundImageInRect(obj.frame);
//    UIImage *backgroundImageNormal = [[self imageToblur:[self imageFromColor:[UIColor colorWithWhite:1 alpha:0.65]]] drn_boxblurImageWithBlur:0.7 withTintColor:[UIColor colorWithWhite:1 alpha:0.65]];
    [otherBtn setBackgroundImage:[self imageToblur:[self imageFromColor:[UIColor colorWithWhite:1 alpha:0.65]]] forState:UIControlStateNormal];
    [self.view addSubview:otherBtn];
    
}




- (UIImage *)imageFromColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



- (UIImage *)imageToblur:(UIImage *)image{
    
    CIContext *context1 = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    // Setting up gaussian blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    [filter setValue:[NSNumber numberWithFloat:0.7] forKey:@"inputRadius"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGImageRef cgImage = [context1 createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return returnImage;
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
