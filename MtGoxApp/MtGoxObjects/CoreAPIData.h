//
//  MtGoxAccountInfo.h
//  MtGoxApp
//
//  Created by Kevin Johnson on 12/2/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreAPIData : NSObject

@property (atomic) float usersBTCs;
@property (atomic) float usersUSDs;
@property (atomic) float lastBTCtoUSDprice;
@property (atomic) float lastBuyPrice;
@property (atomic) float lastSellPrice;
@property (atomic) float totalWorth;
@property (strong, atomic) NSString* lastUpdated;
@property (strong, atomic) NSString* username;
@property (strong, atomic) NSString* password;
@property (strong, nonatomic) NSMutableArray* openOrders;

@end
