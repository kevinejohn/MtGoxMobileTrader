//
//  APIDataProcessor.h
//  MtGoxApp
//
//  Created by Kevin Johnson on 12/3/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreAPIData.h"
#import "MTGONXController.h"

@protocol APIDataProcessorDelegate <NSObject>

@required
-(void) RefreshedData:(CoreAPIData*)data;
-(void)CouldNotLogin;
@end

@interface APIDataProcessor : NSObject <MTGONXDelegate>

- (id) initWithUsername:(NSString*)username andPassword:(NSString*)password andDelegate:(id<APIDataProcessorDelegate>)delegate;
-(void)PlaceOrder:(MtGoxBuySellOrder*)order;
- (void)CancelOrder:(NSUInteger)orderIndex;
- (void)StopAutoRefresh;
- (void)StartAutoRefresh;

-(float)getLastBuyPrice;
-(float)getLastSellPrice;
-(float)getUsersBTCs;
-(float)getUsersUSDs;
@end
