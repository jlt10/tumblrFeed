//
//  PhotosViewController.m
//  tumblrFeed
//
//  Created by Jamie Tan and Roesha Nigos on 6/27/18.
//  Copyright © 2018 jamietan roeshanigos. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import "UIKit+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *photoView;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    // AFNetworking extension to UIImageView that allows
    // specifying a URL for the image
    
    self.photoView.dataSource = self;
    self.photoView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    //making a request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    //session is.....
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    //managing the request
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            //calling localized method to variable named error
        }
        else {
            //making dictionary flood to screen
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // TODO: Get the posts and store in posts property
            // TODO: Reload the table view
            // Get the dictionary from the response key
            NSDictionary *responseDictionary = dataDictionary[@"response"];
            // Store the returned array of dictionaries in our posts property
            self.posts = responseDictionary[@"posts"];
            
            
            [self.photoView reloadData];
//            self.photoView.rowHeight = 240;
        }
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//table view method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


//initializing a new cell into range and getting the photo for it
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];

    NSDictionary *post = self.posts[indexPath.row];
    NSArray *photos = post[@"photos"];
    if (photos) {
        // 1. Get the first photo in the photos array
        NSDictionary *photo = photos[0];
        
        // 2. Get the original size dictionary from the photo
        NSDictionary *originalSize =  photo[@"original_size"];
        
        // 3. Get the url string from the original size dictionary
        NSString *urlString = originalSize[@"url"];
        
        // 4. Create a URL using the urlString
        NSURL *url = [NSURL URLWithString:urlString];
        [cell.imageUniqueView setImageWithURL:url];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240;
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
