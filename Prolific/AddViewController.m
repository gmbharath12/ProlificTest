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
    [self.view endEditing:YES];
    if (!self.titleTextField.text.length || !self.authorTextField.text.length) {
        [UIAlertController showAlertInViewController:self
                                           withTitle:@""
                                             message:@"Please enter Title or Author's name of a book"
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:@"OK"
                                   otherButtonTitles:nil
                                            tapBlock:nil];
    }
    else {
        [self post];
        
    }
}

- (void)post {
    NSString  *baseURL = @"http://prolific-interview.herokuapp.com";
    self.sessionManager =   [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{@"author": self.authorTextField.text,
                                 @"categories": self.categoryField.text,
                                 @"publisher":self.publisherTextField.text,
                                 @"title":self.titleTextField.text,
                                 };
    NSString *relativeURL = @"/books/";
    [self.sessionManager POST:[NSString stringWithFormat:@"/5764751072b55d00097eab85%@",relativeURL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Response Object %@", (NSDictionary*)responseObject);
        [UIAlertController showAlertInViewController:self
                                           withTitle:@""
                                             message:@"Book sucessfully added"
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:@"OK"
                                   otherButtonTitles:nil
                                            tapBlock:nil];
        self.authorTextField.text = @"";
        self.categoryField.text = @"";
        self.publisherTextField.text = @"";
        self.titleTextField.text = @"";
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIAlertController showAlertInViewController:self
                                           withTitle:@"Error"
                                             message:[error.userInfo description]
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:@"OK"
                                   otherButtonTitles:nil
                                            tapBlock:nil];
    }];

}




- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)doneButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
