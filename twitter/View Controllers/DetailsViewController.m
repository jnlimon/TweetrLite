//
//  DetailsViewController.m
//  twitter
//
//  Created by Santino L Ramos on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
    self.dateLabel.text = self.tweet.createdAtString;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
    self.tweetBodyLabel.text = self.tweet.text;
    self.retweetButton.selected = self.tweet.retweeted;
    self.favoriteButton.selected = self.tweet.favorited;
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.profileImage setImageWithURL:url];
    [self setProfilePic:self.tweet.user.profilePicture];

    // Do any additional setup after loading the view.
}

- (void)setProfilePic:(NSString*)path{
    NSURL *url = [NSURL URLWithString:path];
    [self.profileImage setImageWithURL:url];
}
- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted == false){
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                 [self displayError:@"Retweet"];
             }
             else{
                 self.tweet.retweeted = true;
                 self.tweet.retweetCount += 1;
                 [self refreshData];
             }
         }];
    }
    else{
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                 [self displayError:@"Unretweet"];
             }
             else{
                 self.tweet.retweeted = false;
                 self.tweet.retweetCount -= 1;
                 [self refreshData];
             }
         }];
    }
}
- (IBAction)didTapFavorite:(id)sender {
    if(self.tweet.favorited == false){
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                 [self displayError:@"Favorite"];
             }
             else{
                 self.tweet.favorited = true;
                 self.tweet.favoriteCount += 1;
                 [self refreshData];
             }
         }];
    }
    else{
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                 [self displayError:@"Unfavorite"];
             }
             else{
                 self.tweet.favorited = false;
                 self.tweet.favoriteCount -= 1;
                 [self refreshData];
             }
         }];
    }
}

- (void)refreshData{
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
    self.favoriteButton.selected = self.tweet.favorited;
    self.retweetButton.selected = self.tweet.retweeted;
}

- (void) displayError:(NSString*)action{
    NSString *errTitle = [NSString stringWithFormat:@"%@ Failed", action];
    NSString *errMessage =[NSString stringWithFormat:@"Your %@ action could not be processed", action];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:errTitle message:errMessage preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    // add the 'Ok' action to the alertController
    [alert addAction:OkAction];
    
    [[[[UIApplication sharedApplication] keyWindow]rootViewController]presentViewController:alert animated:true completion:^{
    }];
    
}

#pragma mark - Navigation


@end
