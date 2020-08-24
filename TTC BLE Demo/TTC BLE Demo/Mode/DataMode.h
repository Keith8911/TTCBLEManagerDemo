//
//  DataMode.h
//  TTC BLE Demo
//
//  Created by TTC on 2018/10/30.
//  Copyright © 2018年 TTC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataMode : NSObject

@property (nonatomic, assign) BOOL haveData;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *uuidString;

@property (nonatomic, weak) NSData *data;

@property (nonatomic, copy) NSString *deviceUUID;

@end

NS_ASSUME_NONNULL_END
