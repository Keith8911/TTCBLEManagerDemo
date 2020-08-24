//
//  ViewController.h
//  TTC BLE Demo
//
//  Created by TTC on 2018/10/30.
//  Copyright © 2018年 TTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *connectedButton;

- (IBAction)clickScanButton:(id)sender;
- (IBAction)clickConnectedButton:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;

@property (weak, nonatomic) IBOutlet UILabel *inputLengthLabel;

@property (weak, nonatomic) IBOutlet UIButton *encryptionButton;
@property (weak, nonatomic) IBOutlet UILabel *encryptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;


- (IBAction)clickEncryptionButton:(id)sender;
- (IBAction)clickSendButton:(id)sender;


@end

