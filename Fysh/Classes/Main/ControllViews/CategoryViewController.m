//
//  CategoryViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/15.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryCell.h"
#import "SettingViewController.h"

@interface CategoryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *CategoryView;

@property (nonatomic, strong) UIImagePickerController *imgPicker;

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) AppDelegate *app;
@end

@implementation CategoryViewController

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.menuView.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.app = kAppDelegate;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    
    label.text = @"Pick an icon";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor darkGrayColor];
    self.navigationItem.titleView = label;
    
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.delegate = self;
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGFloat W = (kScreenWidth - 16) / 2 ;
    
    flowLayout.itemSize = CGSizeMake(W, W);
    
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.CategoryView.collectionViewLayout = flowLayout;

    self.CategoryView.pagingEnabled = YES;
    [_CategoryView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellWithReuseIdentifier:@"categoryCell"];
    
}

#pragma mark 

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeMake(kScreenWidth / 2, _CategoryView.height / 2);
    
    return size;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 4;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"categoryCell";
    
    CategoryCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
     NSArray *titleArr = [NSArray array];
    
    switch (_index) {
        case 0:{
            titleArr = @[@"180786-200", @"143355-200", @"17276-200", @"35982-200"];
        }
            break;
        case 1:{
            titleArr = @[@"536-200", @"372388-200", @"264671-200", @"158038-200"];
            
        }
            break;
        case 2:{
            titleArr = @[@"37595-200", @"123158-200", @"32819-200", @"50993-200"];
        }
            break;
        case 3:{
            titleArr = @[@"319580-200", @"63829-200", @"63740-200", @"320121-200"];
        }
            break;
            
        default:
            break;
    }
    
    _titleArr = titleArr;
    
    [cell.titleImg setImage:[UIImage imageNamed:titleArr[indexPath.item]] forState:UIControlStateNormal];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    CategoryCell *cell = (CategoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    
    settingVC.image = cell.titleImg.currentImage;
    
    _app.imageName = _titleArr[indexPath.item];
    
    settingVC.index = _index;
    
    settingVC->baby = baby;
    
    settingVC.state = _state;
    
    [self.navigationController pushViewController:settingVC animated:YES];
    
}

- (IBAction)clickTakePhoto:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 呈现图库
        [self presentViewController:_imgPicker animated:YES completion:nil];
    }
    
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        
        UIImage *newImage = [self fixOrientation:image];
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中
        NSData *data ;
        
        if (UIImagePNGRepresentation(newImage) == nil) {
            data = UIImageJPEGRepresentation(newImage, 1);
        } else {
            data = UIImagePNGRepresentation(newImage);
        }
        
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSDateFormatter *f = [[NSDateFormatter alloc]init];
        [f setDateFormat:@"YYYYMMDD_HHmmss"];
        NSString *timeStr = [f stringFromDate:[NSDate date]];
        
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@.png",timeStr]] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath, [NSString stringWithFormat:@"/%@.png",timeStr]];

        
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        
        settingVC.image = [UIImage imageWithContentsOfFile:filePath];
        
        _app.imageFile = filePath;
        
        [self.navigationController pushViewController:settingVC animated:YES];

        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
