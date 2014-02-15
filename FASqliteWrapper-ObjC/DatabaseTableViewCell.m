//
//  DatabaseTableViewCell.m
//  FASqliteWrapper-ObjC
//
//  Created by Furqan on 2/15/14.
//  Copyright (c) 2014 InnovativeApps. All rights reserved.
//

#import "DatabaseTableViewCell.h"

@implementation DatabaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
