//
//  ghunterBiddingReasonViewController.m
//  ghunter
//
//  Created by ImGondar on 15/12/28.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import "ghunterBiddingReasonViewController.h"

@interface ghunterBiddingReasonViewController ()
// 返回
- (IBAction)back:(id)sender;

// 确定
- (IBAction)popToDetailBtn:(id)sender;

- (IBAction)skillShowBtnClick:(id)sender;
@end

@implementation ghunterBiddingReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.postDic = [[NSMutableDictionary alloc] init];
    task = [[NSMutableDictionary alloc] init];
    
    if ([self.flagStr isEqualToString:@"1"]) {
        
        self.skillShowBtn.selected = NO;
        self.textVLabel.hidden = NO;
        self.contentTV.delegate = self;
        
        self.backScrollView.contentSize = CGSizeMake(0, self.backScrollView.frame.size.height + 64);
        self.backScrollView.showsHorizontalScrollIndicator = NO;
        self.backScrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.backScrollView];
        
        [self.backScrollView addSubview:self.contentView];
        [self.backScrollView addSubview:self.descLabel];
        [self.backScrollView addSubview:self.determineBtn];
    }else {
        
        self.textVLabel.hidden = NO;
        self.contentTV.delegate = self;
        self.textVLabel.text = @"向金主提交您完成任务的证明，附图更有说服力哦！";
        self.textVLabel.numberOfLines = 0;
        self.skillShowBtn.hidden = YES;
        self.synchronizeLabel.hidden = YES;
        self.titleLabel.text = @"提交任务秀";
        self.descLabel.text = @"注：在任务秀里，您可以向金主提供完成任务的证明，同时金主可以对您的任务秀进行打赏，若是金主对您的任务完成情况满意，可直接中意您。";
    }
    
    
    scrollPanel = [[UIView alloc] initWithFrame:self.view.bounds];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 0;
    [self.view addSubview:scrollPanel];
    
    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = mainScreenWidth;
    myScrollView.contentSize = contentSize;
    
    self.img0.userInteractionEnabled = YES;
    self.img0.clipsToBounds = YES;
    self.img0.contentMode = UIViewContentModeScaleAspectFill;
    self.img0.contentMode = UIViewContentModeScaleToFill;
    self.img1.userInteractionEnabled = YES;
    self.img1.clipsToBounds = YES;
    self.img1.contentMode = UIViewContentModeScaleAspectFill;
    self.img2.userInteractionEnabled = YES;
    self.img2.clipsToBounds = YES;
    self.img2.contentMode = UIViewContentModeScaleAspectFill;
    self.img3.userInteractionEnabled = YES;
    self.img3.clipsToBounds = YES;
    self.img3.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img0_tap:)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img1_tap:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img2_tap:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img3_tap:)];
    [self.img0 addGestureRecognizer:tap0];
    [self.img1 addGestureRecognizer:tap1];
    [self.img2 addGestureRecognizer:tap2];
    [self.img3 addGestureRecognizer:tap3];
    imgArray = [[NSMutableArray alloc] initWithCapacity:4];
    [self showPicture];

    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}


//
//// 参与竞标任务
//-(void)didJoinTaskIsloading:(BOOL )isloading{
//    if (isloading) {
////        [self startLoad];
//    }
//    [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?tid=%@", URL_JOIN_TASK, self.tidStr] params:nil success:^(NSData *data) {
//        if (isloading) {
////            [self endLoad];
//        }
//        NSError *error;
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//        [ProgressHUD show:[result objectForKey:@"msg"]];
//        if ([[result objectForKey:@"error"] integerValue] == 0) {
//            _isjoin = @"1";
////            [self setBidButtonStatus:_isjoin];
//            
//            NSMutableArray *joiners = [task objectForKey:@"joiners"];
//            joiners = [joiners mutableCopy];
//            NSMutableDictionary *joiner = [[NSMutableDictionary alloc] init];
//            [joiner setObject:[ghunterRequester getUserInfo:UID] forKey:UID];
//            [joiner setObject:[ghunterRequester getUserInfo:USERNAME] forKey:USERNAME];
//            [joiner setObject:[ghunterRequester getUserInfo:TINY_AVATAR] forKey:TINY_AVATAR];
//            [joiners insertObject:joiner atIndex:0];
//            task = [task mutableCopy];
//            [task setObject:joiners forKey:@"joiners"];
////            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
////            [taskTable reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationNone];
//        }else{
//            
//        }
//    } fail:^{
//        [ProgressHUD show:HTTPREQUEST_ERROR];
//        if (isloading) {
////            [self endLoad];
//        }
//    }];
//}



