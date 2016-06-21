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
#import "DetailViewController.h"
#import "AddViewController.h"

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

- (void)viewDidAppear:(BOOL)animated {
    if (self.dataArray.count > 0) {
        [self hideClearButton:NO];
    }
    else {
        [self hideClearButton:YES];
    }
}

//adds Add and Clear bar button items on navigation bar
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
// GET request uses iOS built in api
- (void) fetchData {
    [ServiceManager requestBookData:^(NSMutableArray *bookData, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (error) {
                 [self showAlertViewWithTitle:@"Error" message:[error localizedDescription]];
             } else {
                 self.dataArray = bookData;
                 if (self.dataArray.count == 0)
                     [self hideClearButton:YES];
                 else{
                     [self hideClearButton:NO];
                 }
                 [self.booksTableView reloadData];
             }
         });
     }];
}

#pragma mark Show Alert View
- (void)showAlertViewWithTitle:(NSString*)title message:(NSString *)message {
    [UIAlertController showAlertInViewController:self
                                       withTitle:@"title"
                                         message:message
                               cancelButtonTitle:nil
                          destructiveButtonTitle:@"OK"
                               otherButtonTitles:nil
                                        tapBlock:nil];
}


#pragma mark AddBook Action
- (void)addBook:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddViewController *addViewController = (AddViewController*)[storyboard instantiateViewControllerWithIdentifier:
                                                                @"AddViewController"];
    addViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

//this is an hack to hide/show right bar button item.
- (void)hideClearButton:(bool)hide {
    if (hide) {
        self.navigationItem.rightBarButtonItem.enabled = false;
        self.navigationItem.rightBarButtonItem.title = nil;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = true;
        self.navigationItem.rightBarButtonItem.title = @"Clear";
    }
}

#pragma mark EditAction
- (void)clearAllAction:(UIBarButtonItem*)sender {
    
    //clear all items.
        [UIAlertController showAlertInViewController:self
                                           withTitle:@"Clear All"
                                             message:@"Are you sure you want to delete all entries ?"
                                   cancelButtonTitle:@"NO"
                              destructiveButtonTitle:@"YES"
                                   otherButtonTitles:nil
                                    tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                        if (buttonIndex == 1) {
//                                            NSLog(@"YES");
//                                            NSLog(@"Delete All");
                                            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                                            if (!self.sessionManager) {
                                                self.sessionManager =   [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
                                                self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
                                                self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
                                            }
                                            NSString *relativeURL = @"/clean";
                                            [self.sessionManager DELETE:[NSString stringWithFormat:@"/5764751072b55d00097eab85%@",relativeURL] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//                                                NSLog(@"Response Object %@", (NSDictionary*)responseObject);
                                                [self.dataArray removeAllObjects];
                                                [self.booksTableView reloadData];
                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                [self hideClearButton:YES];
                                            }  failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                                NSLog(@"\n ERROR \n %@",error.userInfo);
                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                [self showAlertViewWithTitle:@"Error" message:@"There's an error in deleting all book entries. Please try again"];
                                            }];
                                        }
                                    }];
}

#pragma mark TableView Delegate and Datasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self dataArray] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell" forIndexPath:indexPath];
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
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        //web service call
        Book *lbook = self.dataArray[indexPath.row];
        if (!self.sessionManager) {
            self.sessionManager =   [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
            self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
            self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
            [self.sessionManager DELETE:[NSString stringWithFormat:@"/5764751072b55d00097eab85%@",lbook.url] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                if (self.dataArray.count == 0) {
                    [self hideClearButton:YES];
                }
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }   failure:^(NSURLSessionDataTask *task, NSError *error) {
                //NSLog(@"\n ERROR \n %@",error.userInfo);
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [self showAlertViewWithTitle:@"Error" message:@"There's an error in deleting a book entry. Please try again"];
            }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *viewController = (DetailViewController*)[storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    viewController.book = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark AddViewController Delegate
//this is called when we tap on "DONE" button
- (void)newBooksArray:(NSMutableArray *)bookArray {
    for (Book *lbook in bookArray) {
        [self.dataArray addObject:lbook];
    }
    [self.booksTableView reloadData];
}

@end
