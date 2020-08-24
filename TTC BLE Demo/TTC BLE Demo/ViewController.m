//
//  ViewController.m
//  TTC BLE Demo
//
//  Created by TTC on 2018/10/30.
//  Copyright © 2018年 TTC. All rights reserved.
//

#import "ViewController.h"
#import "DeviceCell.h"
#import "ConnectedDeviceCell.h"
#import "BLEManager.h"
#import "SVProgressHUD.h"
#import "DataMode.h"
#import "KeyBoardView.h"

#define KWIDTH          [UIScreen mainScreen].bounds.size.width
#define KHEIGHT         [UIScreen mainScreen].bounds.size.height
#define Data_Length     40

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, BLEManagerDelegate, DeviceCellDelegate, KeyBoardViewDelegate, ConnectedDeviceCellDelegate> {
    NSMutableArray *_scanDevices;
    NSMutableArray *_connectedDevices;
    NSMutableArray *_datas;
    NSMutableArray *_selectedConnectDevices;
    BOOL _isScanView;
    DeviceInfo *_connectingDeviceInfo;
    KeyBoardView *_keyBordView;
    BOOL _isEncryption;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备列表";
    if (KHEIGHT >= 812) {
        _bottomLayoutConstraint.constant = -35;
    } else {
        _bottomLayoutConstraint.constant = 0;
    }
    _keyBordView = [[KeyBoardView alloc] initWithFrame:CGRectMake(0, KHEIGHT - KWIDTH / 3 / 2 * 6, KWIDTH, KWIDTH / 3 / 2 * 6)];
    _keyBordView.delegate = self;
    _inputTextField.inputView = _keyBordView;
    [self showSendAboutView:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(sort)];
    _scanDevices = [NSMutableArray array];
    _connectedDevices = [NSMutableArray array];
    _datas = [NSMutableArray array];
    _selectedConnectDevices = [NSMutableArray array];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [BLEManager defaultManager].delegate = self;
    [BLEManager defaultManager].isEncryption = NO;
    _isEncryption = NO;
    [[BLEManager defaultManager] setLogOff];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isScanView) {
        return _scanDevices.count;
    } else {
        return _connectedDevices.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isScanView) {
        return 90;
    } else {
        DataMode *mode = _datas[indexPath.row];
        if (mode.haveData) {
            return 170;
        } else {
            return 105;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isScanView) {
        DeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceCell" owner:self options:nil] lastObject];
        }
        DeviceInfo *info = _scanDevices[indexPath.row];
        cell.delegate = self;
        cell.info = info;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.RSSIImageView.image = [UIImage imageNamed:[self returnRssiImageBy:(int)info.RSSI]];
        cell.DeviceNameLabel.text = info.localName;
        cell.deviceMacLabel.text = info.macAddrss;
        return cell;
    } else {
        ConnectedDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID2"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ConnectedDeviceCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        DeviceInfo *info = _connectedDevices[indexPath.row];
        cell.info = info;
        DataMode *mode = _datas[indexPath.row];
        if (mode.haveData == NO) {
            cell.uuidLabel.hidden = YES;
            cell.dateLabel.hidden = YES;
            cell.dateLengthLabel.hidden = YES;
            cell.timeLabel.text = @"no data";
        } else {
            cell.uuidLabel.hidden = NO;
            cell.dateLabel.hidden = NO;
            cell.dateLengthLabel.hidden = NO;
            cell.timeLabel.text = [NSString stringWithFormat:@"timestap:%@", mode.time];
            cell.uuidLabel.text = [NSString stringWithFormat:@"uuid:%@", mode.uuidString];
            cell.dateLengthLabel.text = [NSString stringWithFormat:@"length:%ld", mode.data.length];
            cell.dateLabel.text = [NSString stringWithFormat:@"data:%@", mode.data];
        }
        cell.localNameLabel.text = info.localName;
        cell.macLabel.text = info.macAddrss;
        if (info.macAddrss == nil || [info.macAddrss isEqualToString:@""]) {
            cell.macLabel.text = @"<unknow mac>";
        }
        cell.rssiLabel.text = [NSString stringWithFormat:@"rssi:%ld", info.RSSI];
        if ([_selectedConnectDevices containsObject:cell.info]) {
            cell.selectedStateButton.selected = YES;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isScanView) {
        DeviceInfo *info = _scanDevices[indexPath.row];
        _connectingDeviceInfo = info;
        [[BLEManager defaultManager] connectToDevice:info.cb];
        [SVProgressHUD showWithStatus:@"正在连接设备..."];
        [self performSelector:@selector(connectTimeout:) withObject:info.cb afterDelay:5.0f];
    } else {
        
    }
}