- (void)addPicture:(NSInteger)sender {
    if(sender == 0) {
        // 本地图片
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = (4 - [imgArray count]);
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = NO;
        picker.delegate = self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        [self presentViewController:picker animated:YES completion:NULL];
    } else if (sender == 1) {
        // 拍照上传
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setAllowsEditing:YES];
        [imgPicker setDelegate:self];
        [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
    }
}

- (void)showPicture {
    if([imgArray count] == 0) {
        [self.img0 setImage:[UIImage imageNamed:@"add_picture"]];
        self.img1.image = nil;
        self.img2.image = nil;
        self.img3.image = nil;
        
    } else if ([imgArray count] == 1) {
        [self.img0 setImage:(UIImage *)[imgArray objectAtIndex:0]];
        [self.img1 setImage:[UIImage imageNamed:@"add_picture"]];
        self.img2.image = nil;
        self.img3.image = nil;
//        self.addPicLabel.hidden = YES;
    } else if ([imgArray count] == 2) {
        [self.img0 setImage:(UIImage *)[imgArray objectAtIndex:0]];
        [self.img1 setImage:(UIImage *)[imgArray objectAtIndex:1]];
        [self.img2 setImage:[UIImage imageNamed:@"add_picture"]];
        self.img3.image = nil;
    } else if ([imgArray count] == 3) {
        [self.img0 setImage:(UIImage *)[imgArray objectAtIndex:0]];
        [self.img1 setImage:(UIImage *)[imgArray objectAtIndex:1]];
        [self.img2 setImage:(UIImage *)[imgArray objectAtIndex:2]];
        [self.img3 setImage:[UIImage imageNamed:@"add_picture"]];
    } else if ([imgArray count] == 4) {
        [self.img0 setImage:(UIImage *)[imgArray objectAtIndex:0]];
        [self.img1 setImage:(UIImage *)[imgArray objectAtIndex:1]];
        [self.img2 setImage:(UIImage *)[imgArray objectAtIndex:2]];
        [self.img3 setImage:(UIImage *)[imgArray objectAtIndex:3]];
    }
}

- (void)setImages:(NSArray *)images;
{
    for (UIImageView *imageView in self.checkmarkImageViews) {
        [imageView removeFromSuperview];
    }
    self.selectedIndexes = [NSMutableArray array];
    for (NSUInteger i = 0; i < [imgArray count]; i++) {
        NSNumber *path = @(i);
        [self.selectedIndexes addObject:path];
    }
    self.checkmarkImageViews = [NSMutableArray array];
    for (NSUInteger i = 0;i < [imgArray count];i++) {
        UIImage *emptyCheckmark = [UIImage imageNamed:@"define_tag"];
        UIImageView *checkmarkView = [[UIImageView alloc] initWithImage:emptyCheckmark];
        checkmarkView.frame = CGRectMake((i + 1) * mainScreenWidth - 50, 40, 30, 30);
        [myScrollView addSubview:checkmarkView];
        UIButton *select = [[UIButton alloc] initWithFrame:CGRectMake(checkmarkView.frame.origin.x - 20, checkmarkView.frame.origin.y - 20, checkmarkView.frame.size.width + 40, checkmarkView.frame.size.height + 40)];
        [select addTarget:self action:@selector(imageViewTapped:) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:select];
        [self.checkmarkImageViews addObject:checkmarkView];
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        //        [checkmarkView addGestureRecognizer:tap];
    }
}

