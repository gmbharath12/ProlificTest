//
//  ViewController.m
//  Prolific
//
//  Created by Bharath G M on 6/17/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import "ViewController.h"
#import "ServiceManager.h"
#import "Book.h"
#import "CustomCell.h"

#define kRowHeight 70

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *booksTableView;
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //additional setup after view is loaded
    [self additionalSetUp];
    [self fetchData];
}

- (void)additionalSetUp {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"Books";
    [self.booksTableView registerClass:[CustomCell class] forCellReuseIdentifier:@"BookCell"];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(addBook: )];
    [self.navigationItem setLeftBarButtonItem:menuItem];

}


#pragma mark Fetch Data

- (void) fetchData {
    [ServiceManager requestBookData:^(NSArray *bookData, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (error) {
                 [self showAlertView:[error localizedDescription]];
             } else {
                 self.dataArray = bookData;
                 [self.booksTableView reloadData];
             }
         });
     }];
    
}

#pragma mark Alert View

- (void)showAlertView:(NSString *)string {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@""
                                                                    message:string                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action) {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark AddBook 
- (void)addBook:(id)sender {
    
}


#pragma mark TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self dataArray] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell" forIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    Book *book = [[self dataArray] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[book title]];
    [[cell detailTextLabel] setText:[book author]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
