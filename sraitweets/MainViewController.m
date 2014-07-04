//
//  MainViewController.m
//  sraitweets
//
//  Created by Satyajit Rai on 6/28/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "MainViewController.h"
#import "TwitterClient.h"

@interface MainViewController ()

- (IBAction)onLoginButton:(UIButton *)sender;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(UIButton *)sender {
    [[TwitterClient instance] login];
}
@end