- (void)imageViewTapped:(id)sender;
{
    NSUInteger index = [imgArray count] - 1 - currentIndex;
    NSNumber *path = @(index);
    if ([self.selectedIndexes containsObject:path]) {
        [self.selectedIndexes removeObject:path];
        UIImage *emptyCheckmark = [UIImage imageNamed:@"radio_normal"];
        UIImageView *checkmarkView = [self.checkmarkImageViews objectAtIndex:currentIndex];
        [checkmarkView setImage:emptyCheckmark];
        
    } else {
        [self.selectedIndexes addObject:path];
        UIImage *fullCheckmark = [UIImage imageNamed:@"define_tag"];
        UIImageView *checkmarkView = [self.checkmarkImageViews objectAtIndex:currentIndex];
        [checkmarkView setImage:fullCheckmark];
    }
}


// 点击查看大图
- (void)pic_taped:(UITapGestureRecognizer *)sender {
    CGSize scrollSize = myScrollView.contentSize;
    scrollSize.width = mainScreenWidth * [imgArray count];
    myScrollView.contentSize = scrollSize;
    [self tappedWithObject:sender.view];
}


- (void)img0_tap:(UITapGestureRecognizer *)sender {
    if([imgArray count] == 0) {
        [self showPictureSelection];
    } else {
        //        [SJAvatarBrowser showImage:self.img0];
        CGSize scrollSize = myScrollView.contentSize;
        scrollSize.width = mainScreenWidth * [imgArray count];
        myScrollView.contentSize = scrollSize;
        [self tappedWithObject:sender.view];
        [self setImages:imgArray];
    }
}

- (void)img1_tap:(UITapGestureRecognizer *)sender {
    if ([imgArray count] == 0) {
        return;
    } else if ([imgArray count] == 1) {
        [self showPictureSelection];
    } else {
        //        [SJAvatarBrowser showImage:self.img1];
        CGSize scrollSize = myScrollView.contentSize;
        scrollSize.width = mainScreenWidth * [imgArray count];
        myScrollView.contentSize = scrollSize;
        [self tappedWithObject:sender.view];
        [self setImages:imgArray];
    }
}

- (void)img2_tap:(UITapGestureRecognizer *)sender {
    if ([imgArray count] == 0 || [imgArray count] == 1) {
        return;
    } else if ([imgArray count] == 2) {
        [self showPictureSelection];
    } else {
        //        [SJAvatarBrowser showImage:self.img2];
        CGSize scrollSize = myScrollView.contentSize;
        scrollSize.width = mainScreenWidth * [imgArray count];
        myScrollView.contentSize = scrollSize;
        [self tappedWithObject:sender.view];
        [self setImages:imgArray];
    }
}

- (void)img3_tap:(UITapGestureRecognizer *)sender {
    if ([imgArray count] == 0 || [imgArray count] == 1 || [imgArray count] == 2) {
        return;
    } else if ([imgArray count] == 3) {
        [self showPictureSelection];
    } else {
        //        [SJAvatarBrowser showImage:self.img3];
        CGSize scrollSize = myScrollView.contentSize;
        scrollSize.width = mainScreenWidth * [imgArray count];
        myScrollView.contentSize = scrollSize;
        [self tappedWithObject:sender.view];
        [self setImages:imgArray];
    }
}

- (void)showPictureSelection {
    [self.view endEditing:YES];
    pictureAlert = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"pictureView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    [pictureAlert setCornerRadius:8.0];
    CGRect taskfilterFrame = taskFilter.frame;
    pictureAlert.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height - 10), taskfilterFrame.size.width, taskfilterFrame.size.height);
    pictureAlert.showView = taskFilter;
    UIButton *local = (UIButton *)[taskFilter viewWithTag:1];
    UIButton *camera = (UIButton *)[taskFilter viewWithTag:2];
    UIButton *cancel = (UIButton *)[taskFilter viewWithTag:3];
    [local addTarget:self action:@selector(local_pic) forControlEvents:UIControlEventTouchUpInside];
    [camera addTarget:self action:@selector(camera_pic) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(cancel_pic) forControlEvents:UIControlEventTouchUpInside];
    pictureAlert.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    [pictureAlert show];
}

