//
//  HomeScreen.m
//  MtGoxApp
//
//  Created by Kevin Johnson on 11/30/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "DetailsScreen.h"

@implementation DetailsScreen
@synthesize volumeLabel;
@synthesize averageLabel;
@synthesize lowLabel;
@synthesize highLabel;
@synthesize tickerLabel, responseData;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    JSONDecoder* decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
    NSDictionary* obj = [decoder objectWithData:self.responseData];
    if (obj != nil) {
        NSLog(@"%@", [obj JSONString]);
        
        // Parse camps from JSON
        NSDictionary* ticker = [obj objectForKey:@"ticker"];
        if (ticker != nil) {
            self.tickerLabel.text = [NSString stringWithFormat:@"$%f / BTC", [[ticker objectForKey:@"last"] floatValue]];
            self.volumeLabel.text = [NSString stringWithFormat:@"%f BTC / 24 Hours", [[ticker objectForKey:@"vol"] floatValue]];
            self.averageLabel.text = [NSString stringWithFormat:@"$%f / BTC", [[ticker objectForKey:@"avg"] floatValue]];
            self.lowLabel.text = [NSString stringWithFormat:@"$%f / BTC", [[ticker objectForKey:@"low"] floatValue]];
            self.highLabel.text = [NSString stringWithFormat:@"$%f / BTC", [[ticker objectForKey:@"high"] floatValue]];
        }
    }
}



- (void) DownloadData
{
    NSURL *url = [NSURL URLWithString:@"http://mtgox.com/api/0/data/ticker.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url  
                                                           cachePolicy: NSURLRequestReloadIgnoringCacheData    
                                                       timeoutInterval: 10.0];     
        
    NSURLConnection* connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (connection) {
        responseData = [NSMutableData data];
    }
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self DownloadData];
}

- (void)viewDidUnload
{
    [self setTickerLabel:nil];
    [self setVolumeLabel:nil];
    [self setAverageLabel:nil];
    [self setLowLabel:nil];
    [self setHighLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)GetData:(id)sender {
    [self DownloadData];
}
@end
