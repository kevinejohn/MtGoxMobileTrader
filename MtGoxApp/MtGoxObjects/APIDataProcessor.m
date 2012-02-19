//
//  APIDataProcessor.m
//  MtGoxApp
//
//  Created by Kevin Johnson on 12/3/11.
//  Copyright (c) 2011 Home. All rights reserved.
//


#define AUTOREFRESH_RATE 15.0

#define MTGOX_RECEIVEDBALANCE_TAG 1
#define MTGOX_RECEIVEDPRICES_TAG 2
#define MTGOX_RECEIVEDOPENORDERS_TAG 3

#import "APIDataProcessor.h"


@interface APIDataProcessor ()

@property (strong, nonatomic) CoreAPIData* data;
@property (strong, nonatomic) MTGONXController* mtgox;
@property (strong, nonatomic) NSTimer* autoRefreshTimer;
@property (strong, nonatomic) id<APIDataProcessorDelegate> delegate;

@end



@implementation APIDataProcessor
@synthesize data;
@synthesize mtgox;
@synthesize autoRefreshTimer;
@synthesize delegate=_delegate;

-(float)getLastSellPrice
{
    return self.data.lastSellPrice;
}

-(float)getLastBuyPrice
{
    return self.data.lastBuyPrice;
}

-(float)getUsersUSDs
{
    return self.data.usersUSDs;
}
-(float)getUsersBTCs
{
    return self.data.usersBTCs;
}

- (void)UpdateTotalWorth
{
    self.data.totalWorth = (self.data.usersBTCs * self.data.lastSellPrice) + self.data.usersUSDs;
}

-(void)CompleteUpdate:(NSInteger)tag
{
    static bool receivedBalance = NO;
    static bool receivedPrices = NO;
    static bool receivedOpenOrders = NO;
    
    switch (tag) {
        case MTGOX_RECEIVEDBALANCE_TAG:
            receivedBalance = YES;
            break;
        case MTGOX_RECEIVEDPRICES_TAG:
            receivedPrices = YES;
            break;
        case MTGOX_RECEIVEDOPENORDERS_TAG:
            receivedOpenOrders = YES;
            break;
            
        default:
            break;
    }
    
    if (receivedPrices && receivedBalance && receivedOpenOrders) {
        [self UpdateTotalWorth];
        receivedBalance = NO;
        receivedOpenOrders = NO;
        receivedPrices = NO;
        
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(RefreshedData:)])
        {
            [self.delegate RefreshedData:self.data];
        }
    }
}

-(void)LastUpdated
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    
    self.data.lastUpdated = [NSString stringWithFormat:@"Last Updated: %@ %@", theDate, theTime];
}


- (void)RefreshInfo {
    [self.mtgox startGettingBalanceWithUsername:self.data.username andPassword:self.data.password];
    
    [self.mtgox startGettingPrices];
    
    [self.mtgox startGettingOpenOrders:self.data.username andPassword:self.data.password];
    [self LastUpdated];
    
    
}

- (void)StopAutoRefresh
{
    NSLog(@"Stopping auto refresh");
    [self.autoRefreshTimer invalidate];
    self.autoRefreshTimer = nil;
    
}

- (void)StartAutoRefresh
{
    NSLog(@"Starting auto refresh");
    [self.autoRefreshTimer invalidate];
    self.autoRefreshTimer = nil;
    
    [self RefreshInfo];
    
    self.autoRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:AUTOREFRESH_RATE target:self selector:@selector(RefreshInfo) userInfo:nil repeats:YES];
    
}

- (id) initWithUsername:(NSString*)username andPassword:(NSString*)password andDelegate:(id<APIDataProcessorDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        
        self.data = [CoreAPIData new];
        self.data.username = username;
        self.data.password = password;
        
        self.mtgox = [[MTGONXController alloc] init];
        self.mtgox.delegate = self;
        
    }
    return self;
}


- (void)CancelOrder:(NSUInteger)orderIndex
{
    
    MtGoxOpenOrder* order = [self.data.openOrders objectAtIndex:orderIndex];
    
    [self.mtgox startCancelingOrderWithUsername:self.data.username andPassword:self.data.password andOrderId:order.orderID andOrderType:order.type];
    
}

-(void)PlaceOrder:(MtGoxBuySellOrder*)order
{
    // Place order
    [self.mtgox startPlacingOrderWithUsername:self.data.username andPassword:self.data.password andAmount:order.amount andType:order.type andPrice:order.price];
}


# pragma mark -
# pragma mark MtGox4Mac


-(void)gonxController:(MTGONXController*)sender 
      ReceivedBalance:(NSDictionary*)balances
{
    self.data.usersUSDs = [[balances objectForKey:@"usds"] floatValue];
    self.data.usersBTCs = [[balances objectForKey:@"btcs"] floatValue];
    
    [self CompleteUpdate:MTGOX_RECEIVEDBALANCE_TAG];
    
}

-(void)gonxController:(MTGONXController *)sender 
	   ReceivedPrices:(NSDictionary *)prices
{
    NSLog(@"%@", [prices JSONString]);
    self.data.lastBTCtoUSDprice = [[prices objectForKey:@"last"] floatValue];
    self.data.lastBuyPrice = [[prices objectForKey:@"sell"] floatValue];
    self.data.lastSellPrice = [[prices objectForKey:@"buy"] floatValue];

    [self CompleteUpdate:MTGOX_RECEIVEDPRICES_TAG];
}

-(void)gonxController:(MTGONXController*)sender
   ReceivedOpenOrders:(NSArray*)orders
{
    NSLog(@"Open Orders: %@", [orders JSONString]);
    
    self.data.openOrders = nil;
    self.data.openOrders = [[NSMutableArray alloc] initWithCapacity:[orders count]];
    
    for (NSDictionary* order in orders) {
        MtGoxOpenOrder* o = [MtGoxOpenOrder new];
        o.amount = [[order objectForKey:@"amount"] floatValue];
        o.price = [[order objectForKey:@"price"] floatValue];
        o.priority = [[order objectForKey:@"priority"] longLongValue];
        o.date = [[order objectForKey:@"date"] longLongValue];
        o.currency = [order objectForKey:@"currency"];
        o.type = [order objectForKey:@"type"];
        o.orderID = [order objectForKey:@"oid"];
        
        [self.data.openOrders addObject:o];
    }
    
    [self CompleteUpdate:MTGOX_RECEIVEDOPENORDERS_TAG];
}

-(void)gonxControllerPlacedAnOrder:(MTGONXController*)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(RefreshedData:)])
    {
         [self.delegate RefreshedData:self.data];
    }
}

-(void)gonxControllerStoppedGettingPrices:(MTGONXController*)sender
{
    
}

-(void)gonxControllerCouldNotLogin:(MTGONXController*)sender
{
    [self StopAutoRefresh];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(CouldNotLogin)])
    {
        [self.delegate CouldNotLogin];
    }

}

-(void)gonxControllerCanceledOrder:(MTGONXController*)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(RefreshedData:)])
    {
        [self.delegate RefreshedData:self.data];
    }
}


@end
