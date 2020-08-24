//
//  DeviceCell.h
//  JDBLESDKDemo
//
//  Created by TTC on 2018/10/15.
//  Copyright © 2018年 TTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DeviceCellDelegate;

@interface DeviceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *RSSIImageView;

@property (weak, nonatomic) IBOutlet UILabel *DeviceNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *deviceMacLabel;

@property (weak, nonatomic) IBOutlet UIButton *OADButton;

@property (nonatomic, weak) DeviceInfo *info;

- (IBAction)clickOADButton:(id)sender;

@property (nonatomic, strong) id <DeviceCellDelegate> delegate;


@end

@protocol DeviceCellDelegate <NSObject>

- (void)deviceCellClickConnectButton:(DeviceCell *)cell;

@end

NS_ASSUME_NONNULL_END
