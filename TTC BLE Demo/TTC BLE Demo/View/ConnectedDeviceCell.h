//
//  ConnectedDeviceCell.h
//  TTC BLE Demo
//
//  Created by TTC on 2018/10/30.
//  Copyright © 2018年 TTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ConnectedDeviceCellDelegate;

@interface ConnectedDeviceCell : UITableViewCell

@property (nonatomic, weak) DeviceInfo *info;

@property (nonatomic, weak) id <ConnectedDeviceCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *localNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedStateButton;

@property (weak, nonatomic) IBOutlet UIButton *oadButton;
@property (weak, nonatomic) IBOutlet UIButton *disconnectButtonn;

- (IBAction)clickSelectedButton:(id)sender;
- (IBAction)clickDisconnectButton:(id)sender;

@end

@protocol ConnectedDeviceCellDelegate <NSObject>

- (void)connectedDeviceCellWith:(DeviceInfo *)info selected:(BOOL)selected;

- (void)connectedDeviceCellDisconnect:(DeviceInfo *)info;

@end

NS_ASSUME_NONNULL_END
