//
//  ViewInksViewController.m
//  Inkit
//
//  Created by Cristian Pena on 19/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "ViewInksViewController.h"
#import "ViewInkViewController.h"
#import "CreateBoardViewController.h"
#import "InkCollectionViewCell.h"
#import "WaterfallLayout.h"

static NSString * const InkCollectionViewCellIdentifier = @"InkCollectionViewCell";

@interface ViewInksViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *inksCollectionView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic) BOOL isEditing;
@end

@implementation ViewInksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.inksCollectionView.collectionViewLayout = [[WaterfallLayout alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.board) {
        self.title = self.board.boardTitle;
    }
}
#pragma mark - CollectionView Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.inksArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InkCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:InkCollectionViewCellIdentifier forIndexPath:indexPath];
    DBInk* ink = self.inksArray[indexPath.row];
    [cell configureForInk:ink];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    InkCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:InkCollectionViewCellIdentifier forIndexPath:indexPath];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    double width = (screenBounds.size.width-12)/2;
//    double imageWidth = width - 4;
//    DBInk* ink = self.inksArray[indexPath.row];
//    UIImage* image = (UIImage *)ink.inkImage;
//    CGSize imageSize = image.size;
//    double aspectRatio = imageSize.height / imageSize.width;
//    double imageHeight = imageWidth*aspectRatio;
//    double height = imageHeight + 50 + 38;
    
    //CGSize cellSize = CGSizeMake(width, height);

    return CGSizeMake(width, 360);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ViewInkSegue" sender:indexPath];
}

#pragma mark - Navigation Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[ViewInkViewController class]] && [sender isKindOfClass:[NSIndexPath class]]) {
        NSIndexPath* indexPath = (NSIndexPath *)sender;
        ViewInkViewController* viewInkViewController = [segue destinationViewController];
        viewInkViewController.ink = self.inksArray[indexPath.row];;
    } else if ([[segue destinationViewController] isKindOfClass:[CreateBoardViewController class]]) {
        CreateBoardViewController* createBoardViewController = [segue destinationViewController];
        createBoardViewController.board = self.board;
        createBoardViewController.isEditing = YES;
    }
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"EditBoardSegue" sender:nil];
}

@end
