//
//  MtGoxOpenOrder.h
//  MtGoxApp
//
//  Created by Kevin Johnson on 12/3/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MtGoxOpenOrder : NSObject
@property float amount;
@property float price;
@property (strong, nonatomic) NSNumber* type;
@property long long priority;
@property long long date;
@property (strong, nonatomic) NSString* currency;
@property (strong, nonatomic) NSNumber* orderID;

@end
