//
//  ViewController.m
//  滑动解锁
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#define SELECT_COLOR [UIColor colorWithRed:0.3 green:0.7 blue:1 alpha:1]
@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *selectBtnArr;
@property (assign, nonatomic) CGPoint currentPoint;
@end

@implementation ViewController
{
    UILabel * indicateLabel;
    UIView * clearView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     _selectBtnArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"1.jpg"];
    [self.view.layer addSublayer:imageView.layer];
    
    indicateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 30)];
    indicateLabel.text = @"请输入密码";
    indicateLabel.textColor = [UIColor colorWithRed:238/255.0 green:160/255.0 blue:198/255.0 alpha:1];
    indicateLabel.textAlignment = NSTextAlignmentCenter;
    indicateLabel.font = [UIFont systemFontOfSize:25];
    [self.view.layer addSublayer:indicateLabel.layer];
    
    clearView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-330, self.view.bounds.size.width, 300)];
//    clearView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:clearView];
    
    float interval = self.view.bounds.size.width/13;
    float radius = interval*3;
    float Xnum = (self.view.bounds.size.width - 4*15)/3;
    float Ynum = (300 - 4*10)/3;
    NSInteger num = 0;
    for (NSInteger i = 0; i < 3; i++) {
        for (NSInteger j = 0; j < 3; j++) {
            UIButton *roundButton = [UIButton buttonWithType:UIButtonTypeCustom];
            roundButton.frame = CGRectMake(15+15*j+Xnum*j, 10+10*i+Ynum*i, Xnum, Ynum);
            [roundButton setImage:[self drawUnselectImageWithRadius:radius-6] forState:UIControlStateNormal];
            [roundButton setImage:[self drawSelectImageWithRadius:radius-6] forState:UIControlStateSelected];
            
            roundButton.userInteractionEnabled = NO;
            roundButton.tag = 1000+num;
            num++;
//            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(buttonMoved:)];
//            recognizer.minimumPressDuration = 1;
//            recognizer.allowableMovement = self.view.bounds.size.width;
//            [clearView addGestureRecognizer:recognizer];
            [clearView addSubview:roundButton];
        }
    }
}
- (void)buttonMoved:(UILongPressGestureRecognizer *)press
{
    CGPoint point = [press locationInView:self.view];
    NSLog(@"%f",point.x);
    NSLog(@"%f",point.y);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"1");
    UITouch *oneTouch = [touches anyObject];
    CGPoint point = [oneTouch locationInView:clearView];
        for (NSInteger i = 0; i < 9; i++) {
            UIButton *oneBtn = [clearView viewWithTag:1000+i];
        if (CGRectContainsPoint(oneBtn.frame, point)) {
            oneBtn.selected = YES;
            if (![_selectBtnArr containsObject:oneBtn]) {
                [_selectBtnArr addObject:oneBtn];
            }
        }
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"2");
    UITouch *oneTouch = [touches anyObject];
    CGPoint point = [oneTouch locationInView:clearView];
    _currentPoint = point;
    for (NSInteger i = 0; i < 9; i++) {
        UIButton *oneBtn = [clearView viewWithTag:1000+i];
        if (CGRectContainsPoint(oneBtn.frame, point)) {
            oneBtn.selected = YES;
            if (![_selectBtnArr containsObject:oneBtn]) {
                [_selectBtnArr addObject:oneBtn];
                break;
            }
        }
    }
     [self drawRect:self.view.frame];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"3");
    //获取结果
    NSMutableString *result = [[NSMutableString alloc]initWithCapacity:0];
    for (int i = 0; i < _selectBtnArr.count; i ++) {
        UIButton *btn = (UIButton *)_selectBtnArr[i];
        [result appendFormat:@"%d",(int)btn.tag];
    }
    UIButton *lastBtn = [_selectBtnArr lastObject];
    _currentPoint = lastBtn.center;
    
}


//画未选中点图片
- (UIImage *)drawUnselectImageWithRadius:(float)radius
{
    NSLog(@"选中");
    UIGraphicsBeginImageContext(CGSizeMake(radius+6, radius+6));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, CGRectMake(3, 3, radius, radius));
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8] setStroke];
    CGContextSetLineWidth(context, 5);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    UIImage *unselectImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return unselectImage;
}
//画选中点图片
- (UIImage *)drawSelectImageWithRadius:(float)radius
{
    UIGraphicsBeginImageContext(CGSizeMake(radius+6, radius+6));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 5);
    
    CGContextAddEllipseInRect(context, CGRectMake(3+radius*5/12, 3+radius*5/12, radius/6, radius/6));
    
    UIColor *selectColor = SELECT_COLOR;
    
    [selectColor set];
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextAddEllipseInRect(context, CGRectMake(3, 3, radius, radius));
    
    [selectColor setStroke];
    
    CGContextDrawPath(context, kCGPathStroke);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
//画错误图片
- (UIImage *)drawWrongImageWithRadius:(float)radius
{
    UIGraphicsBeginImageContext(CGSizeMake(radius+6, radius+6));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 5);
    
    CGContextAddEllipseInRect(context, CGRectMake(3+radius*5/12, 3+radius*5/12, radius/6, radius/6));
    
    UIColor *selectColor = [UIColor orangeColor];
    
    [selectColor set];
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextAddEllipseInRect(context, CGRectMake(3, 3, radius, radius));
    
    [selectColor setStroke];
    
    CGContextDrawPath(context, kCGPathStroke);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"划线");
    UIBezierPath *path;
    if (_selectBtnArr.count == 0) {
        return;
    }
    path = [UIBezierPath bezierPath];
    [[UIColor blueColor] set];
    path.lineWidth = 6;
    path.lineJoinStyle = kCGLineCapRound;
    path.lineCapStyle = kCGLineCapRound;
    for (int i = 0; i < _selectBtnArr.count; i ++) {
        UIButton *btn = _selectBtnArr[i];
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else
        {
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:_currentPoint];
    [path stroke];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
