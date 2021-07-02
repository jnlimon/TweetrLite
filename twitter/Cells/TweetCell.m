//
//  TweetCell.m
//  twitter
//
//  Created by Santino L Ramos on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

- (void)refreshData{
    self.retweetedCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
    self.favoritedCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
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

@end
