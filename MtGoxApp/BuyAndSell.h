//
//  BuyAndSell.h
//  MtGoxApp
//
//  Created by Kevin Johnson on 12/2/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGONXController.h"
#import "APIDataProcessor.h"

@interface BuyAndSell : UIViewController <APIDataProcessorDelegate, UIActionSheetDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *balanceUSDLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *balanceBTCLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lastBTCpriceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lastBuyPriceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lastSellPriceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *totalWorthLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lastUpdatedLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *noPendingOrdersLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *customBuySellTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UIPickerView *sellPicker;
@property (unsafe_unretained, nonatomic) IBOutlet UIPickerView *buyPicker;
@property (strong, nonatomic) NSMutableArray* tableItems;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MtGoxBuySellOrder* buyOrSellOrder;
@property (strong, nonatomic) NSMutableArray* pickerViewValues;
@property (strong, nonatomic) APIDataProcessor* api;
@property NSUInteger pickerViewSellCount;
@property NSUInteger pickerViewBuyCount;
- (IBAction)sellBTCButton:(id)sender;
- (IBAction)buyBTCButton:(id)sender;

@end
