//
//  ProgramCollectionViewCell.h
//  BBCRadio4Schedule
//
//  Created by Juliana Cipa on 27/06/2016.
//  Copyright © 2016 Super Cool Start-up. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgramCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *programIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *missedView;

@property (nonatomic, assign) NSInteger collectionViewSection;
@property (nonatomic, strong) NSIndexPath *indexPath;

-(void)configureWithDefaultValues;
-(void)showIsMissed;

@end
