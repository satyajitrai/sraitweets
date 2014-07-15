//
//  ComposeViewController.m
//  sraitweets
//
//  Created by Satyajit Rai on 7/3/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *countButton;
@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.countButton = [[UIBarButtonItem alloc] initWithTitle:@"0" style:UIBarButtonItemStylePlain target:self action:@selector(ignore)];
    self.countButton.tintColor = [UIColor whiteColor];
    self.countButton.enabled = NO;
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(tweet)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects: tweetButton, self.countButton, nil];
    
    [self updateView:self.userInfo];
    [self.tweetText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView:(UserProfile*)userInfo {
    self.nameLabel.text = userInfo.name;
    self.usernameLabel.text = userInfo.screenName;
    [self.userImage setImageWithURLRequest:[NSURLRequest requestWithURL: userInfo.profileURL] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.userImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        self.navigationItem.prompt = @"Failed to load profile image";
        NSLog(@"Failed to get profile view");
    }];
    self.tweetText.delegate = self;
}

- (void) cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) tweet {
    if ([self.tweetText.text isEqualToString:@""]) {
        self.navigationItem.prompt = @"Can't post and empty tweet!";
    }
    else {
        self.tweetText.editable = NO;
        [[TwitterClient instance] updateStatus:self.tweetText.text withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            Tweet *t = [Tweet tweetFromTweet:responseObject];
            self.newTweetHandler(t);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.navigationItem.prompt = @"Unable to post tweet";
        }];
    }
}

- (void)ignore {
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.countButton.title = [NSString stringWithFormat:@"%d", textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(text.length == 0)
    {
        if(textView.text.length != 0)
        {
            return YES;
        }
    }
    else if(textView.text.length > 139)
    {
        return NO;
    }
    return YES;
}

@end