- (void)local_pic {
    [self cancel_pic];
    [self addPicture:0];
}

- (void)camera_pic {
    [self cancel_pic];
    [self addPicture:1];
}

- (void)cancel_pic {
    [pictureAlert dismissAnimated:YES];
}



#pragma mark - UIPickerView delegate datasource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 5;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat width = (mainScreenWidth - 20) / 6.0;
    switch (component) {
        case 0:
            return 2 * width - 30;
            break;
        case 1:
        case 2:
        case 3:
        case 4:
            return width;
            break;
        default:
            break;
    }
    return 0;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            [pickerView reloadComponent:2];
            break;
        case 1:
            [pickerView reloadComponent:2];
            break;
        case 2:
            [pickerView reloadComponent:2];
            break;
        default:
            break;
    }
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (NSUInteger i = 0; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [imgArray addObject:tempImg];
    }
    [self showPicture];
    if([imgArray count] > 0) {
        //        self.addPicLabel.hidden = YES;
    }
}

#pragma mark - UIImagePicker delegate
// 成功获得相片还是视频后的回调 UIImagePickerController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // 手动保存拍照到本地
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    [imgArray addObject:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self showPicture];
    if([imgArray count] > 0) {
//        self.addPicLabel.hidden = YES;
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
}

#pragma mark - custom method
- (void) addSubImgView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (NSUInteger i = (4 - [imgArray count]); i <= 3; i++)
    {
        if ((i + [imgArray count] - 4) == currentIndex)
        {
            continue;
        }
        UIImageView *tmpView = (UIImageView *)[self.view viewWithTag:(10 + i)];
        
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
        
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){(i + [imgArray count] - 4) * myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:tmpView.image];
        [myScrollView addSubview:tmpImgScrollView];
        tmpImgScrollView.i_delegate = self;
        [tmpImgScrollView setAnimationRect];
    }
}

- (void) setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
    }];
}

#pragma mark - custom delegate
- (void) tappedWithObject:(id)sender
{
    NSNotification *notification = [NSNotification notificationWithName:@"hide_tab" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
    [self.view bringSubviewToFront:scrollPanel];
    [UIView animateWithDuration:0.5 animations:^{
        scrollPanel.alpha = 1.0;
    }];
    UIImageView *tmpView = sender;
    currentIndex = [imgArray count] - 1 + (tmpView.tag - 13);
    
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
    
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex*mainScreenWidth;
    myScrollView.contentOffset = contentOffset;
    //添加
    [self addSubImgView];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}

- (void) tapImageViewTappedWithObject:(id)sender
{
    // NSString *pressedText = [NSString stringWithFormat:@"Selected: %@", [self.selectedIndexes componentsJoinedByString:@", "]];
    // NSLog(@"pressedText:%@",pressedText);
    NSMutableArray *tmp = [imgArray mutableCopy];
    [imgArray removeAllObjects];
    for (NSUInteger i = 0; i < [self.selectedIndexes count]; i++) {
        NSNumber *num = [self.selectedIndexes objectAtIndex:i];
        [imgArray addObject:[tmp objectAtIndex:[num integerValue]]];
    }
    [self showPicture];
    ImgScrollView *tmpImgView = sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
        UIImageView *checkmarkView = [self.checkmarkImageViews objectAtIndex:currentIndex];
        checkmarkView.alpha = 0;
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
    }];
    NSNotification *notification = [NSNotification notificationWithName:@"show_tab" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
}

#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}



#pragma mark --- UITextviewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length > 0) {
        self.textVLabel.hidden = YES;
    }else {
        self.textVLabel.hidden = NO;
    }
    
    self.textNumLabel.text = [NSString stringWithFormat:@"剩余%lu字", 500 - (unsigned long)textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    else {
        if (textView.text.length - range.length + text.length > 500) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超出最大可输入长度" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        else {
            return YES;
        }
    }
    
    return YES;
}

