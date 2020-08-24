//
//  KeyBoardView.m
//  MyKeyboardDemo
//
//  Created by laitang on 16/4/28.
//  Copyright © 2016年 laitang. All rights reserved.
//

#import "KeyBoardView.h"

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height
@interface KeyBoardView ()
@property (nonatomic, strong)NSMutableArray *numberArray;


@end

@implementation KeyBoardView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberArray = [@[@"A",@"B",@"C",@"D",@"E",@"F",@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"完成", @"0", @"删除"] mutableCopy];

        [self setUpMyKeyBoard];

    }
    return self;
}

- (void)setUpMyKeyBoard
{
    NSInteger index = 0;
    for (NSInteger i = 0; i < 6; i++) {
        for (NSInteger j = 0; j < 3; j++) {
            UIButton *numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            numberBtn.frame = CGRectMake(kWidth/3*j, kWidth/3/2*i, kWidth/3, kWidth/3/2);
            [numberBtn setTitle:_numberArray[index] forState:UIControlStateNormal];
            numberBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            numberBtn.tag = 1000+index;
            numberBtn.backgroundColor = [UIColor whiteColor];
            [numberBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [numberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self drawActionWithBtn:numberBtn];
            [numberBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:numberBtn];
            
            index++;
        }
        
    }
}


- (void)clickAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBordView:passValueWithButton:)]) {
        [self.delegate keyBordView:self passValueWithButton:sender];
    }
}

// 划线方法
- (void)drawActionWithBtn:(UIButton *)sender
{
    UIBezierPath *bottomPath = [UIBezierPath bezierPath];
    if (sender.tag < 1015) {
        [bottomPath moveToPoint:CGPointMake(0, CGRectGetHeight(sender.frame))];
        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(sender.frame), CGRectGetHeight(sender.frame))];
        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(sender.frame), 0)];
        if (sender.tag < 1003) {
            [bottomPath addLineToPoint:CGPointMake(0, 0)];
        }
    }else{
        [bottomPath moveToPoint:CGPointMake(CGRectGetWidth(sender.frame), 0)];
        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(sender.frame), CGRectGetHeight(sender.frame))];
                                            
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.bounds = sender.bounds;
    layer.position = CGPointMake(sender.frame.size.width/2, sender.frame.size.height/2);
    layer.strokeColor = [UIColor lightGrayColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = bottomPath.CGPath;
    [sender.layer addSublayer:layer];
    
}
























@end
