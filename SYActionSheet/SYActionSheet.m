//
//  SYActionSheet.m
//  SYActionSheetDemo
//
//  Created by human on 2016/12/17.
//  Copyright © 2016年 human. All rights reserved.
//

#import "SYActionSheet.h"

#define SCREEN_BOUNDS         [UIScreen mainScreen].bounds
#define SCREEN_WIDTH          [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT         [UIScreen mainScreen].bounds.size.height
#define SCREEN_ADJUST(Value)  SCREEN_WIDTH * (Value) / 375.0

#define kActionItemHeight     64
#define kLineHeight           0.5
#define kActionItemFontSize   16

#define kBackViewColor   [UIColor colorWithWhite:0 alpha:0.5]
#define kActionSheetColor            [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f]
#define kActionItemHighlightedColor  [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]
#define kActionItemHighlightedColorBlur  [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:0.5f]


@interface SYActionSheet ()
@property (nonatomic, copy) ActionSheetDidSelectSheetBlock selectSheetBlock;

@property (nonatomic, strong) UIView    *backView;
@property (nonatomic, strong) UIView  *actionSheet;

@property (nonatomic, copy) NSArray   *otherTitles;
@property (nonatomic, copy) NSArray   *otherImages;

@property (nonatomic, assign) CGFloat  offsetY;
@property (nonatomic, assign) CGFloat  actionSheetHeight;


@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, strong) UIImage *highlightedImageBlur;

@property (nonatomic, strong) NSMutableArray *otherActionItems;
@property (nonatomic, strong) NSMutableArray *otherActionButtons;
@end

@implementation SYActionSheet

#pragma mark - Getter && Setter
-(UIView *)backView{
    if(!_backView)
    {
        _backView=[[UIView alloc]init];
        _backView.frame=self.bounds;
        _backView.backgroundColor = kBackViewColor;
        [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    }
    return _backView;
}

-(UIView *)actionSheet{
    if(!_actionSheet)
    {
        _actionSheet=[[UIView alloc]init];
        _actionSheet.backgroundColor= kActionSheetColor;
    }
    return _actionSheet;
}


- (UIImage *)normalImage {
    
    if (!_normalImage) {
        _normalImage = [self imageFromColor:[UIColor whiteColor]];
    }
    return _normalImage;
}

- (UIImage *)highlightedImage {
    
    if (!_highlightedImage) {
        _highlightedImage = [self imageFromColor:kActionItemHighlightedColor];
    }
    return _highlightedImage;
}

- (UIImage *)highlightedImageBlur {
    
    if (!_highlightedImageBlur) {
        _highlightedImageBlur = [self imageToblur:[self imageFromColor:kActionItemHighlightedColorBlur]];
    }
    return _highlightedImageBlur;
}


- (NSMutableArray *)otherActionItems {
    
    if (!_otherActionItems) {
        _otherActionItems = [NSMutableArray array];
    }
    return _otherActionItems;
}

- (NSMutableArray *)otherActionButtons {
    
    if (!_otherActionButtons) {
        _otherActionButtons = [NSMutableArray array];
    }
    return _otherActionButtons;
}

-(SYDiretion)diretion{
    if(!_diretion)
    {
        _diretion=SYActionDownToUp;
    }
    return _diretion;
}


- (void)setOtherActionItemAlignment:(SYActionItemAlignment)otherActionItemAlignment {
    
    _otherActionItemAlignment = otherActionItemAlignment;
    
    switch (otherActionItemAlignment) {
        case SYActionItemAlignmentLeft:
        {
            for (UIView *actionItem in self.otherActionItems) {
                UILabel *title = [actionItem viewWithTag:1];
                title.textAlignment = NSTextAlignmentLeft;
                CGRect newFrame = actionItem.frame;
                newFrame.origin.x = 10;
                actionItem.frame = newFrame;
            }
        }
            break;
            
        case SYActionItemAlignmentCenter:
        {
            for (UIView *actionItem in self.otherActionItems) {
                UILabel *title = [actionItem viewWithTag:1];
                title.textAlignment = NSTextAlignmentCenter;
                CGRect newFrame = actionItem.frame;
                newFrame.origin.x = self.frame.size.width * 0.5 - newFrame.size.width * 0.5;
                actionItem.frame = newFrame;
            }
        }
            break;
    }
}


- (void)setBackGroundType:(SYBackGroundType)backGroundType{
    _backGroundType=backGroundType;
    
    switch (backGroundType) {
        case SYBackGroundBlur:
        {
            _actionSheet.backgroundColor= [UIColor clearColor];
            for (UIButton *button in self.otherActionButtons) {
                button.backgroundColor=[UIColor clearColor];
                [button setBackgroundImage:nil forState:UIControlStateNormal];
                [button setBackgroundImage:self.highlightedImageBlur forState:UIControlStateHighlighted];
            }
            
        }
            break;
        case SYBackGroundNormal:
        {
            _actionSheet.backgroundColor=kActionSheetColor;
            for (UIButton *button in self.otherActionButtons) {
                button.backgroundColor=[UIColor whiteColor];
                [button setBackgroundImage:self.normalImage forState:UIControlStateNormal];
                [button setBackgroundImage:self.highlightedImage forState:UIControlStateHighlighted];
            }
        }
        default:
            break;
    }
    
    
}


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
                  otherTitles:(NSArray  *)otherTitles
                  otherImages:(NSArray  *)otherImages
             selectSheetBlock:(ActionSheetDidSelectSheetBlock)selectSheetBlock
{
    if (self = [super initWithFrame:frame]) {
        
        _otherImages      = otherImages;
        _otherTitles      = otherTitles;
        _selectSheetBlock = selectSheetBlock;
        _backGroundType   = SYBackGroundNormal;
        self.clipsToBounds=YES;
        [self setupBack];
        [self setupActionSheet];
    }
    return self;
}


-(void)setupBack{
    [self addSubview:self.backView];
    self.backView.alpha=0;
}


-(void)setupActionSheet{
    [self addSubview:self.actionSheet];
    
    [self setupOtherActionItems];
    
    self.actionSheet.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _offsetY);
    _actionSheetHeight = _offsetY;
}