#pragma mark - BLEManager Delegate
- (void)centerManagerStateChange:(CBCentralManager *)center {
    if (center.state == CBCentralManagerStatePoweredOn) {
        [self startScan];
    }
}

- (void)scanDeviceRefrash:(NSMutableArray *)array {
    for (DeviceInfo *info in array) {
        if (![_scanDevices containsObject:info]) {
            [_scanDevices addObject:info];
        }
    }
    [_tableView reloadData];
}

- (void)connectDeviceSuccess:(CBPeripheral *)device error:(NSError *)error {
    [SVProgressHUD showSuccessWithStatus:@"连接成功"];
    [_connectedDevices addObject:_connectingDeviceInfo];
    DataMode *mode = [[DataMode alloc] init];
    mode.haveData = NO;
    mode.deviceUUID = device.identifier.UUIDString;
    [_datas addObject:mode];
    [_scanDevices removeObject:_connectingDeviceInfo];
    [_tableView reloadData];
}

- (void)didDisconnectDevice:(CBPeripheral *)device error:(NSError *)error {
    for (DeviceInfo *info in _connectedDevices) {
        if ([info.cb.identifier.UUIDString isEqualToString:device.identifier.UUIDString]) {
            [_connectedDevices removeObject:info];
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@断开连接", info.localName]];
            break;
        }
    }
    if (_selectedConnectDevices.count > 0) {
        for (DeviceInfo *info in _selectedConnectDevices) {
            if ([info.cb.identifier.UUIDString isEqualToString:device.identifier.UUIDString]) {
                [_selectedConnectDevices removeObject:info];
                break;
            }
        }
    }
    for (DataMode *mode in _datas) {
        if ([mode.deviceUUID isEqualToString:device.identifier.UUIDString]) {
            [_datas removeObject:mode];
            break;
        }
    }
    if (_isScanView == NO) {
        [_tableView reloadData];
    }
}

- (void)bleManagerPeripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    for (DataMode *mode in _datas) {
        if ([mode.deviceUUID isEqualToString:peripheral.identifier.UUIDString]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd hh:mm:ss.SSS"];
            NSString *time = [dateFormatter stringFromDate:[NSDate date]];
            mode.time = time;
            mode.uuidString = [characteristic.UUID UUIDString];
            mode.data = characteristic.value;
            mode.haveData = YES;
            break;
        }
    }
    [_tableView reloadData];
}

#pragma mark - DeviceCell Delegate
- (void)deviceCellClickConnectButton:(DeviceCell *)cell {
    DeviceInfo *info = cell.info;
    _connectingDeviceInfo = info;
    [[BLEManager defaultManager] connectToDevice:info.cb];
    [SVProgressHUD showWithStatus:@"正在连接设备..."];
    [self performSelector:@selector(connectTimeout:) withObject:info.cb afterDelay:5.0f];
}

#pragma mark - ConnectedDeviceCell Delegate
- (void)connectedDeviceCellWith:(DeviceInfo *)info selected:(BOOL)selected {
    if (selected) {
        [_selectedConnectDevices addObject:info];
    } else {
        if ([_selectedConnectDevices containsObject:info]) {
            [_selectedConnectDevices removeObject:info];
        }
    }
}

- (void)connectedDeviceCellDisconnect:(DeviceInfo *)info {
    [[BLEManager defaultManager] disconnectDevice:info.cb];
}

#pragma mark - KeyBoardView Delegate
- (void)keyBordView:(KeyBoardView *)view passValueWithButton:(UIButton *)button {
    [button setHighlighted:YES];
    if (!(button.tag == 1015 || button.tag == 1017)) {
        if (_inputTextField.text.length == Data_Length) {
            return;
        }
        _inputTextField.text = [NSString stringWithFormat:@"%@%@", _inputTextField.text, button.titleLabel.text];
    } else {
        if (button.tag == 1015) {
            [_inputTextField resignFirstResponder];
        } else {
            if ([_inputTextField.text length] != 0) {
                _inputTextField.text = [_inputTextField.text substringToIndex:([_inputTextField.text length] - 1)];
            }
        }
    }
}

