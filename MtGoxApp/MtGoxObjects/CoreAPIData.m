//
//  MtGoxAccountInfo.m
//  MtGoxApp
//
//  Created by Kevin Johnson on 12/2/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "CoreAPIData.h"

@implementation CoreAPIData
@synthesize usersUSDs, usersBTCs;
@synthesize username, password, lastBTCtoUSDprice, lastBuyPrice, lastSellPrice, totalWorth, lastUpdated, openOrders;

- (id) init
{
    self = [super init];
    if (self) {
        self.totalWorth = 0.0f;
        self.lastBTCtoUSDprice = 99999.9f;
    }
    return self;
}

@end
