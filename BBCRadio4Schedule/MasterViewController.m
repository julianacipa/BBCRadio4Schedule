//
//  MasterViewController.m
//  BBCRadio4Schedule
//
//  Created by IG on 08/09/2015.
//  Copyright (c) 2015 Super Cool Start-up. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ProgramTableViewCell.h"
#import "ProgramsService.h"
#import "ProgramCollectionView.h"
#import "ProgramCollectionViewCell.h"
#import "BBC4Program.h"

static NSString *const kThumbnaleEndPoint = @"http://ichef.bbci.co.uk/images/ic/480x270/";
static NSString *const kProgramCollectionViewCell = @"ProgramCollectionViewCell";
static NSString *const kDetailSegue = @"showDetail";

@interface MasterViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong)NSArray *todaysPrograms;
@property(nonatomic, strong)NSArray *tomorrowsPrograms;
@property(nonatomic, strong)NSArray *yesterdaysPrograms;

@property(nonatomic, strong)BBC4Program *selectedProgram;

@end

@implementation MasterViewController

#pragma mark - API calls

-(void)fetchPrograms {
    [ProgramsService getTodaysProgramsWithCompletionHandler:^(NSArray *programs, NSError *error) {
        self.todaysPrograms = error ? @[] : programs;
        
        [ProgramsService getTomorrowsProgramsWithCompletionHandler:^(NSArray *programs, NSError *error) {
            self.tomorrowsPrograms = error ? @[] : programs;

            [ProgramsService getYesterdaysProgramsWithCompletionHandler:^(NSArray *programs, NSError *error) {
                self.yesterdaysPrograms = error ? @[] : programs;
                
                [self.tableView reloadData];
                
                if (self.refreshControl) {
                    [self.refreshControl endRefreshing];
                }
            }];
        }];
    }];
}

-(void)refreshPrograms {
    if (self.refreshControl) {
        [self fetchPrograms];
    }
}

-(void)configurePullToRefresh {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor darkGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshPrograms)
                  forControlEvents:UIControlEventValueChanged];
}

#pragma mark - View Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.todaysPrograms = @[];
    self.tomorrowsPrograms = @[];
    self.yesterdaysPrograms = @[];
    
    [self configurePullToRefresh];
    [self fetchPrograms];
}

#pragma mark - Helpers

-(NSArray *)programsForIndex:(NSInteger)row {
    NSArray *programs = @[];
    
    if (row == 0) {
        programs = self.todaysPrograms;
    } else if (row == 1) {
        programs = self.tomorrowsPrograms;
    } else {
        programs = self.yesterdaysPrograms;
    }
    
    return programs;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kDetailSegue]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setBbc4Program:self.selectedProgram];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgramTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.programCollectionView.indexPath = indexPath;
    [cell.programCollectionView reloadData];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (nullable NSString *)tableView:(UITableView *)tableView
         titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    
    switch (section) {
        case 0:
            title = @"Today";
            break;
        case 1:
            title = @"Tomorrow";
            break;
        case 2:
            title = @"Yesterday";
            break;
    }
    
    return title;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor whiteColor];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section {
    NSInteger programIndex = [(ProgramCollectionView *)collectionView indexPath].section;
    NSArray *programs = [self programsForIndex:programIndex];
    
    return programs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProgramCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProgramCollectionViewCell
                                                                                forIndexPath:indexPath];
    NSInteger collectionViewSection = [(ProgramCollectionView *)collectionView indexPath].section;
    
    cell.collectionViewSection = collectionViewSection;
    cell.indexPath = indexPath;
    
    [cell configureWithDefaultValues];
    
    NSArray *programs = [self programsForIndex:collectionViewSection];
    BBC4Program *program = programs[indexPath.row];
    
    NSString *completeUrlString = [NSString stringWithFormat:@"%@%@.jpg", kThumbnaleEndPoint, program.pid];
    NSURL *imageURL = [NSURL URLWithString:completeUrlString];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (cell.indexPath.row == indexPath.row && cell.collectionViewSection == [(ProgramCollectionView *)collectionView indexPath].section) {
                cell.programIcon.image = image;
                cell.titleLabel.text = program.title;
                
                if ([program isMissedProgramNow] && cell.collectionViewSection == 0) {
                    [cell showIsMissed];
                }
            }
        });
    });
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger collectionViewSection = [(ProgramCollectionView *)collectionView indexPath].section;

    NSArray *programs = [self programsForIndex:collectionViewSection];
    
    self.selectedProgram = programs[indexPath.row];
    
    [self performSegueWithIdentifier:kDetailSegue sender:self];
}

@end
