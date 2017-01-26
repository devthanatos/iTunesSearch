//
//  MASearchMediaTableViewController.m
//  iTunesSearch
//
//  Created by Michael Akopyants on 26/01/2017.
//  Copyright © 2017 devthanatos. All rights reserved.
//

#import "MASearchMediaTableViewController.h"
#import "MAMediaDetailTableViewController.h"
#import "MAMediaTrackTableViewCell.h"
#import "MAMediaAPI.h"

@interface MASearchMediaTableViewController () <UISearchBarDelegate>
@property (strong, nonatomic) NSArray * mediaItems;
@property (weak,nonatomic) UISearchBar * searchMediaBar;
@end

@implementation MASearchMediaTableViewController

#pragma mark UI 

- (UISearchBar*)searchBar
{
    UISearchBar * searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44.0f);
    return searchBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchMediaBar = [self searchBar];
    self.searchMediaBar.delegate = self;
    self.tableView.tableHeaderView = self.searchMediaBar;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:[MAMediaTrackTableViewCell class] forCellReuseIdentifier:[MAMediaTrackTableViewCell reuseIdentifier]];
    self.title = @"Search iTunes songs";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UISearchBarDelegate>

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[MAMediaAPI sharedAPI] searchMediaQuery:searchBar.text completion:^(NSArray * results, NSError* error){
        
        self.mediaItems = results;
        [self.tableView reloadData];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.searchMediaBar resignFirstResponder];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.mediaItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MAMediaTrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MAMediaTrackTableViewCell reuseIdentifier]];
    if (!cell)
    {
        cell = [[MAMediaTrackTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:[MAMediaTrackTableViewCell reuseIdentifier]];
    }
    
    NSDictionary* mediaInfo = [self.mediaItems objectAtIndex:indexPath.row];
    
    [self configureCell:cell withDictionary:mediaInfo];

    return cell;
}


- (void)configureCell:(MAMediaTrackTableViewCell*)cell withDictionary:(NSDictionary *)dictionary
{
    NSString * trackInfo = [dictionary objectForKey:@"artistName"];
    if ([dictionary objectForKey:@"trackCensoredName"])
    {
        trackInfo = [trackInfo stringByAppendingFormat:@" - %@",[dictionary objectForKey:@"trackCensoredName"]];
    }
    if ([dictionary objectForKey:@"collectionCensoredName"])
    {
        trackInfo = [trackInfo stringByAppendingFormat:@" (%@)",[dictionary objectForKey:@"collectionCensoredName"]];
    }
    NSLog(@"%@",[dictionary objectForKey:@"artistName"]);
    cell.textLabel.text = trackInfo;
    
    cell.imageView.image = [UIImage imageNamed:@"placeholder"];
    __weak typeof(cell) weakCell = cell;
    
    NSURL * artworkUrl = [NSURL URLWithString:[dictionary objectForKey:@"artworkUrl100"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(){
        if (artworkUrl)
        {
            UIImage * artwork = [UIImage imageWithData:[NSData dataWithContentsOfURL:artworkUrl]];
            if (artwork)
            {
                dispatch_async(dispatch_get_main_queue(), ^(){
                    __strong typeof(cell) strongCell = weakCell;
                    strongCell.imageView.image = artwork;
                });
            }
        }
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * info = [self.mediaItems objectAtIndex:indexPath.row];
    MAMediaDetailTableViewController * mediaDetail = [[MAMediaDetailTableViewController alloc] init];
    mediaDetail.mediaInfo = info;
    MAMediaTrackTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    mediaDetail.artworkImage = cell.imageView.image;
    [self.navigationController pushViewController:mediaDetail animated:YES];
    
}

@end
