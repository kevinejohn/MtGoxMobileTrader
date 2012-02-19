//
//  BuyAndSell.m
//  MtGoxApp
//
//  Created by Kevin Johnson on 12/2/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BuyAndSell.h"
#import "DetailsScreen.h"

@implementation BuyAndSell
@synthesize tableView=_tableView;
@synthesize sellPicker;
@synthesize buyPicker;
@synthesize lastBuyPriceLabel;
@synthesize lastSellPriceLabel;
@synthesize totalWorthLabel;
@synthesize lastUpdatedLabel;
@synthesize balanceUSDLabel;
@synthesize balanceBTCLabel;
@synthesize lastBTCpriceLabel;
@synthesize tableItems;
@synthesize buyOrSellOrder;
@synthesize noPendingOrdersLabel;
@synthesize customBuySellTextField;
@synthesize pickerViewValues;
@synthesize api;
@synthesize pickerViewBuyCount, pickerViewSellCount;


-(void) RefreshedData:(CoreAPIData*)data
{
    self.lastUpdatedLabel.text = data.lastUpdated;
    
    
    self.tableItems = data.openOrders;
    [self.tableView reloadData];
    self.noPendingOrdersLabel.hidden = [self.tableItems count] > 0 ? YES : NO;
    
    
    self.lastBTCpriceLabel.text = [NSString stringWithFormat:@"%f USD", data.lastBTCtoUSDprice];
    self.totalWorthLabel.text = [NSString stringWithFormat:@"$%f Total", data.totalWorth];
    

    self.lastBuyPriceLabel.text = [NSString stringWithFormat:@"%f USD", data.lastBuyPrice];
    self.lastSellPriceLabel.text = [NSString stringWithFormat:@"%f USD", data.lastSellPrice];
    
    self.balanceUSDLabel.text = [NSString stringWithFormat:@"%f USD", data.usersUSDs];
    self.balanceBTCLabel.text = [NSString stringWithFormat:@"%f BTC", data.usersBTCs];
    
    
    if (self.pickerViewBuyCount != MIN(999, ceilf(data.usersUSDs))) {
        self.pickerViewBuyCount = MIN(999, ceilf(data.usersUSDs));
        [self.buyPicker reloadComponent:0];
        [self.buyPicker reloadInputViews];
    }
    
    if (self.pickerViewSellCount != MIN(999,ceilf(data.usersBTCs * data.lastSellPrice))) {
        self.pickerViewSellCount = MIN(999,ceilf(data.usersBTCs * data.lastSellPrice));
        [self.sellPicker reloadComponent:0];
        [self.sellPicker reloadInputViews];
    }    
}

-(void)CouldNotLogin
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -
#pragma UIPickerView


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    /*
    NSInteger num = 0;
    
    if (pickerView.tag == 1) {
        // Sell
        num = ceilf(self.userInfo.usersBTCs * self.userInfo.lastSellPrice);
    }
    else if (pickerView.tag == 2) {
        // Buy
        num = ceilf(self.userInfo.usersUSDs);
    }
    */
    return pickerView.tag == 1 ? self.pickerViewSellCount : self.pickerViewBuyCount;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (row == ([pickerView numberOfRowsInComponent:0] - 1)) {
        static NSString* maxString = @"Max";
        return maxString;
    }
    else {
        static NSUInteger count = 1;
        
        while ([self.pickerViewValues count] <= row) {
            [self.pickerViewValues addObject:[NSString stringWithFormat:@"$%d", count++]];
            //NSLog(@"Created: %@", [self.pickerViewValues lastObject]);
        }
        
        
        NSLog(@"Returning row: %d", row);
        return [self.pickerViewValues objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}



#pragma mark -
#pragma mark - TableView

/// Sets table view cell height.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [self.tableItems count];
}  


/// Callback when user selects a cell in the table view.
- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    // Deselect cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:kCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;// UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setLineBreakMode:UILineBreakModeTailTruncation];
        [cell.textLabel setNumberOfLines:2];
        [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    }
    
    MtGoxOpenOrder* order = [self.tableItems objectAtIndex:[indexPath row]];
    
    if ([order.type intValue] == 1) {
        // Sell order
        
        cell.textLabel.text = [NSString stringWithFormat:@"Sell %f BTC\n at $%.6f", order.amount, order.price];
        //cell.detailTextLabel.text = @"Test";
        
    }
    else if ([order.type intValue] == 2) {
        // Buy order 
        cell.textLabel.text = [NSString stringWithFormat:@"Buy %f BTC\n at $%.6f", order.amount, order.price];
    }
    else {
        cell.textLabel.text = @"Could not read order";
    }
    
    return cell;    
}


