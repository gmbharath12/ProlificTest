//
//  DetailViewController.h
//  Prolific
//
//  Created by Bharath G M on 6/18/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *publisher;
@property (weak, nonatomic) IBOutlet UILabel *tags;
@property (weak, nonatomic) IBOutlet UILabel *lastCheckedOut;
@property (weak, nonatomic) IBOutlet UILabel *lastCheckedBy;
@property (weak, nonatomic) IBOutlet UIButton *checkOutButton;

- (IBAction)share:(id)sender;



@end
