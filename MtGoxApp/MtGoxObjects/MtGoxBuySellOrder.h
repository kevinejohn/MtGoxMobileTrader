//
//  MtGoxBuySellOrder.h
//  MtGoxApp
//
//  Created by Kevin Johnson on 12/3/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MtGoxBuySellOrder : NSObject

@property (strong, nonatomic) NSString* amount;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* price;

@end
