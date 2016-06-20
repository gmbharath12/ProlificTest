//
//  AddViewController.h
//  Prolific
//
//  Created by Bharath G M on 6/18/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book;

@protocol AddViewControllerDelegate <NSObject>

- (void)newBooksArray:(NSMutableArray*)bookArray;

@end

@interface AddViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;
@property (weak, nonatomic) IBOutlet UITextField *publisherTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryField;
@property (weak, nonatomic) id <AddViewControllerDelegate> delegate;
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) NSMutableArray *addedBooks;

- (IBAction)submitButtonAction:(id)sender;

@end
