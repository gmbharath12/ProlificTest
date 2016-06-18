//
//  Book.h
//  Prolific
//
//  Created by Bharath G M on 6/17/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *categories;
@property (strong, nonatomic) NSString *bookID;
@property (strong, nonatomic) NSString *lastCheckedOut;
@property (strong, nonatomic) NSString *lastCheckedOutBy;
@property (strong, nonatomic) NSString *publisher;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *url;

@end
