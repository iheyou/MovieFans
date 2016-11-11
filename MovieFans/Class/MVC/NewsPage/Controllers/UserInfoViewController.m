//
//  UserInfoViewController.m
//  MovieFans
//
//  Created by hy on 16/2/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "UserInfoViewController.h"
#import "CreatorTableViewHeader.h"
#import "UIImageView+WebCache.h"
#import <BmobSDK/BmobProFile.h>
#import "UIImageView+LBBlurredImage.h"



typedef NS_ENUM(NSInteger, ChosePhontType) {
    ChosePhontTypeAlbum,
    ChosePhontTypeCamera
};

@interface UserInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIImageView * _iconImageView;
    NSString * _urlString;
}

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)CreatorTableViewHeader* headView;
@property(nonatomic,strong)UIImageView* bigImageView;

/** 记录手机号是否验证*/
@property (assign, nonatomic) BOOL isPhoneVerified;

@end

@implementation UserInfoViewController

-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SCREEN_HEIGHT)style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人信息";
    [self.view addSubview:self.tableView];
    
    [self userRefresh:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRefresh:) name:USER_REFRESH_NOTICE object:nil];
    
    //[self refreshUserInfo];
    //[self createUI];
    
    
}

//- (void)refreshUserInfo
//{
//    // 1.获取到当前登录用户
//    BmobUser *user = [BmobUser getCurrentUser];
//   // NSString *urlStr = [user objectForKey:@"userIconUrl"];
//    
//    BOOL isPhoneNumbVerified = [[user objectForKey:@"mobilePhoneNumberVerified"] boolValue];
//    
//    if (isPhoneNumbVerified) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        cell.textLabel.text = @"手机号已验证";
//        _isPhoneVerified = YES;
//    }else {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        cell.textLabel.text = @"验证手机号";
//        _isPhoneVerified = NO;
//    }
//    
//    //[_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
//}


- (void)createUI{
    
    _bigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    _bigImageView.clipsToBounds=YES;
    _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    if ([BmobUser getCurrentUser]) {
        [_bigImageView sd_setImageWithURL:[NSURL URLWithString:_urlString] placeholderImage:[UIImage imageNamed:@"Image_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            // 20 左右 R  模糊图片
            [_bigImageView setImageToBlur:_bigImageView.image blurRadius:20 completionBlock:nil];
        }];

    }else{
        [_bigImageView setImageToBlur:[UIImage imageNamed:@"default.jpg"] blurRadius:21 completionBlock:nil];
    }
    
    _headView=[[CreatorTableViewHeader alloc]init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _iconImageView.center=CGPointMake(_bigImageView.center.x, _bigImageView.center.y);
    _iconImageView.clipsToBounds=YES;
    _iconImageView.layer.cornerRadius = 40;
    _iconImageView.layer.borderWidth = 2;
    _iconImageView.layer.borderColor = [UIColor brownColor].CGColor;
    _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    if ([BmobUser getCurrentUser]) {
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_urlString]placeholderImage:[UIImage imageNamed:@"Image_head"]];
    }else{
        _iconImageView.image = [UIImage imageNamed:@"Image_head"];
    }
    _iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    [_iconImageView addGestureRecognizer:tapGesture];
    
    
    [_headView layoutWithTableView:self.tableView andBackGroundView:_bigImageView andIconImageView:_iconImageView];
    
}

- (void)onTap:(UITapGestureRecognizer *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择相片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self chosePhoto:ChosePhontTypeAlbum];
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self chosePhoto:ChosePhontTypeCamera];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:album];
    [alert addAction:camera];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)chosePhoto:(ChosePhontType)type
{
    UIImagePickerController *piker = [[UIImagePickerController alloc] init];
    piker.delegate = self;
    piker.allowsEditing = YES;
    if (type == ChosePhontTypeAlbum) {
        piker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (type == ChosePhontTypeCamera) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            piker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            [SVProgressHUD showErrorWithStatus:@"相机不可用"];
            return;
        }
    }
    
    [self presentViewController:piker animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = info[UIImagePickerControllerEditedImage];
    NSData *imgData = nil;
    
    /*
     // 图片存到本地
     NSString *docmentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
     NSString *imgDirPath = [docmentPath stringByAppendingPathComponent:@"ImageFile"];
     
     NSFileManager *fileManager = [NSFileManager defaultManager];
     
     // 如果文件夹已经存在，就不需要创建
     if ([fileManager fileExistsAtPath:imgDirPath]) {
     
     }else {
     [fileManager createDirectoryAtPath:imgDirPath withIntermediateDirectories:YES attributes:nil error:nil];
     }
     
     NSData * saveImgData  = UIImagePNGRepresentation(img);
     NSString *imgPath = [imgDirPath stringByAppendingPathComponent:@"userIcon"];
     BOOL isSuc = [saveImgData writeToFile:imgPath atomically:YES];
     
     if (isSuc) {
     [SVProgressHUD showSuccessWithStatus:@"保存成功"];
     }else {
     [SVProgressHUD showErrorWithStatus:@"保存失败"];
     }
     
     // 将图片存到相册
     //    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
     
     */
    
    if(UIImagePNGRepresentation(img)){
        imgData = UIImagePNGRepresentation(img);
    }else if (UIImageJPEGRepresentation(img, 1)) {
        imgData = UIImageJPEGRepresentation(img, 1);
    }
    
    
    // 压缩处理
    imgData = UIImageJPEGRepresentation(img, 0.00001);
    
    // 将图片尺寸变小
    
    
    UIImage *theImg = [self zipImageWithData:imgData limitedWith:140];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImageWithImage:theImg];
    }];
    
}

