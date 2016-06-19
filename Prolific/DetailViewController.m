//
//  DetailViewController.m
//  Prolific
//
//  Created by Bharath G M on 6/18/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import "DetailViewController.h"
#import "Book.h"

@implementation DetailViewController

- (void)viewDidLoad {
    NSLog(@"Book Details %@", self.book);
    //\ToDo: Update constraints when one of them is null?
    self.bookTitle.text = (!([[self book] title] == (NSString*)[NSNull null])) ? [[self book] title] : nil;
    self.author.text = (!([[self book] author] == (NSString*)[NSNull null])) ? [[self book] author] : nil;
    NSLog(@"publisher %@", [[self book] publisher]);
    self.publisher.text = (!([[self book] publisher] == (NSString*)[NSNull null])) ? [NSString stringWithFormat:@"Publisher: %@",[[self book] publisher]] : nil;
    self.tags.text = (!([[self book] categories] == (NSString*)[NSNull null])) ? [NSString stringWithFormat:@"Tags: %@", [[self book] categories]] : nil;
    NSString *checkedOutAt = (!([[self book] lastCheckedOut] == (NSString*)[NSNull null])) ? [[self book] lastCheckedOut] : nil;
    self.lastCheckedBy.text = (!([[self book] lastCheckedOutBy] == (NSString*)[NSNull null])) ? [[self book] lastCheckedOutBy] : nil;
    if (checkedOutAt) {
        self.lastCheckedBy.text = [NSString stringWithFormat:@"%@ @ %@",self.lastCheckedBy.text, checkedOutAt];
    }
}

- (IBAction)share:(id)sender {
    NSString *bookTitle = [NSString stringWithFormat:@"Title: %@",[[self book] title]];
    NSString *author = [NSString stringWithFormat:@"by: %@",[[self book] author]];
    NSArray *objectsToShare = @[bookTitle, author];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypeMail,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    activityController.excludedActivityTypes = excludeActivities;
    [self presentViewController:activityController animated:YES completion:nil];
}

     
- (IBAction)checkOutButtonAction:(id)sender {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CheckOut"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CheckOutViewController *checkOutViewController = [navigationController viewControllers][0];
        checkOutViewController.delegate = self;
    }
}


- (void)checkOutUserName:(NSString*)userName {
    NSString  *baseURL = @"http://prolific-interview.herokuapp.com";
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSZZZZ"]; //yyyy-MM-dd HH:mm:ss zzz
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    self.sessionManager =   [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{@"author": self.book.author,
                                 @"categories": self.book.categories,
                                 @"id": self.book.bookID,
                                 @"lastCheckedOut":[dateFormatter stringFromDate:[NSDate date]],
                                 @"lastCheckedOutBy":userName,
                                 @"publisher":self.book.publisher,
                                 @"title":self.book.title,
                                 @"url":self.book.url};
    [self.sessionManager PUT:[NSString stringWithFormat:@"/5764751072b55d00097eab85%@",self.book.url] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.title = @"Book updated";
        NSLog(@"Response Object %@", (NSDictionary*)responseObject);
        self.lastCheckedBy.text = [NSString stringWithFormat:@"%@ @ %@",[responseObject valueForKey:@"lastCheckedOutBy"], [responseObject valueForKey:@"lastCheckedOut"]];
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"\n ERROR \n %@",error.userInfo);
    }];
}

@end
