//
//  CheckOutViewController.h
//  Prolific
//
//  Created by Bharath G M on 6/18/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckOutViewControllerDelegate <NSObject>

- (void)checkOutUserName:(NSString*)userName;

@end

@interface CheckOutViewController : UIViewController
@property (weak, nonatomic) id <CheckOutViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
- (IBAction)doneAction:(id)sender;

@end
