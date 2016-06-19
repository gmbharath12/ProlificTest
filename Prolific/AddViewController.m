//
//  AddViewController.m
//  Prolific
//
//  Created by Bharath G M on 6/18/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import "AddViewController.h"
#import <UIAlertController+Blocks.h>

@implementation AddViewController

- (void)viewDidLoad {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction:)] ;

}

- (IBAction)submitButtonAction:(id)sender {
    
}

- (void)doneButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
