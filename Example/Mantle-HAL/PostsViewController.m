//
//  PostsViewController.m
//  Mantle-HAL
//
//  Created by Simon Rice on 13/09/2014.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "MTLHALResource.h"

#import "Post.h"
#import "PostsViewController.h"

@interface PostsViewController ()

@property (nonatomic, strong) NSArray *posts;

@end

@implementation PostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *baseURL = [NSURL URLWithString:@"http://haltalk.herokuapp.com"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    [SVProgressHUD show];
    
    [manager GET:@"/posts/latest" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MTLHALResource *resource = [MTLJSONAdapter modelOfClass:MTLHALResource.class fromJSONDictionary:responseObject error:nil];
        
        self.posts = [resource resourcesForRelation:@"ht:post"];
        NSLog(@"%@", [self.posts[0] extendedHrefForRelation:@"self"]);
        
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    } failure:nil];
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
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postRow" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.row];
    cell.textLabel.text = post.content;
    
    MTLHALLink *authorLink = post.links[@"ht:author"][0];
    if (authorLink && authorLink.title) {
        cell.detailTextLabel.text = authorLink.title;
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
