//
//  HomeScreen.h
//  MtGoxApp
//
//  Created by Kevin Johnson on 11/30/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsScreen : UIViewController
- (IBAction)GetData:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *tickerLabel;
@property (strong, nonatomic) IBOutlet UILabel *volumeLabel;
@property (strong, nonatomic) IBOutlet UILabel *averageLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowLabel;
@property (strong, nonatomic) IBOutlet UILabel *highLabel;
@property (strong, nonatomic) NSMutableData* responseData;

@end
