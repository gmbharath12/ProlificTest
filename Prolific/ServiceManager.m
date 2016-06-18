//
//  ServiceManager.m
//  Prolific
//
//  Created by Bharath G M on 6/17/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import "ServiceManager.h"
#import "AppDelegate.h"
#import "Book.h"

NSString *const bookURL = @"http://prolific-interview.herokuapp.com/5764751072b55d00097eab85/books";

@implementation ServiceManager

+ (void)requestBookData:(ServiceCompletionBlock)completionBlock
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *bookData = nil;
    NSError *error = nil;
    NSMutableArray *dataArray = nil;
    bookData = [NSData dataWithContentsOfURL:[NSURL URLWithString:bookURL]];
    if (!bookData)
    {
        error = [NSError errorWithDomain:@"Error"
                                    code:100
                                userInfo:@{
                                           NSLocalizedDescriptionKey:@"Something went wrong"}];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:bookData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",jsonObjects);
        dataArray = [ServiceManager parseJsonObject:jsonObjects];
    }
    
    completionBlock(dataArray, error);
}


+ (NSArray *)parseJsonObject:(id)books
{
    
    NSMutableArray *dataArray = [NSMutableArray new];
    for (id bookObject in books)
    {
            Book *book  = [[Book alloc] init];
            book.author = [bookObject valueForKey:@"author"];
            book.categories = [bookObject valueForKey:@"categories"];
            book.bookID = [bookObject valueForKey:@"id"];
            book.lastCheckedOut = [bookObject valueForKey:@"lastCheckedOut"];
            book.lastCheckedOutBy = [bookObject valueForKey:@"lastCheckedOutBy"];
            book.publisher = [bookObject valueForKey:@"publisher"];
            book.title = [bookObject valueForKey:@"title"];
            book.url = [bookObject valueForKey:@"url"];
            [dataArray addObject:book];
    }
    return dataArray;
}

@end
