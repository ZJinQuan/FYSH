//
//  HomeViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/19.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "ConnectViewController.h"
#import "DashoardViewController.h"
#import "QRCodeReaderViewController.h"

@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,QRCodeReaderDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *homeCollView;

@property (nonatomic, strong) AppDelegate *app;

@property (nonatomic, strong) NSMutableArray *fyshArr;

@property (nonatomic, copy) NSString *disUuid;

@property (nonatomic, strong) NSMutableArray *disIdArr;

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    [_homeCollView reloadData];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.menuView.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _app = kAppDelegate;
    
    _disIdArr = [[NSMutableArray alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    
    label.text = @"Home";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor darkGrayColor];
    self.navigationItem.titleView = label;
    
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.homeCollView.collectionViewLayout = flowLayout;
    self.homeCollView.pagingEnabled = YES;

    [_homeCollView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellWithReuseIdentifier:@"homeCell"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SweepRQCode:) name:@"SweepRQCode" object:nil];
    
}

-(void) SweepRQCode:(NSNotification *) notf{
    
    QRCodeReaderViewController *QRcodeVC = [[QRCodeReaderViewController alloc] init];
    
    QRcodeVC.title = @"QR Code";
    
    QRcodeVC.modalPresentationStyle = UIModalPresentationFormSheet;
    QRcodeVC.delegate = self;
    
    __weak typeof (self) wSelf = self;
    [QRcodeVC setCompletionWithBlock:^(NSString *resultAsString) {
        [wSelf.navigationController popViewControllerAnimated:YES];
        [[[UIAlertView alloc] initWithTitle:@"" message:resultAsString delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
    }];
    
    [self.navigationController pushViewController:QRcodeVC animated:YES];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result{
    
        [self dismissViewControllerAnimated:YES completion:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UICollectionViewDelegate and UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeMake(kScreenWidth / 2, _homeCollView.height / 2);
    
    return size;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _app.FyshArray.count;
    
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"homeCell";
    
    HomeCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.fyshM = _app.FyshArray[indexPath.item];
    
//    [cell.titleImag setImage:[UIImage imageNamed:imageArr[indexPath.item]] forState:UIControlStateNormal];
    
    return cell;
    
}

// 点击 item 的操作
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FyshModel *fyshM;
    fyshM = _app.FyshArray[indexPath.item];
    
    DashoardViewController *dashVC = [[DashoardViewController alloc] init];
    
    dashVC.index = indexPath.item;
    dashVC->baby = baby;
    
    for (int i = 0; i < _app.connArr.count; i++) {
        
        if ([_app.connArr[i] isEqualToString:fyshM.fId]) {
            
            dashVC.isYes = YES;
            
            break;
        }
        
    }

    [self.navigationController pushViewController:dashVC animated:YES];
    
    
}

- (IBAction)clickAddSevser:(id)sender {
    
        ConnectViewController *connectVC = [[ConnectViewController alloc] init];
    
        [self.navigationController pushViewController:connectVC animated:YES];
    
}
@end
