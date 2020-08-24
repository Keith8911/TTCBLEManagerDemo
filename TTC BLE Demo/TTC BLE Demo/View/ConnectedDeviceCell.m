//
//  ConnectedDeviceCell.m
//  TTC BLE Demo
//
//  Created by TTC on 2018/10/30.
//  Copyright © 2018年 TTC. All rights reserved.
//

#import "ConnectedDeviceCell.h"

@implementation ConnectedDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _oadButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _oadButton.layer.borderWidth = 0.5;
    _oadButton.hidden = YES;
    _disconnectButtonn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _disconnectButtonn.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)clickSelectedButton:(id)sender {
    _selectedStateButton.selected = !_selectedStateButton.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(connectedDeviceCellWith:selected:)]) {
        [_delegate connectedDeviceCellWith:_info selected:_selectedStateButton.selected];
    }
}

- (IBAction)clickDisconnectButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(connectedDeviceCellDisconnect:)]) {
        [_delegate connectedDeviceCellDisconnect:_info];
    }
}

@end
