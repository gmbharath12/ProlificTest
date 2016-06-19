//
//  AddViewController.h
//  Prolific
//
//  Created by Bharath G M on 6/18/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;
@property (weak, nonatomic) IBOutlet UITextField *publisherTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryField;
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

- (IBAction)submitButtonAction:(id)sender;

@end