- (void)setupOtherActionItems {
    
    if (self.otherTitles && self.otherTitles.count > 0) {
        for (int i = 0; i < _otherTitles.count; i++) {
            
            UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
            effe.frame = CGRectMake(0, _offsetY, self.frame.size.width, kActionItemHeight);

            
            UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            otherBtn.frame = effe.bounds;
            otherBtn.backgroundColor = [UIColor whiteColor];
            
            otherBtn.tag = i;
            
            [otherBtn addTarget:self action:@selector(didSelectSheet:) forControlEvents:UIControlEventTouchUpInside];
            [otherBtn setBackgroundImage:self.normalImage forState:UIControlStateNormal];
            [otherBtn setBackgroundImage:self.highlightedImage forState:UIControlStateHighlighted];
           [effe addSubview:otherBtn];
            [self.otherActionButtons addObject:otherBtn];
            
            UIView *otherItem = [[UIView alloc] init];
            otherItem.backgroundColor = [UIColor clearColor];
            [otherBtn addSubview:otherItem];
            
            CGSize maxTitleSize = [self maxSizeInStrings:_otherTitles];
            
            if (_otherImages && _otherImages.count > 0) {
                UIImageView *icon = [[UIImageView alloc] init];
                [otherItem addSubview:({
                    icon.frame = CGRectMake(0, 10, kActionItemHeight-20, kActionItemHeight-20);
                    icon.image = _otherImages.count > i ? _otherImages[i] : nil;
                    icon.contentMode = UIViewContentModeCenter;
                    icon.tag = 2;
                    icon;
                })];
                
                [otherItem addSubview:({
                    UILabel *title = [[UILabel alloc] init];
                    title.frame = CGRectMake(CGRectGetMaxX(icon.frame), 0, maxTitleSize.width, kActionItemHeight);
                    title.font = [UIFont systemFontOfSize:kActionItemFontSize];
                    title.tintColor = [UIColor blackColor];
                    title.text = _otherTitles[i];
                    title.tag = 1;
                    title;
                })];
                otherItem.frame = CGRectMake((self.frame.size.width-(kActionItemHeight + maxTitleSize.width-20))/2, 0, kActionItemHeight + maxTitleSize.width-20, kActionItemHeight);
                
            } else {
                [otherItem addSubview:({
                    UILabel *title = [[UILabel alloc] init];
                    
                    title.frame = CGRectMake(0, 0, maxTitleSize.width, kActionItemHeight);
                    title.font = [UIFont systemFontOfSize:kActionItemFontSize];
                    title.tintColor = [UIColor blackColor];
                    title.text = _otherTitles[i];
                    title.textAlignment = NSTextAlignmentCenter;
                    title.tag = 1;
                    title;
                })];
                otherItem.frame = CGRectMake(self.frame.size.width * 0.5 - maxTitleSize.width * 0.5, 0, maxTitleSize.width, kActionItemHeight);
       
            }
            [self.otherActionItems addObject:otherItem];
            otherItem.userInteractionEnabled = NO;
            
            
            if (i == _otherTitles.count - 1) {
                _offsetY += kActionItemHeight;
            } else {
                _offsetY += kActionItemHeight + kLineHeight;
            }
            [self.actionSheet addSubview:effe];
        }
    }
}


#pragma mark - Animations

- (void)show {
    if(self.diretion==SYActionDownToUp){
         self.actionSheet.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _offsetY);
      
    }else{
         self.actionSheet.frame = CGRectMake(0, -_offsetY, CGRectGetWidth(self.frame), _offsetY);
    }
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backView.alpha = 1.0;
                         if(self.diretion==SYActionDownToUp){
                             self.actionSheet.transform = CGAffineTransformMakeTranslation(0, -self.actionSheetHeight);

                         }else{
                             self.actionSheet.transform = CGAffineTransformMakeTranslation(0, self.actionSheetHeight);
                         }


                     }
                     completion:nil];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backView.alpha = 0.0;
                         self.actionSheet.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}



#pragma mark - Actions

- (void)didSelectSheet:(UIButton *)button {
    
    if (_selectSheetBlock) {
        _selectSheetBlock(self, button.tag);
    }

    [self dismiss];
}


#pragma mark - Tool

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
    
    [filter setValue:[NSNumber numberWithFloat:0.5] forKey:@"inputRadius"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGImageRef cgImage = [context1 createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return returnImage;
}


- (CGSize)maxSizeInStrings:(NSArray *)strings {
    
    CGSize maxSize = CGSizeZero;
    CGFloat maxWith = 0.0;
    for (NSString *string in strings) {
        CGSize size = [self sizeOfString:string withFont:[UIFont systemFontOfSize:kActionItemFontSize]];
        if (maxWith < size.width) {
            maxWith = size.width;
            maxSize = size;
        }
    }
    return maxSize;
}

- (CGSize)sizeOfString:(NSString *)string withFont:(UIFont *)font {
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
