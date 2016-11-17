//
//  ProgramCollectionViewCell.m
//  BBCRadio4Schedule
//
//  Created by Juliana Cipa on 27/06/2016.
//  Copyright © 2016 Super Cool Start-up. All rights reserved.
//

#import "ProgramCollectionViewCell.h"

@implementation ProgramCollectionViewCell

-(void)configureWithDefaultValues {
    self.programIcon.image = [UIImage imageNamed:@"placeholder"];
    self.titleLabel.text = @"";
    self.missedView.hidden = YES;
    self.titleLabel.textColor = [UIColor whiteColor];
}

-(void)showIsMissed {
    self.missedView.hidden = NO;
    self.titleLabel.textColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1.0];
}

@end
