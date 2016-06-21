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
    //\ToDo: Update constraints when one of them is null?
    self.bookTitle.text = (!([[self book] title] == (NSString*)[NSNull null])) ? [[self book] title] : nil;
    self.author.text = (!([[self book] author] == (NSString*)[NSNull null])) ? [NSString stringWithFormat:@"Author: %@",[[self book] author]] : nil;
    self.publisher.text = (!([[self book] publisher] == (NSString*)[NSNull null])) ? [NSString stringWithFormat:@"Publisher: %@",[[self book] publisher]] : nil;
    self.tags.text = (!([[self book] categories] == (NSString*)[NSNull null])) ? [NSString stringWithFormat:@"Tags: %@", [[self book] categories]] : nil;
    NSString *checkedOutAt = (!([[self book] lastCheckedOut] == (NSString*)[NSNull null])) ? [[self book] lastCheckedOut] : nil;
    self.lastCheckedBy.text = (!([[self book] lastCheckedOutBy] == (NSString*)[NSNull null])) ? [[self book] lastCheckedOutBy] : nil;
    if (checkedOutAt) {
       NSString *formattedString =  [self formatDateForAString:checkedOutAt];
        self.lastCheckedBy.text = [NSString stringWithFormat:@"%@ @ %@",self.lastCheckedBy.text, formattedString];
    }
}


- (NSString*)formatDateForAString:(NSString*)checkedOutAt {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    NSString *dateString = checkedOutAt;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSString *updatedString = [dateFormatter stringFromDate:date];
    return updatedString;
}

/**
 Book details can be shared to Twitter/Facebook
 */
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
                                   UIActivityTypePostToVimeo,
                                   ];
    activityController.excludedActivityTypes = excludeActivities;
    [self presentViewController:activityController animated:YES completion:nil];
}


- (IBAction)checkOutButtonAction:(id)sender {
    //handled through storyboard
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CheckOut"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CheckOutViewController *checkOutViewController = [navigationController viewControllers][0];
        checkOutViewController.delegate = self;
    }
}


#pragma mark CheckOutViewControllerDelegate
- (void)checkOutUserName:(NSString*)userName {
    if (!dateFormatter) {
        dateFormatter=[[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.zzz"]; //yyyy-MM-dd HH:mm:ss zzz date format
    //    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    self.sessionManager =   [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
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
        //        NSLog(@"Response Object %@", (NSDictionary*)responseObject);
        NSString *updatedString =  [self formatDateForAString:[responseObject valueForKey:@"lastCheckedOut"]];
        self.lastCheckedBy.text = [NSString stringWithFormat:@"%@ @ %@",[responseObject valueForKey:@"lastCheckedOutBy"], updatedString];
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"\n ERROR \n %@",error.userInfo);
        [UIAlertController showAlertInViewController:self
                                           withTitle:@"Error"
                                             message:@"There's an error in check out. Please try again"
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:@"OK"
                                   otherButtonTitles:nil
                                            tapBlock:nil];
    }];
}

@end
