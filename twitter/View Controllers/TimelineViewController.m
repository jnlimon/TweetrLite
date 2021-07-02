//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchTweets{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = (NSMutableArray*) tweets;
            [self.tableView reloadData];
            
        } else {
            [self displayError:error.localizedDescription];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logOut:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *tweetCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    tweetCell.tweet = tweet;
    tweetCell.nameLabel.text = tweet.user.name;
    tweetCell.screenNameLabel.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
    tweetCell.createdAtLabel.text = tweet.createdAtString;
    tweetCell.retweetedCountLabel.text = [NSString stringWithFormat:@"%d",tweet.retweetCount];
    tweetCell.favoritedCountLabel.text = [NSString stringWithFormat:@"%d",tweet.favoriteCount];
    tweetCell.tweetLabel.text = tweet.text;
    tweetCell.retweetButton.selected = tweet.retweeted;
    tweetCell.favoriteButton.selected = tweet.favorited;
    [self setProfileImage:tweet.user.profilePicture:tweetCell];
    
    return tweetCell;
}

- (void)didTweet:(Tweet *)tweet{
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (void)setProfileImage:(NSString*)path:(TweetCell*)tweetCell{
    NSURL *url = [NSURL URLWithString:path];
    [tweetCell.profileImage setImageWithURL:url];
}

- (void) displayError:(NSString*)err{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Load Tweets"message:err preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self fetchTweets];
    }];
    // add the 'try again' action to the alertController
    [alert addAction:tryAgainAction];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier  isEqual: @"compose"] ){
        //pass personal profile to ComposeViewController to display profile picture
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    if([segue.identifier  isEqual: @"details"]){
        //pass tweet to DetailsViewController to display tweet details
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
        DetailsViewController *detailsController = [segue destinationViewController];
        detailsController.tweet = tweet;
    }
    
    

}



@end
