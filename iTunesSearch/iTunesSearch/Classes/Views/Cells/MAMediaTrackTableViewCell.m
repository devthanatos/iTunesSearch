//
//  MAMediaTrackTableViewCell.m
//  iTunesSearch
//
//  Created by Michael Akopyants on 26/01/2017.
//  Copyright © 2017 devthanatos. All rights reserved.
//

#import "MAMediaTrackTableViewCell.h"

@interface MAMediaTrackTableViewCell ()

@end

@implementation MAMediaTrackTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.font = [UIFont systemFontOfSize:13.0f];
        self.textLabel.numberOfLines = 2;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)reuseIdentifier
{
    return NSStringFromClass([MAMediaTrackTableViewCell class]);
}

@end