- (UIImage *)zipImageWithData:(NSData *)imgData limitedWith:(CGFloat)width
{
    // 获取图片
    UIImage *img = [UIImage imageWithData:imgData];
    
    CGSize oldImgSize = img.size;  //
    
    if (width > oldImgSize.width) {
        width = oldImgSize.width;
    }
    
    
    CGFloat newHeight = oldImgSize.height * ((CGFloat)width / oldImgSize.width);
    
    // 创建新的图片的大小
    CGSize size = CGSizeMake(width, newHeight);
    
    // 开启一个图片句柄
    UIGraphicsBeginImageContext(size);
    
    // 将图片画入新的size里面
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从图片句柄中获取一张新的图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图片句柄
    UIGraphicsEndImageContext();
    
    return newImg;
}

/** 上传图片到bomb服务器*/
- (void)uploadImageWithImage:(UIImage *)img
{
    NSData *data = UIImagePNGRepresentation(img);
    
    [SVProgressHUD showWithStatus:@"上传图片..."];
    
    [BmobProFile uploadFileWithFilename:@"用户图标" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
        if (isSuccessful) {
            
            // 将上传的图片链接和用户联系起来
            BmobUser *user = [BmobUser getCurrentUser];
            [user setObject:file.url forKey:@"userIconUrl"];
            
            [user updateInBackgroundWithResultBlock:^(BOOL isSuc, NSError *err) {
                if (isSuc) {
                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                    // 获取服务器处理之后的图片的地址
                    [BmobImage cutImageBySpecifiesTheWidth:100 height:100 quality:50 sourceImageUrl:file.url outputType:kBmobImageOutputBmobFile resultBlock:^(id object, NSError *error) {
                        BmobFile *resfile = object;
                        NSString *resUrl = resfile.url;
                        
                        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:resUrl]];
                        [_bigImageView sd_setImageWithURL:[NSURL URLWithString:resUrl] placeholderImage:[UIImage imageNamed:@"Image_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            // 20 左右 R  模糊图片
                            [_bigImageView setImageToBlur:_bigImageView.image blurRadius:21 completionBlock:nil];
                        }];

                        [[NSNotificationCenter defaultCenter] postNotificationName:USER_REFRESH_NOTICE object:nil];
                    }];
                    
                    
                    
                    
                }else {
                    [SVProgressHUD showErrorWithStatus:[err localizedDescription]];
                }
            }];
            
            
            
        }else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }
        
        
    } progress:^(CGFloat progress) {
        //上传进度
        [SVProgressHUD showProgress:progress];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID=@"Cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    cell.backgroundColor = [UIColor redColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"退出登录";
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *quit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [BmobUser logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_REFRESH_NOTICE object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [alert addAction:cancel];
    [alert addAction:quit];
    
    [self presentViewController:alert animated:YES completion:^{

    }];

}

/** 刷新用户信息*/
- (void)userRefresh:(NSNotification *)notice
{
    // 获取到用户的用户名
    BmobUser *user = [BmobUser getCurrentUser];
    
    if (user) {
        NSString *urlStr = [user objectForKey:@"userIconUrl"];
       
        
        [BmobImage cutImageBySpecifiesTheWidth:100 height:100 quality:50 sourceImageUrl:urlStr outputType:kBmobImageOutputBmobFile resultBlock:^(id object, NSError *error) {
            BmobFile *resfile = object;
            NSString *resUrl = resfile.url;
            
            _urlString = resUrl;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_tableView reloadData];
                [self createUI];
            });
            
            
        }];
        
    }else {
        
    }
    
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:USER_REFRESH_NOTICE];
}


@end
