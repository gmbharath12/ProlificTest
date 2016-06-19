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
    self.lastCheckedBy.text = (!([[self book] lastCheckedOutBy] == (NSString*)[NSNull null])) ? [[self book] lastCheckedOutBy] : nil;
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

@end