#pragma mark - Private Methed
- (void)showSendAboutView:(BOOL)show {
    _sendButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _sendButton.layer.borderWidth = 0.5;
    _isScanView = !show;
    _inputTextField.hidden = !show;
    _inputLengthLabel.hidden = !show;
    _encryptionLabel.hidden = !show;
    _encryptionButton.hidden = !show;
    _sendButton.hidden = !show;
    if (show) {
        _bottomSpaceLayout.constant = 100;
    } else {
        _bottomSpaceLayout.constant = 0;
    }
}

- (NSString *)returnRssiImageBy:(int)rssii {
    if (rssii > -45 && rssii < 0) {
        return @"xh05.png";
    } else if (rssii <= -45 && rssii > -55) {
        return @"xh04.png";
    } else if (rssii <= -55 && rssii > -65) {
        return @"xh03.png";
    } else if (rssii <= -65 && rssii > -75) {
        return @"xh02.png";
    } else if (rssii <= -75 && rssii > -90) {
        return @"xh01.png";
    } else if (rssii <= -90) {
        return @"xh00.png";
    }
    return @"xh00.png";
}

- (void)startScan {
    [[BLEManager defaultManager] scanDeviceTime:3.0];
    [SVProgressHUD showWithStatus:@"正在扫描设备..."];
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(stopScan) userInfo:nil repeats:NO];
}

- (void)stopScan {
    [SVProgressHUD dismiss];
}

- (void)connectTimeout:(CBPeripheral *)peripheral {
    if (![[BLEManager defaultManager] readDeviceIsConnect:peripheral]) {
        [SVProgressHUD showErrorWithStatus:@"连接超时"];
        [[BLEManager defaultManager] disconnectDevice:_connectingDeviceInfo.cb];
    } else {
        return;
    }
}

- (IBAction)clickScanButton:(id)sender {
    [self showSendAboutView:NO];
    [_scanDevices removeAllObjects];
    [_tableView reloadData];
    [self startScan];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(sort)];
}

- (IBAction)clickConnectedButton:(id)sender {
    [self showSendAboutView:YES];
    [_tableView reloadData];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)sort {
    if (_scanDevices.count == 0 || _scanDevices == nil ) {
        return;
    }
    if (_scanDevices.count > 0) {
        for (int i = 0; i < _scanDevices.count - 1; i++) {
            for (int j = i; j < _scanDevices.count; j++) {
                DeviceInfo *info1 = _scanDevices[i];
                DeviceInfo *info2 = _scanDevices[j];
                NSInteger rssi_1 = info1.RSSI;
                NSInteger rssi_2 = info2.RSSI;
                if (rssi_1 < rssi_2 && rssi_1 < 0 && rssi_2 < 0) {
                    [_scanDevices exchangeObjectAtIndex:i withObjectAtIndex:j];
                } else if (rssi_1 > 0 && rssi_2 < 0) {
                    [_scanDevices exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
    }
    if (_tableView.visibleCells.count != 0) {
        NSIndexPath *topRow = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView scrollToRowAtIndexPath:topRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    [_tableView reloadData];
}

- (IBAction)clickEncryptionButton:(id)sender {
    _encryptionButton.selected = !_encryptionButton.selected;
    _isEncryption = _encryptionButton.selected;
    [BLEManager defaultManager].isEncryption = _encryptionButton.selected;
}

- (IBAction)clickSendButton:(id)sender {
    if (_selectedConnectDevices.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"当前没有选择设备"];
        return;
    }
    if (_inputTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"当前没有数据"];
        return;
    }
    NSString * string = _inputTextField.text;
    if (_inputTextField.text.length % 2 != 0) {
        string = [NSString stringWithFormat:@"0%@", _inputTextField.text];
    }
    for (DeviceInfo *info in _selectedConnectDevices) {
        [[BLEManager defaultManager] sendDataToDevice1:string device:info.cb];
    }
}

@end

