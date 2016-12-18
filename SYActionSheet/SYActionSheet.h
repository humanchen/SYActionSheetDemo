//
//  SYActionSheet.h
//  SYActionSheetDemo
//
//  Created by human on 2016/12/17.
//  Copyright © 2016年 human. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYActionSheet;

typedef NS_ENUM(NSInteger, SYActionItemAlignment) {
    SYActionItemAlignmentLeft,
    SYActionItemAlignmentCenter
};

typedef NS_ENUM(NSInteger, SYDiretion) {
    SYActionDownToUp,
    SYActionUpToDown
};


typedef NS_ENUM(NSInteger, SYBackGroundType) {
    SYBackGroundNormal,
    SYBackGroundBlur
};


typedef void (^ActionSheetDidSelectSheetBlock)(SYActionSheet *actionSheet, NSInteger index);


@interface SYActionSheet : UIView

@property (nonatomic, assign) SYActionItemAlignment otherActionItemAlignment;
@property (nonatomic, assign) SYDiretion diretion;
@property (nonatomic, assign) SYBackGroundType backGroundType;

- (instancetype)initWithFrame:(CGRect)frame
                  otherTitles:(NSArray  *)otherTitles
                  otherImages:(NSArray  *)otherImages
             selectSheetBlock:(ActionSheetDidSelectSheetBlock)selectSheetBlock;


-(void)show;

-(void)dismiss;


@end
