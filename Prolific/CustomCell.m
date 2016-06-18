//
//  CustomCell.m
//  Prolific
//
//  Created by Bharath G M on 6/18/16.
//  Copyright © 2016 Bharath G M. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    // ignore the style argument, use our own to override
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // If you need any further customization
    }
    return self;
}

@end
