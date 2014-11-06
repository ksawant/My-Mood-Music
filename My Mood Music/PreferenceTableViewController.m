//
//  PreferenceTableViewController.m
//  My Mood Music
//
//  Created by Kartik Sawant on 10/25/14.
//  Copyright (c) 2014 Kartik Sawant. All rights reserved.
//

#import "PreferenceTableViewController.h"

@interface PreferenceTableViewController ()

@end

@implementation PreferenceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://soundcloud.com/connect?state=SoundCloud_Dialog_8d64e&client_id=1ca7a448b3e22d42b5b650ba1c009e7d&redirect_uri=mymoodmusic://soundcloud&response_type=code_and_token&scope=non-expiring"]];
    self.tableView.editing = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Classical";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"Country";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"Dubstep";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"Hip Hop";
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"Metal";
    }
    if (indexPath.row == 5) {
        cell.textLabel.text = @"Pop";
    }
    if (indexPath.row == 6) {
        cell.textLabel.text = @"Punk";
    }
    if (indexPath.row == 7) {
        cell.textLabel.text = @"R&B";
    }
    if (indexPath.row == 8) {
        cell.textLabel.text = @"Rap";
    }
    if (indexPath.row == 9) {
        cell.textLabel.text = @"Reggae";
    }
    if (indexPath.row == 10) {
        cell.textLabel.text = @"Rock";
    }
    if (indexPath.row == 11) {
        cell.textLabel.text = @"Soul";
    }
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

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    //[tableView cellForRowAtIndexPath:fromIndexPath].textLabel.text
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
