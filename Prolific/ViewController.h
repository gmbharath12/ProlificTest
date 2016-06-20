//
//  ViewController.h
//  Prolific
//
//  Created by Bharath G M on 6/17/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddViewController.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, AddViewControllerDelegate>

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

