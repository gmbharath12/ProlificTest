//
//  CheckOutViewController.m
//  Prolific
//
//  Created by Bharath G M on 6/18/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import "CheckOutViewController.h"

@implementation CheckOutViewController

- (IBAction)doneAction:(id)sender {
    if (self.nameTextField.text.length > 0) {
        [self.delegate checkOutUserName:self.nameTextField.text];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
