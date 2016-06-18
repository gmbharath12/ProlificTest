//
//  ServiceManager.h
//  Prolific
//
//  Created by Bharath G M on 6/17/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ServiceCompletionBlock)(NSMutableArray *cardObject, NSError *error);

@interface ServiceManager : NSObject

+ (void)requestBookData:(ServiceCompletionBlock)completionBlock;

@end