/// Callback when user deletes a cell.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.api CancelOrder:[indexPath row]];
    
    [self.tableItems removeObjectAtIndex:[indexPath row]];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
}



#pragma mark -
#pragma mark - View lifecycle

- (IBAction)DetailsScreen:(id)sender {
    DetailsScreen* view = [[DetailsScreen alloc] initWithNibName:@"HomeScreen" bundle:nil];
    [self.navigationController pushViewController:view animated:YES];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.mtgox = [[MTGONXController alloc] init];
        //self.mtgox.delegate = self;
        
        self.navigationItem.title = @"MtGox Trader";
        
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Details"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(DetailsScreen:)];
        
        self.pickerViewValues = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    //[self StopAutoRefresh];
    
    [self setBalanceUSDLabel:nil];
    [self setBalanceBTCLabel:nil];
    [self setSellPicker:nil];
    [self setBuyPicker:nil];
    [self setLastBTCpriceLabel:nil];
    [self setLastBuyPriceLabel:nil];
    [self setLastSellPriceLabel:nil];
    [self setTotalWorthLabel:nil];
    [self setLastUpdatedLabel:nil];
    [self setTableView:nil];
    [self setNoPendingOrdersLabel:nil];
    [self setCustomBuySellTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:(BOOL)animated];    // Call the super class implementation.
    // Usually calling super class implementation is done before self class implementation, but it's up to your application.
    
    [self.api StopAutoRefresh];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.api StartAutoRefresh];
    //[self StartAutoRefresh];
}


#pragma mark -
#pragma mark UIActionSheet


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && self.buyOrSellOrder != nil) {
        // Place order
        [self.api PlaceOrder:self.buyOrSellOrder];
    }
    else if (buttonIndex == 1) {
        // Cancel
        
    }
    self.buyOrSellOrder = nil;
    self.customBuySellTextField.text = @"";
    
}

- (void)Confirm:(NSInteger)tag withHeaderText:(NSString*)headerText andButtonText:(NSString*)btnText
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:btnText, nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.alpha=1.0;
    actionSheet.tag = tag;

    [actionSheet setTitle:headerText];

    [actionSheet showInView:self.view]; 
    //[actionSheet release];
}

- (BOOL) textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}

- (float)GetSellBuyPrice:(float)lastPrice
{
    float returnPrice = lastPrice;
    if ([self.customBuySellTextField.text length] > 0) {
        returnPrice = [self.customBuySellTextField.text floatValue];
    }
    return returnPrice;
}


- (IBAction)sellBTCButton:(id)sender {
    NSString* btnText;
    float dollars = [self.sellPicker selectedRowInComponent:0] + 1;
    float btcSellPrice = [self GetSellBuyPrice:[self.api getLastSellPrice]];
    float btcQuanitity = dollars / btcSellPrice;
    float usersBTCs = [self.api getUsersBTCs];
    
    if (btcQuanitity > usersBTCs) {
        btcQuanitity = usersBTCs;
    }

    btnText = [NSString stringWithFormat:@"Sell %f BTC at $%f/BTC", btcQuanitity, btcSellPrice];
    
    self.buyOrSellOrder = [MtGoxBuySellOrder new];
    self.buyOrSellOrder.amount = [NSString stringWithFormat:@"%f", btcQuanitity];
    self.buyOrSellOrder.type = @"sell";
    self.buyOrSellOrder.price = [NSString stringWithFormat:@"%f", btcSellPrice];
    
    [self Confirm:1 withHeaderText:btnText andButtonText:@"Sell"];
     
    
}

- (IBAction)buyBTCButton:(id)sender {
    NSString* btnText;
    float dollars = [self.buyPicker selectedRowInComponent:0] + 1;
    float btcBuyPrice = [self GetSellBuyPrice:[self.api getLastBuyPrice]];
    float btcQuanitity = dollars / btcBuyPrice;
    float usersUSDs = [self.api getUsersUSDs];
    
    if (dollars > usersUSDs) {
        dollars = usersUSDs;
        btcQuanitity = dollars / btcBuyPrice;
    }
    
    btnText = [NSString stringWithFormat:@"Buy %f BTC at $%f/BTC", btcQuanitity, btcBuyPrice];
    
    
    self.buyOrSellOrder = [MtGoxBuySellOrder new];
    self.buyOrSellOrder.amount = [NSString stringWithFormat:@"%f", btcQuanitity];
    self.buyOrSellOrder.type = @"buy";
    self.buyOrSellOrder.price = [NSString stringWithFormat:@"%f", btcBuyPrice];
    
    [self Confirm:2 withHeaderText:btnText andButtonText:@"Buy"];
    
}

@end
