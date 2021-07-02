//
//  ComposeViewController.m
//  twitter
//
//  Created by Santino L Ramos on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.profileView setImageWithURL:url];
    
    //gives text box curved edges
    [self.composeTextView.layer setBorderColor: [[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0] CGColor]];
    [self.composeTextView.layer setBorderWidth: 2.0];
    [self.composeTextView.layer setCornerRadius:8.0f];
    self.composeTextView.delegate = self;
}

- (IBAction)didTapTweet:(id)sender {
    [[APIManager shared] postStatusWithText:self.composeTextView.text completion:^(Tweet *tweet, NSError *error ) {
        if (error) {
            [self displayError:error.localizedDescription];
            
        } else {
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)displayError:(NSString*)err {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Post Failed" message:err preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    // add the 'Ok' action to the alertController
    [alert addAction:OkAction];
    
    [[[[UIApplication sharedApplication] keyWindow]rootViewController]presentViewController:alert animated:true completion:^{
    }];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 140;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.composeTextView.text stringByReplacingCharactersInRange:range withString:text];

    self.characterCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)newText.length];

    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
}

#pragma mark - Navigation

@end
