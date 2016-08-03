//
//  MainViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/15.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "MainViewController.h"
#import "CategoryViewController.h"
#import "MainCell.h"

@interface MainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *MainCollView;

@property (nonatomic, strong) AppDelegate *app;
@end

@implementation MainViewController

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.menuView.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _app = kAppDelegate;
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.MainCollView.collectionViewLayout = flowLayout;
    self.MainCollView.pagingEnabled = YES;
    [_MainCollView registerNib:[UINib nibWithNibName:@"MainCell" bundle:nil] forCellWithReuseIdentifier:@"mainCell"];
    
}

#pragma mark UICollectionViewDelegate and UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeMake(kScreenWidth / 2, _MainCollView.height / 2);
    
    return size;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 4;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellID = @"mainCell";
    
    MainCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    NSArray *imageArr = @[@"locate", @"track", @"remind", @"child"];
    
    [cell.titleImag setImage:[UIImage imageNamed:imageArr[indexPath.item]] forState:UIControlStateNormal];

    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == 0 || indexPath.item == 3) {
        
        _app.state = @"ahsghads";
        
    }else{
        _app.state = nil;
    }
    
    CategoryViewController *catgotyVC = [[CategoryViewController alloc] init];
    
    catgotyVC->baby = baby;
    
    catgotyVC.index = indexPath.item;
    
    switch (indexPath.item) {
        case 0:{
            catgotyVC.state = @"location";
        }
            break;
        case 1:{
            catgotyVC.state = @"motion";
        }
            break;
        case 2:{
            catgotyVC.state = @"reminder";
        }
            break;
        case 3:{
            catgotyVC.state = @"kidtoken";
        }
            break;
            
        default:
            break;
    }
    
    
    [self.navigationController pushViewController:catgotyVC animated:YES];
    
}
@end
