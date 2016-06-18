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

}

- (IBAction)share:(id)sender {
    NSString *bookTitle = @"Title: The Core iOS 6 Developer's Cookbook";
    NSString *author = @"by Erica Sadun";
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

@end
