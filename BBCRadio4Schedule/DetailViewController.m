//
//  DetailViewController.m
//  BBCRadio4Schedule
//
//  Created by IG on 08/09/2015.
//  Copyright (c) 2015 Super Cool Start-up. All rights reserved.
//

#import "DetailViewController.h"
#import "BBC4Program.h"

static NSString *const kThumbnaleEndPoint = @"http://ichef.bbci.co.uk/images/ic/480x270/";

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortSynopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setBbc4Program:(BBC4Program *)newBbc4Program {
    if (_bbc4Program != newBbc4Program) {
        _bbc4Program = newBbc4Program;

        [self configureView];
    }
}

-(void)configureImageView {
    NSString *completeUrlString = [NSString stringWithFormat:@"%@%@.jpg", kThumbnaleEndPoint, self.bbc4Program.pid];
    NSURL *imageURL = [NSURL URLWithString:completeUrlString];
    
    self.imageView.image = [UIImage imageNamed:@"placeholder"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    });
}

- (void)configureView {
    if (self.bbc4Program) {
        [self configureImageView];
        
        self.titleLabel.text = [self.bbc4Program title];
        self.shortSynopsisLabel.text = [self.bbc4Program shortSynopsis];
        self.typeLabel.text = [self.bbc4Program type];
        self.durationLabel.text = [self.bbc4Program readableDuration];
        self.startLabel.text = [self.bbc4Program readableStartDate];
        self.endLabel.text = [self.bbc4Program readableEndDate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

@end
