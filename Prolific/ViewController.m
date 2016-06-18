//
//  ViewController.m
//  Prolific
//
//  Created by Bharath G M on 6/17/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import "ViewController.h"
#define kRowHeight 70

@interface ViewController ()
@property (nonatomic, strong) IBOutlet UITableView *booksTableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //additional setup after view is loaded
    [self additionalSetUp];

    
}

- (void)additionalSetUp
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"Books";
    [self.booksTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BookCell"];

    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(addBook:)];
    [self.navigationItem setLeftBarButtonItem:menuItem];

}

#pragma mark AddBook 
- (void)addBook:(id)sender
{
    
}


#pragma mark TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 100;
   // return [self.dataArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
