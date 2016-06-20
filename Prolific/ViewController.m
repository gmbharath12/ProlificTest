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
    [UIAlertController showAlertInViewController:self
                                       withTitle:@""
                                         message:string
                               cancelButtonTitle:nil
                          destructiveButtonTitle:@"OK"
                               otherButtonTitles:nil
                                        tapBlock:nil];
}


#pragma mark AddBook 
- (void)addBook:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddViewController *addViewController = (AddViewController*)[storyboard instantiateViewControllerWithIdentifier:
                                                                @"AddViewController"];
    addViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark EditAction
- (void)clearAllAction:(UIBarButtonItem*)sender {
    //clear all items.
    if (!self.editing) {
        [super setEditing:YES animated:YES];
        [self deleteBook:nil withClearAll:YES];
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
        [self deleteBook:self.dataArray[indexPath.row] withClearAll:NO];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *viewController = (DetailViewController*)[storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    viewController.book = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark Delete Book
- (void)deleteBook:(Book*)book withClearAll:(bool)clearAll {
    self.sessionManager =   [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    if (!clearAll) {
        [self.sessionManager DELETE:[NSString stringWithFormat:@"/5764751072b55d00097eab85%@",book.url] parameters:nil success:nil  failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"\n ERROR \n %@",error.userInfo);
            [UIAlertController showAlertInViewController:self
                                               withTitle:@"Error"
                                                 message:@"There's an error in deleting a book entry. Please check back later"
                                       cancelButtonTitle:nil
                                  destructiveButtonTitle:@"OK"
                                       otherButtonTitles:nil
                                                tapBlock:nil];
        }];
    }
    else {
        NSLog(@"Delete All");
//        NSString *relativeURL = @"/clean";
//        [self.sessionManager DELETE:[NSString stringWithFormat:@"/5764751072b55d00097eab85%@",relativeURL] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSLog(@"Response Object %@", (NSDictionary*)responseObject);
//            [UIAlertController showAlertInViewController:self
//                                               withTitle:@"Success"
//                                                 message:@"All book entries deleted"
//                                       cancelButtonTitle:nil
//                                  destructiveButtonTitle:@"OK"
//                                       otherButtonTitles:nil
//                                                tapBlock:nil];
//        }  failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"\n ERROR \n %@",error.userInfo);
//            [UIAlertController showAlertInViewController:self
//                                               withTitle:@"Error"
//                                                 message:@"There's an error in deleting all book entries. Please check back later"
//                                       cancelButtonTitle:nil
//                                  destructiveButtonTitle:@"OK"
//                                       otherButtonTitles:nil
//                                                tapBlock:nil];
//        }];
    }
    
}

#pragma mark AddViewController Delegate
- (void)newBooksArray:(NSMutableArray *)bookArray {
    for (Book *lbook in bookArray) {
        [self.dataArray addObject:lbook];
    }
    [self.booksTableView reloadData];
}

@end