- (IBAction)back:(id)sender {

    [self.contentTV resignFirstResponder];
    NSUInteger titleLength = [[self.contentTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
//    NSUInteger desLength = [[self.descriptionText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    if (titleLength > 0) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定取消发布任务吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [actionSheet showInView:self.view];
    }else {
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self clearConfirmed];
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (buttonIndex == 1){
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}


- (void)clearConfirmed{
    
//    [imgArray removeAllObjects];
//    [self showPicture];
}


#pragma mark --- 确定按钮
- (IBAction)popToDetailBtn:(id)sender {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * dictShow = [[NSMutableDictionary alloc] init];
    if ([self.flagStr isEqualToString:@"1"]) {
        
        if (self.contentTV.text.length == 0 && imgArray.count == 0) {
            
            [ProgressHUD show:@"竞标理由不能为空"];
            return;
        }
        
        if (self.skillShowBtn.selected == YES) {
//            [dictShow setObject:[NSString stringWithFormat:@"%@",self.contentTV.text] forKey:@"content"];
//            NSNotification *notification =[NSNotification notificationWithName:@"JoinBid" object:nil userInfo:dictShow];
//            //通过通知中心发送通知
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self postTaskSkillShow:NO];
        }
        
        [dic setObject:[NSString stringWithFormat:@"%@",self.contentTV.text] forKey:@"content"];
        [dic setObject:self.tidStr forKey:@"oid"];
        [dic setObject:@"1" forKey:@"flag"];
        // type = 2 代表是任务回复
        [dic setObject:[NSString stringWithFormat:@"%d",2] forKey:@"type"];
        // 不是回复别人，则reply_cid = 0
//        [dic setObject:@"0" forKey:@"reply_cid"];
        
        //添加 字典，将label的值通过key值设置传递
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"JoinBid" object:nil userInfo:dic];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        if (self.contentTV.text.length == 0 && imgArray.count == 0) {
            
            [ProgressHUD show:@"竞标理由不能为空"];
            return;
        }
        
        [dictShow setObject:[NSString stringWithFormat:@"%@",self.contentTV.text] forKey:@"content"];
        NSNotification *notification =[NSNotification notificationWithName:@"JoinBid" object:nil userInfo:dictShow];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];

        [self postTaskSkillShow:YES];
    }
}



#pragma mark --- 提交任务秀 ---
- (void)postTaskSkillShow:(BOOL) isLoading {
    
    if (isLoading) {
        
        [self startLoad];
    }
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:self.contentTV.text forKey:@"content"];
    [dict setObject:API_TOKEN_NUM forKey:API_TOKEN];
    NSString * url = [NSString stringWithFormat:@"%@?tid=%@", URL_TASK_SHOW, self.tidStr];
    
    [AFNetworkTool uploadImage:imgArray forKey:@"images[]" andParameters:dict toApiUrl:url success:^(NSData *data) {
        
        [self endLoad];
        NSError *error;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error) {
            // 请求成功，这里得到json数据
            if ( [[json objectForKey:@"error"] integerValue] == 0 ) {
                
                NSLog(@"result --- %@", json);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } fail:^{
        [self endLoad];
        [ProgressHUD show:HTTPREQUEST_ERROR];
    }];
}



#pragma mark --- 复选框选中
- (IBAction)skillShowBtnClick:(id)sender {
    
    if (self.skillShowBtn.selected == NO) {
        
        self.skillShowBtn.selected = YES;
        [self.skillShowBtn setImage:[UIImage imageNamed:@"复选框选中"] forState:UIControlStateNormal];
    }else {
        
        self.skillShowBtn.selected = NO;
        [self.skillShowBtn setImage:[UIImage imageNamed:@"复选框"] forState:UIControlStateNormal];
    }
}


#pragma mark - Custom Methods
- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
}


@end
