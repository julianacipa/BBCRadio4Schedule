//
//  ProgramTableViewCell.h
//  BBCRadio4Schedule
//
//  Created by Juliana Cipa on 27/06/2016.
//  Copyright © 2016 Super Cool Start-up. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBC4Program.h"
#import "ProgramCollectionView.h"

@interface ProgramTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet ProgramCollectionView *programCollectionView;

@end
