//
//  MAMediaDetailTableViewController.m
//  iTunesSearch
//
//  Created by Michael Akopyants on 26/01/2017.
//  Copyright © 2017 devthanatos. All rights reserved.
//

#import "MAMediaDetailTableViewController.h"

@interface MAMediaDetailTableViewController ()
@property (weak, nonatomic) UIImageView * artworkFullsizeImageView;
@property (strong, nonatomic) NSArray * cells;
@end

@implementation MAMediaDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView * artwork = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds))];
    
    self.artworkFullsizeImageView = artwork;
    self.tableView.tableHeaderView = self.artworkFullsizeImageView;
    self.artworkFullsizeImageView.contentMode = UIViewContentModeScaleToFill;
    self.artworkFullsizeImageView.image = self.artworkImage;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.cells = @[
                   @{@"title":[@"Track: " stringByAppendingString:[self.mediaInfo objectForKey:@"trackCensoredName"]],
                     @"type": @"string",
                     },
                   @{@"title":[@"Artist: " stringByAppendingString:[self.mediaInfo objectForKey:@"trackCensoredName"]],
                     @"type": @"string",
                     },
                   @{@"title":[@"Album: " stringByAppendingString:[self.mediaInfo objectForKey:@"trackCensoredName"]],
                     @"type": @"string",
                     },
                   @{@"title":[@"Genre: " stringByAppendingString:[self.mediaInfo objectForKey:@"primaryGenreName"]],
                     @"type": @"string",
                     },
                   @{@"title":[@"Release: " stringByAppendingString:[self.mediaInfo objectForKey:@"releaseDate"]],
                     @"type": @"date",
                     }
                   ];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.cells.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary * info = [self.cells objectAtIndex:indexPath.row];
    NSString * text = [info objectForKey:@"title"];
    
    cell.textLabel.text = text;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
