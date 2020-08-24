//
//  DeviceCell.m
//  JDBLESDKDemo
//
//  Created by TTC on 2018/10/15.
//  Copyright © 2018年 TTC. All rights reserved.
//

#import "DeviceCell.h"

@implementation DeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _OADButton.layer.cornerRadius = 3;
    _OADButton.layer.borderColor = [UIColor blueColor].CGColor;
    _OADButton.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickOADButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(deviceCellClickConnectButton:)]) {
        [_delegate deviceCellClickConnectButton:self];
    }
}

@end
