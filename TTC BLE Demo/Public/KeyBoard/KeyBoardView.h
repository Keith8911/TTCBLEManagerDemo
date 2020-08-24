//
//  KeyBoardView.h
//  MyKeyboardDemo
//
//  Created by laitang on 16/4/28.
//  Copyright © 2016年 laitang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyBoardView;

@protocol KeyBoardViewDelegate <NSObject>

- (void)keyBordView:(KeyBoardView*)view passValueWithButton:(UIButton *)button;

@end

@interface KeyBoardView : UIView

@property (nonatomic, assign)id<KeyBoardViewDelegate> delegate;

@end
