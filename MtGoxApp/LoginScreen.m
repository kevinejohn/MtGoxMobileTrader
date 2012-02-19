//
//  LoginScreen.m
//  MtGoxApp
//
//  Created by Kevin Johnson on 12/2/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "LoginScreen.h"
#import "BuyAndSell.h"

@implementation LoginScreen
@synthesize usernameField;
@synthesize passwordField;


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag == 1) {
        [self.passwordField becomeFirstResponder];
    }
    else if (textField.tag == 2) {
        BuyAndSell* view = [[BuyAndSell alloc] initWithNibName:@"BuyAndSell" bundle:nil];
        
        view.api = [[APIDataProcessor alloc] initWithUsername:self.usernameField.text andPassword:self.passwordField.text andDelegate:view];
        
        self.usernameField.text = @"";
        self.passwordField.text = @"";
        [self.navigationController pushViewController:view animated:YES];
    }
    
    return YES;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:nil
                                                                                action:nil];
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
}

- (void)viewDidUnload
{
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
