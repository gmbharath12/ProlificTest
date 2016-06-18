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
@property (strong, nonatomic) NSMutableArray *dataArray;
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
    self.booksTableView.allowsMultipleSelectionDuringEditing = NO;
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(addBook:)];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearAllAction:)];
    [self.navigationItem setLeftBarButtonItem:menuItem];
    [self.navigationItem setRightBarButtonItem:editButton];
}


#pragma mark Fetch Data

- (void) fetchData {
    [ServiceManager requestBookData:^(NSMutableArray *bookData, NSError *error) {
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

#pragma mark EditAction
- (void)clearAllAction:(UIBarButtonItem*)sender {
    
    //clear all items.
    if (!self.editing) {
        [super setEditing:YES animated:YES];
        [self.dataArray removeAllObjects];
        [self.booksTableView reloadData];
        [self.navigationItem setRightBarButtonItem:nil];
    }
    else {
        [super setEditing:NO animated:YES];
        [self.booksTableView setEditing:NO animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Clear"];
    }
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"accessoryButtonTappedForRowWithIndexPath");
}


@end
