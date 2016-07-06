//
//  ghuntertaskViewController.m
//  ghunter
//
//  Created by chensonglu on 14-3-19.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//  任务详情页面

#import "ghuntertaskViewController.h"
#import "ghunterSkillViewController.h"
#import "ghunterWordChange.h"
#import "ghunterWebViewController.h"
#import "AFNetworkTool.h"
#import "SJAvatarBrowser.h"
#import "ghunterModifyTaskViewController.h"
#import "UMSocialQQHandler.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WXApi.h"
#import "ghunterMyNotUseDiscountViewController.h"
@interface ghuntertaskViewController ()
@property(nonatomic, retain) NSString *sendStr;

@property (strong, nonatomic) IBOutlet UIView *bg;


@property(strong,nonatomic) UIActionSheet *actionJoin;
@property(strong,nonatomic) UIActionSheet *actionCancel;
@property(strong,nonatomic) UIActionSheet *actionBack;
@property(strong,nonatomic) UIActionSheet *withdraw;
@property(strong,nonatomic) UIActionSheet *modifyWithdraw;
@property(strong,nonatomic) UIActionSheet *deleteComment;
@property(strong,nonatomic) UIActionSheet * rejectTaskShow;

// 接受拒绝任务
@property(strong, nonatomic) UIActionSheet *acceptPrivateTaskSheet;
@property(strong, nonatomic) UIActionSheet *refusePrivateTaskSheet;

@property(strong,nonatomic) UIView *popReportView;
@property(strong,nonatomic) UILabel *textTip;

@property(strong,nonatomic) HPGrowingTextView *reportText;
@property(strong,nonatomic) UIView *popContactView;

/*
 round view
*/
@property (strong, nonatomic) IBOutlet UIImageView *backImage;


@property (weak, nonatomic) IBOutlet UIView *masterApplyForRefund;
@property (weak, nonatomic) IBOutlet UIView *modifyRefundInfo;
//@property (weak, nonatomic) IBOutlet UIView *participateBidding;
//@property (weak, nonatomic) IBOutlet UIView *selectHunter;
//@property (weak, nonatomic) IBOutlet UIView *commentAndPay;
@property (weak, nonatomic) IBOutlet UIView *saveHunter;
//@property (weak, nonatomic) IBOutlet UIView *iWantComment;
//@property (weak, nonatomic) IBOutlet UIView *showComment;
@property (weak, nonatomic) IBOutlet UIView *modifyTask;
@property (weak, nonatomic) IBOutlet UIView *applyForRefund;
//@property (strong, nonatomic) IBOutlet UIImageView *taskCollect;
@property (strong, nonatomic) IBOutlet UIImageView *taskCollectImgV;

@property (weak, nonatomic) IBOutlet UIImageView *masterApplyForRefundAvatar;

@property (weak, nonatomic) IBOutlet UIImageView *selectHunterAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *saveHunterAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *iWantCommentAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *applyForRefundAvatar;

//@property (weak, nonatomic) IBOutlet UILabel *biddingLabel;

@property (assign,nonatomic)BOOL changeSomething;
@property (assign,nonatomic)NSString *isjoin;

@property(strong,nonatomic)UIView* faceView;

// 添加图片的View
@property(strong,nonatomic)UIView *addImgView;
@property (assign,nonatomic)BOOL isSender;
@property (assign,nonatomic)BOOL isSendimg;

@property(strong,nonatomic)UIScrollView* scrollView;
@property(strong,nonatomic)HPGrowingTextView* textView;

@property(strong,nonatomic)UIImageView *imgFromAlbumBtn;
@property(strong,nonatomic)UIImageView *imgFromCameraBtn;
@property (nonatomic, strong) NSString *immediatelyString;

@end

@implementation ghuntertaskViewController

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     addarray = [NSMutableArray array];
    self.selectedIndexes = [NSMutableArray array];
    self.checkmarkImageViews = [NSMutableArray array];
    self.user = [[NSMutableDictionary alloc] init];
    self.taskShowDict = [[NSMutableDictionary alloc] init];
    _immediatelyString = [[NSString alloc]init];

    preString = [[NSMutableString alloc] init];
    isBounty = NO;
    isGold = NO;
    isCoupon = NO;
    is4Show = NO;
    is4Comment = NO;
    
    self.isFeeLb = [[UILabel alloc] init];
    self.isCoinLb = [[UILabel alloc] init];
    self.isCodeLb = [[UILabel alloc] init];
    _isfee = [[UILabel alloc]init];
    _iscoinfee = [[UILabel alloc]init];
    _iscodeid = [[UILabel alloc]init];
    [self didGetTaskDetailIsloading:YES isWithCommets:YES];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    imgarray = [NSMutableArray array];
    _backImage.layer.cornerRadius = 8.0;
    dataimgarr = [NSMutableArray array];
    // 评论参数
    skdic = [[NSMutableDictionary alloc] init];
    taskShowArray = [[NSMutableArray alloc] init];
    commentCount = 0;
    
    [self Evaluation:nil];
    [self coment:nil];
    
    self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(65.5, 6, mainScreenWidth - 103, 30)];
    self.textView.backgroundColor=[UIColor clearColor];
    self.textView.returnKeyType = UIReturnKeyDone;    //just as an example
    self.textView.font = [UIFont systemFontOfSize:13.0f];
    self.textView.delegate = self;
    self.textView.maxNumberOfLines = 5;
    self.textView.layer.cornerRadius = 6.0;
    
    [toolBar addSubview:self.textView];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    toolBar.frame = CGRectMake(0, mainScreenheight, mainScreenWidth, toolBar.frame.size.height);
    toolBar.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // 发送表情面板
    _faceView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 170)];
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 140)];
    for (int i=0; i<3; i++) {
        UIView* face=[[UIView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 140)];
        for (int j=0; j<3; j++) {
            //column numer
            for (int k=0; k<7; k++) {
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                
                button.tag=j*7+k+(i*21)+1;
                NSString *imageName;
                if(button.tag==21||button.tag==42||button.tag==63)
                {
                    [button setImage:[UIImage imageNamed:@"emoji_delete.png"] forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(0+k*45, 0+j*45, 45, 45)];
                }
                else
                {
                    imageName=[NSString stringWithFormat:@"%zd.png",button.tag];
                    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(10+k*45, 10+j*45, 25, 25)];
                }
                [button setBackgroundColor:[UIColor clearColor]];
                [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                face.backgroundColor=[UIColor whiteColor];
                [face addSubview:button];
            }
        }
        [_scrollView addSubview:face];
    }
    _scrollView.contentSize=CGSizeMake(mainScreenWidth*3, 140);
    _scrollView.delegate=self;
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces=NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _faceView.backgroundColor = [UIColor colorWithRed:228/255.0 green:227/255.0 blue:220/255.0 alpha:1.0];
    [_faceView addSubview:_scrollView];
    
    UIButton* sendBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    sendBtn.frame=CGRectMake(255, 143, 50, 25);
    [sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    sendBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"input_circle_bg.png"] forState:UIControlStateNormal];
    [_faceView addSubview:sendBtn];
    _faceView.hidden=YES;
    
    _addImgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 170)];
    _addImgView.backgroundColor = [UIColor whiteColor];
    
    _imgFromAlbumBtn = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth/4 - 30, 50, 40, 40)];
    _imgFromCameraBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0.75*mainScreenWidth-30, 50, 40, 40)];
    
    UILabel *albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/4 - 30, 95, 40, 15)];
    UILabel *cameraLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.75*mainScreenWidth - 30, 95, 40, 15)];
    
    [albumLabel setText:@"相册"];
    albumLabel.textAlignment = NSTextAlignmentCenter;
    [albumLabel setTextColor:[UIColor darkGrayColor]];
    [albumLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [cameraLabel setText:@"拍照"];
    [cameraLabel setFont:[UIFont systemFontOfSize:15.0f]];
    cameraLabel.textAlignment = NSTextAlignmentCenter;
    [cameraLabel setTextColor:[UIColor darkGrayColor]];
    UITapGestureRecognizer *ablumGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getChatImgFromAlbum)];
    UITapGestureRecognizer *cameraGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getChatImgFromCamera)];
    
    [_imgFromAlbumBtn setUserInteractionEnabled:YES];
    [_imgFromCameraBtn setUserInteractionEnabled:YES];
    [_imgFromCameraBtn addGestureRecognizer:cameraGesture];
    [_imgFromAlbumBtn addGestureRecognizer:ablumGesture];
    [_imgFromAlbumBtn setImage:[UIImage imageNamed:@"手机照片"]];
    [_imgFromCameraBtn setImage:[UIImage imageNamed:@"相机拍照"]];
    [_addImgView addSubview:_imgFromCameraBtn];
    [_addImgView addSubview:_imgFromAlbumBtn];
    [_addImgView addSubview:albumLabel];
    [_addImgView addSubview:cameraLabel];
    [_addImgView setHidden:YES];
    
    _bg.backgroundColor = Nav_backgroud;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
//    scrollPanel = [[UIView alloc] initWithFrame:self.view.bounds];
    scrollPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 0;
    [self.view addSubview:scrollPanel];
    
    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = mainScreenWidth;
    myScrollView.contentSize = contentSize;
    
    to_comment = 0;
    imgArray = [[NSMutableArray alloc] init];
    _isSender = NO;
    _isSendimg = NO;
    
    textViewTip.layer.cornerRadius=8.0;
    
    self.refusedModifyBG.layer.cornerRadius = 15.0;
    self.refusedApplyWithDrawBG.layer.cornerRadius = 15.0;
    self.hunterAcceptBG.layer.cornerRadius = 15.0;
    self.hunterRefuseBG.layer.cornerRadius = 15.0;
    
    self.participateBiddingAvatar.clipsToBounds = YES;
    self.selectHunterAvatar.clipsToBounds = YES;
    self.commentAndPayAvatar.clipsToBounds = YES;
    self.saveHunterAvatar.clipsToBounds = YES;
    self.iWantCommentAvatar.clipsToBounds = YES;
//    self.showComment.layer.cornerRadius = 2;
//    self.showComment.clipsToBounds = YES;
    self.modifyRefundInfo.clipsToBounds = YES;
    self.modifyRefundInfo.layer.cornerRadius = 2;
    self.masterApplyForRefund.clipsToBounds = YES;
    self.masterApplyForRefund.layer.cornerRadius = 2;
    self.iWantComment.clipsToBounds = YES;
    self.iWantComment.layer.cornerRadius = 2.0;
//    self.selectHunterAvatar.layer.cornerRadius = 15.0;
    self.commentAndPayAvatar.layer.cornerRadius = 15.0;
    self.saveHunterAvatar.layer.cornerRadius = 15.0;
    self.iWantCommentAvatar.layer.cornerRadius = 15.0;
    
    self.sendStr = @"";
    page = 1;
    collected = NO;
    requested = NO;
    
    task = [[NSMutableDictionary alloc] init];
    taskcommentArray = [[NSMutableArray alloc] init];
    account = [[NSMutableDictionary alloc] init];
    [account setObject:@"0" forKey:@"balance"];
    taskTable = [[PullTableView alloc]initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64 - 44) style:UITableViewStylePlain];
    taskTable.delegate = self;
    taskTable.dataSource = self;
    taskTable.pullDelegate = self;
    taskTable.backgroundColor = [UIColor clearColor];
    taskTable.showsVerticalScrollIndicator = YES;
    taskTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:taskTable];
    //隐藏单元格上下滚动条
    taskTable.showsVerticalScrollIndicator = NO;
    tasktailView = [[UIView alloc] initWithFrame:CGRectMake(0, mainScreenheight - 44, mainScreenWidth, 44)];
    [self.view addSubview:tasktailView];
    
    // 适应屏幕
    self.bidView.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    self.choosehunterView.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    self.payView.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    self.contactView.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    self.commentedView.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    self.withdrawForGold.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    self.withDrawForHunter.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    self.overTimeView.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    self.comment.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    toolBar.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    self.buyskillHunterDealView.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    self.orienttaskOwnerDeal.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    self.failView.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    
    self.leftBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3, 0, 1, 44)];
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3 * 2 + 1, 0, 1, 44)];
    self.leftBtn.backgroundColor = RGBCOLOR(235, 235, 235);
    self.rightBtn.backgroundColor =  RGBCOLOR(235, 235, 235);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GHUNTERMODIFY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modify:) name:GHUNTERMODIFY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GHUNTERSELECTHUNTER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectHunterOK:) name:GHUNTERSELECTHUNTER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"back_doing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back_doing:) name:@"back_doing" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"handle_withdraw" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_withdraw:) name:@"handle_withdraw" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pay_comment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pay_comment:) name:@"pay_comment" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JoinBid:) name:@"JoinBid" object:nil];
    
    [self.view addSubview:_addImgView];
    [self.view addSubview:_faceView];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    self.titleLabel.text=@"任务详情";
    [dic setObject:self.tid forKey:@"tid"];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    
    [self.view endEditing:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
}

- (void)viewDidAppear:(BOOL)animated {
    if(imgondar_islogin) {
        [tasktailView setUserInteractionEnabled:YES];
    }else {
        [tasktailView setUserInteractionEnabled:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    
    if (!self.changeSomething) {
        [self callBackBlock]();
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GHUNTERMODIFY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GHUNTERSELECTHUNTER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"back_doing" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"handle_withdraw" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pay_comment" object:nil];
    
    // 修改修改定向任务后，用通知刷新本页
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"update_task_succeed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePage) name:@"update_task_succeed" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JoinBid" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark --- 参与竞标的返回通知
- (void)JoinBid:(NSNotification *) notify{
    
    contentStr = notify.userInfo[@"content"];
    if ([notify.userInfo[@"flag"] isEqualToString:@"1"]) {
        
        _isjoin = @"2";
        [self didJoinTaskIsloading:YES];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSString stringWithFormat:@"%@%@",self.sendStr, contentStr] forKey:@"content"];
        [dic setObject:self.tid forKey:@"oid"];
        
        [self didSendComment:dic isloading:YES];
    }else {
        
    }
}



#pragma mark--- 举报框让键盘谈起
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    reportAlertView.frame = CGRectMake(0, 0  , ScreenWidthFull, ScreenHeightFull);
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    reportAlertView.frame = [[UIScreen mainScreen] bounds];
    [UIView commitAnimations];
}


#pragma marl --- 
-(void)commentClickBtn:(UIButton *) sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    [self.view addSubview:toolBar];
    [self.view addSubview:addedImageLayout];
    if ( [dataimgarr count] > 0 ) {
        addedImageLayout.hidden = NO;
    }else{
        addedImageLayout.hidden = YES;
    }
    self.reply_cid = @"";
    self.reply_uid = @"";
    textViewTip.text = @"";
    textViewTip.hidden = YES;
    [self.textView becomeFirstResponder];
}


#pragma mark - AFNetworking methods
// 获取猎人信息
-(void)didGetHUnterInfoIsloading:(BOOL )isloading{
    if (isloading) {
        [self startLoad];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.uid forKey:@"uid"];
    [AFNetworkTool httpRequestWithUrl:URL_GET_USER_CENTER params:dic success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            self.user = [[result objectForKey:@"user"] mutableCopy];
            Monitor *data = [Monitor sharedInstance];
            data.remark = @"remark";
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}

#pragma mark - Keyboard Notification

- (void)keyboardWillShow:(NSNotification *)notification {
    UITextField *reward = (UITextField *)[tipAlertView.showView viewWithTag:106];
    if (!reward.inputAccessoryView) {
        [reward setInputAccessoryView:toolBar];
    }
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
    // 获得键盘高度
    CGFloat keyboardHeight = keyboardFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
   
    NSTimeInterval animationDuration1 = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration1];
    rewardView.frame = CGRectMake(0, -keyboardHeight, mainScreenWidth, ScreenHeightFull);
    [UIView commitAnimations];
    
    [UIView animateWithDuration:animationDuration
     animations:^{
         if ([self.textView isFirstResponder]) {
             CGRect frame = toolBar.frame;
             frame.origin.y = mainScreenheight - frame.size.height - keyboardHeight;
             toolBar.frame = frame;
             
             CGRect frame2 = addedImageLayout.frame;
             frame2.origin.y = mainScreenheight - frame.size.height - keyboardHeight - frame2.size.height;
             addedImageLayout.frame = frame2;
             
             _isSendimg = NO;
             _isSender = NO;
             _addImgView.hidden = YES;
             _faceView.hidden = YES;
         } else if ([self.reportText isFirstResponder]) {
             CGRect frame = reportAlertView.containerView.frame;
             frame.origin.y = keyboardRect.origin.y - reportAlertView.containerView.frame.size.height;
             reportAlertView.containerView.frame = frame;
             [reportAlertView layoutSubviews];
         } else if ([reward isFirstResponder]) {
             CGRect frame = tipAlertView.containerView.frame;
             frame.origin.y = keyboardRect.origin.y - tipAlertView.containerView.frame.size.height;
             tipAlertView.containerView.frame = frame;
         }
     }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
  
    NSTimeInterval animationDuration1 = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration1];
    rewardView.frame = [[UIScreen mainScreen] bounds];
    [UIView commitAnimations];
    
    [UIView animateWithDuration:animationDuration
     animations:^{
         UITextField *reward = (UITextField *)[tipAlertView.showView viewWithTag:106];
         if(self.textView.isFirstResponder) {
             if ( _isSender || _isSendimg ) {
                 if (_faceView.hidden == YES || _faceView.hidden == YES) {
                     CGRect frame = toolBar.frame;
                     frame.origin.y = mainScreenheight - frame.size.height - 170;
                     toolBar.frame = frame;
                     
                     CGRect frame2 = addedImageLayout.frame;
                     frame2.origin.y = mainScreenheight - frame.size.height - 170 - frame2.size.height;
                     addedImageLayout.frame = frame2;
                 }
             }else{
                 [toolBar removeFromSuperview];
                 [addedImageLayout removeFromSuperview];
             }
         } else if (self.reportText.isFirstResponder) {
             CGRect frame = reportAlertView.containerView.frame;
             frame.origin.y = mainScreenheight - reportAlertView.containerView.frame.size.height - 10;
             reportAlertView.containerView.frame = frame;
             [reportAlertView layoutSubviews];
         } else if ([reward isFirstResponder]) {
             CGRect frame = tipAlertView.containerView.frame;
             frame.origin.y = mainScreenheight - tipAlertView.containerView.frame.size.height - 10;
             tipAlertView.containerView.frame = frame;
             [tipAlertView dismissAnimated:YES];
         }
     }];
}

#pragma mark - ASIHttpRequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_BACK_BIDDING]){
        // 竞标中的任务，申请退款成功
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:[dic objectForKey:@"msg"] waitUntilDone:false];
            
            [self didGetTaskDetailIsloading:NO isWithCommets:NO];
        }else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REPORT]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:[dic objectForKey:@"msg"] waitUntilDone:false];
        }else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_MY_ACCOUNT]){
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            account = [dic objectForKey:@"account"];
            UILabel *balance = (UILabel *)[tipAlertView.showView viewWithTag:-1];
            [balance setText:[NSString stringWithFormat:@"￥%@",[account objectForKey:@"balance"]]];
        }else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }
    else if([[request.userInfo objectForKey:REQUEST_TYPE] isEqual:REQUEST_FOR_NEW_ADD_COLLECTION] || [[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_NEW_DELETE_COLLECTION])
    {
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            collected = !collected;
            if (!collected) {
                    [self.taskCollectImgV setImage:[UIImage imageNamed:@"收藏"]];
               
                collected = NO;
            } else {
                    [self.taskCollectImgV setImage:[UIImage imageNamed:@"收藏-拷贝"]];
               
                collected = YES;
            }
            NSString *errorMsg = [dic objectForKey:@"msg"];
            [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:errorMsg waitUntilDone:false];
        }
        else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }else if([[request.userInfo objectForKey:REQUEST_TYPE] isEqual:REQUEST_FOR_DEAL_PRIVAE_TASK])
    {
        // 接受或拒绝私密任务
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            // 弹出提示
            [ProgressHUD show:[dic objectForKey:@"msg"]];
            
            [self didGetTaskDetailIsloading:NO isWithCommets:NO];
        }
        else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self endLoad];
    taskTable.pullTableIsRefreshing = NO;
    taskTable.pullTableIsLoadingMore = NO;
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
}

#pragma mark - 获得任务详情
- (void)didGetTaskDetailIsloading:(BOOL)isloading isWithCommets:(BOOL)isWithComments{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?tid=%@", URL_GET_TASK_DETAIL, self.tid] params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            
            task = [result objectForKey:@"task"];
            NSDictionary *info = [task objectForKey:@"info"];
            NSString *status = [info objectForKey:@"status"];   // 注意必须是 string 类型
            status = [NSString stringWithFormat:@"%@", status];
            
            NSString *isowner = [info objectForKey:@"isowner"];
            _isjoin = [info objectForKey:@"isjoin"];
            NSString *iscollect = [info objectForKey:@"iscollect"];
            NSString *isvaluated = [info objectForKey:@"isvaluated"];
            
            imgArray = [task objectForKey:@"images"];
            for (UIView *view in [tasktailView subviews]) {
                [view removeFromSuperview];
            }
            if (!imgondar_islogin) {
                //未登录
                self.commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (mainScreenWidth - 2) / 3, 44)];
                self.commentBtn.backgroundColor = [UIColor clearColor];
                [self.commentBtn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
                [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
                [self.commentBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
                self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [self.bidView addSubview:self.commentBtn];
                [self.commentBtn addTarget:self action:@selector(commentClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self.bidView addSubview:self.leftBtn];
                [self.bidView addSubview:self.rightBtn];
                
                self.sendMessageBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3 * 2 + 1, 0, (mainScreenWidth - 2) / 3, 44)];
                self.sendMessageBtn.backgroundColor = [UIColor clearColor];
                [self.sendMessageBtn setImage:[UIImage imageNamed:@"咨询"] forState:UIControlStateNormal];
                [self.sendMessageBtn setTitle:@"私信" forState:UIControlStateNormal];
                [self.sendMessageBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
                self.sendMessageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [self.bidView addSubview:self.sendMessageBtn];
                [self.sendMessageBtn addTarget:self action:@selector(privateMessage:) forControlEvents:UIControlEventTouchUpInside];
                
                self.participateBidding = [[UIView alloc] initWithFrame:CGRectMake(self.leftBtn.frame.origin.x*1.5-40, 8,80, 28)];
                self.participateBidding.clipsToBounds = YES;
                self.participateBidding.layer.cornerRadius = 2;
                self.participateBidding.backgroundColor = RGBCOLOR(234, 85, 20);
                self.participateBidding.userInteractionEnabled = YES;
                [self.bidView addSubview:self.participateBidding];
                
                
                self.participateBiddingAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 17, 17)];
                self.participateBiddingAvatar.userInteractionEnabled = YES;
                [self.participateBidding addSubview:self.participateBiddingAvatar];
                self.participateBiddingAvatar.image = [UIImage imageNamed:@"立即竞标"];
                self.biddingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.participateBiddingAvatar.frame.origin.x + 15, 2, self.rightBtn.frame.origin.x - self.leftBtn.frame.origin.x - 20, 25)];
                self.biddingLabel.text = @"参与竞标";
                self.biddingLabel.textColor = [UIColor whiteColor];
                self.biddingLabel.font = [UIFont systemFontOfSize:14];
                self.biddingLabel.userInteractionEnabled = YES;
                [self.participateBidding addSubview:self.biddingLabel];
                
                self.joinBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3  + 1, 0, (mainScreenWidth - 2) / 3, 44)];
                self.joinBtn.backgroundColor = [UIColor clearColor];
                
                [self.bidView addSubview:self.joinBtn];
                [self.joinBtn addTarget:self action:@selector(click2Login) forControlEvents:UIControlEventTouchUpInside];
                
                [tasktailView addSubview:self.bidView];
               
            }else{
                //登陆 猎人 竞标中
                if([isowner isEqualToString:@"0"])
                {
                    if ([iscollect isEqualToString:@"0"])
                    {
                            [self.taskCollectImgV setImage:[UIImage imageNamed:@"收藏"]];
                       
                        collected = NO;
                    } else {
                            [self.taskCollectImgV setImage:[UIImage imageNamed:@"收藏-拷贝"]];
                       
                        collected = YES;
                    }
                    
                    if([status isEqualToString:@"1"]){
                        
                        self.commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (mainScreenWidth - 2) / 3, 44)];
                        self.commentBtn.backgroundColor = [UIColor clearColor];
                        [self.commentBtn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
                        [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
                        [self.commentBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
                        self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                        [self.bidView addSubview:self.commentBtn];
                        [self.commentBtn addTarget:self action:@selector(commentClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [self.bidView addSubview:self.leftBtn];
                        [self.bidView addSubview:self.rightBtn];
                        
                        self.sendMessageBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3 * 2 + 1, 0, (mainScreenWidth - 2) / 3, 44)];
                        self.sendMessageBtn.backgroundColor = [UIColor clearColor];
                        [self.sendMessageBtn setImage:[UIImage imageNamed:@"咨询"] forState:UIControlStateNormal];
                        [self.sendMessageBtn setTitle:@"私信" forState:UIControlStateNormal];
                        [self.sendMessageBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
                        self.sendMessageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                        [self.bidView addSubview:self.sendMessageBtn];
                        [self.sendMessageBtn addTarget:self action:@selector(privateMessage:) forControlEvents:UIControlEventTouchUpInside];
                        
                        self.participateBidding = [[UIView alloc] initWithFrame:CGRectMake(self.leftBtn.frame.origin.x*1.5-40, 8,80, 28)];
                        self.participateBidding.clipsToBounds = YES;
                        self.participateBidding.layer.cornerRadius = 2;
                        self.participateBidding.backgroundColor = RGBCOLOR(234, 85, 20);
                        self.participateBidding.userInteractionEnabled = YES;
                        [self.bidView addSubview:self.participateBidding];
                        
                        
                        self.participateBiddingAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 17, 17)];
                        self.participateBiddingAvatar.userInteractionEnabled = YES;
                        [self.participateBidding addSubview:self.participateBiddingAvatar];
                        self.participateBiddingAvatar.image = [UIImage imageNamed:@"立即竞标"];
                        
                        self.joinBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3  + 1, 0, (mainScreenWidth - 2) / 3, 44)];
                        self.joinBtn.backgroundColor = [UIColor clearColor];
                        
                        [self.bidView addSubview:self.joinBtn];
                        [self.joinBtn addTarget:self action:@selector(bid:) forControlEvents:UIControlEventTouchUpInside];
                        
                        self.biddingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.participateBiddingAvatar.frame.origin.x + 15, 2, self.rightBtn.frame.origin.x - self.leftBtn.frame.origin.x - 20, 25)];
                        self.biddingLabel.text = @"参与竞标";
                        //                        self.biddingLabel.backgroundColor = [UIColor blackColor];
                        self.biddingLabel.textColor = [UIColor whiteColor];
                        self.biddingLabel.font = [UIFont systemFontOfSize:14];
                        self.biddingLabel.userInteractionEnabled = YES;
                        [self.participateBidding addSubview:self.biddingLabel];
                        self.bidView.userInteractionEnabled = YES;
                        [tasktailView addSubview:self.bidView];
                        [self setBidButtonStatus:_isjoin];
                        
                    }else if ([status isEqualToString:@"2"]){
                        NSDictionary *taskuser = [task objectForKey:@"tradeuser"];
                        if([[taskuser objectForKey:UID] isEqualToString:[ghunterRequester getUserInfo:UID]]) {
                            [tasktailView addSubview:self.contactView];
                        } else {
                            [tasktailView addSubview:self.failView];
                            UILabel *text = (UILabel *)[self.failView viewWithTag:1];
                            [text setText:@"该任务正在进行"];
                        }
                    }else if ([status isEqualToString:@"3"]){
                        NSDictionary *taskuser = [task objectForKey:@"tradeuser"];
                        if([[taskuser objectForKey:UID] isEqualToString:[ghunterRequester getUserInfo:UID]]) {
                            if([isvaluated isEqualToString:@"0"]){
                                
                                // 我要评价
                                self.phoneHunterBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 1) / 2 + 0.5, 0, (mainScreenWidth - 1) / 2, 44)];
                                [self.comment addSubview:self.phoneHunterBtn];
                                self.phoneHunterBtn.backgroundColor = [UIColor clearColor];
                                [self.phoneHunterBtn setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
                                [self.phoneHunterBtn setTitle:@"联系Ta" forState:UIControlStateNormal];
                                [self.phoneHunterBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
                                self.phoneHunterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                                [self.comment addSubview:self.phoneHunterBtn];
                                [self.phoneHunterBtn addTarget:self action:@selector(phoneHhunter:) forControlEvents:UIControlEventTouchUpInside];
                                
                                self.iWantComment = [[UIView alloc] initWithFrame:CGRectMake(20, 6, (mainScreenWidth - 1) / 2 - 40, 36)];
                                [self.comment addSubview:self.iWantComment];
                                self.iWantComment.backgroundColor = RGBCOLOR(234, 85, 20);
                                self.iWantComment.clipsToBounds = YES;
                                self.iWantComment.layer.cornerRadius = 2.0;
                                self.iWantImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 33, 33)];
                                self.iWantImg.userInteractionEnabled = YES;
                                [self.iWantComment addSubview:self.iWantImg];
                                self.iWantImg.image = [UIImage imageNamed:@"white_hunter"];
                                self.iWantLb = [[UILabel alloc] initWithFrame:CGRectMake(self.iWantImg.frame.size.width + self.iWantImg.frame.origin.x + 10, 6, 60, 20)];
                                self.iWantLb.text = @"我要评价";
                                [self.iWantComment addSubview:self.iWantLb];
                                self.iWantLb.textColor = [UIColor whiteColor];
                                self.iWantLb.font = [UIFont systemFontOfSize:13];
                                self.iWantLb.userInteractionEnabled = YES;
                                
                                UIView * centerView = [[UIView alloc] initWithFrame:CGRectMake(mainScreenWidth / 2 - 0.5, 0, 1, 44)];
                                [self.comment addSubview:centerView];
                                centerView.backgroundColor = RGBCOLOR(235, 235, 235);
                                
                                self.commentTaskBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (mainScreenWidth - 1) / 2, 44)];
                                [self.comment addSubview:self.commentTaskBtn];
                                [self.commentTaskBtn addTarget:self action:@selector(commentTask:) forControlEvents:UIControlEventTouchUpInside];
                                
                                [tasktailView addSubview:self.comment];
                            }else{
                                // 查看评价
                                self.contactHunterEvaBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 1) / 2 + 0.5, 0, (mainScreenWidth - 1) / 2, 44)];
                                self.contactHunterEvaBtn.backgroundColor = [UIColor clearColor];
                                [self.contactHunterEvaBtn setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
                                [self.contactHunterEvaBtn setTitle:@"联系Ta" forState:UIControlStateNormal];
                                [self.contactHunterEvaBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
                                self.contactHunterEvaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                                [self.commentedView addSubview:self.contactHunterEvaBtn];
                                [self.contactHunterEvaBtn addTarget:self action:@selector(contactAfterFinish:) forControlEvents:UIControlEventTouchUpInside];
                                UIView * centerView = [[UIView alloc] initWithFrame:CGRectMake(mainScreenWidth / 2 - 0.5, 0, 1, 44)];
                                centerView.backgroundColor = RGBCOLOR(235, 235, 235);
                                [self.commentedView addSubview:centerView];
                                
                                self.showCommentView = [[UIView alloc] initWithFrame:CGRectMake(20, 6, centerView.frame.origin.x - 40, 36)];
                                self.showCommentView.backgroundColor = RGBCOLOR(234, 85, 20);
                                [self.commentedView addSubview:self.showCommentView];
                                
                                self.evaImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 17, 17)];
                                [self.showCommentView addSubview:self.evaImage];
                                self.evaImage.image = [UIImage imageNamed:@"task_pay"];
                                self.evaLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.evaImage.frame.origin.x + self.evaImage.frame.size.width + 5, 7, 60, 20)];
                                self.evaLabel.textColor = [UIColor whiteColor];
                                self.evaLabel.font = [UIFont systemFontOfSize:14];
                                self.evaLabel.text = @"查看评价";
                                [self.showCommentView addSubview:self.evaLabel];
                                
                                self.evaBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (mainScreenWidth - 1) / 2, 44)];
                                [self.evaBtn addTarget:self action:@selector(showComment:) forControlEvents:UIControlEventTouchUpInside];
                                [self.showCommentView addSubview:self.evaBtn];

                                [tasktailView addSubview:self.commentedView];
                            }
                        } else {
                            [tasktailView addSubview:self.failView];
                            UILabel *text = (UILabel *)[self.failView viewWithTag:1];
                            [text setText:@"该任务已完成"];
                        }
                    }else if ([status isEqualToString:@"4"]){
                        [tasktailView addSubview:self.failView];
                        UILabel *text = (UILabel *)[self.failView viewWithTag:1];
                        [text setText:@"任务已过期"];
                    }else if ([status isEqualToString:@"6"]){
                        [tasktailView addSubview:self.failView];
                        UILabel *text = (UILabel *)[self.failView viewWithTag:1];
                        [text setText:@"任务已退款"];
                    }else if([status isEqualToString:@"5"]){
                        // 状态为5的任务是被后台屏蔽掉的任务
                        // 修改by汪小熊 2015-02-17
                        [tasktailView addSubview:self.failView];
                        UILabel *text = (UILabel *)[self.failView viewWithTag:1];
                        [text setText:@"任务已被屏蔽"];
                    }else if ([status isEqualToString:@"7"]){
                        NSDictionary *taskuser = [task objectForKey:@"tradeuser"];
                        if([[taskuser objectForKey:UID] isEqualToString:[ghunterRequester getUserInfo:UID]]) {
                            NSDictionary *withdraw = [task objectForKey:@"withdraw"];
                            NSString *result = [withdraw objectForKey:@"dealresult"];
                            if([result isEqualToString:@"0"]){
                                [tasktailView addSubview:self.withDrawForHunter];
                                UILabel *info = (UILabel *)[self.withDrawForHunter viewWithTag:1];
                                [info setText:@"主人申请退款，点击处理"];
                            }else if ([result isEqualToString:@"1"]){
                                [tasktailView addSubview:self.failView];
                                UILabel *text = (UILabel *)[self.failView viewWithTag:1];
                                [text setText:@"任务已退款"];
                            }else if ([result isEqualToString:@"2"]){
                                [tasktailView addSubview:self.withDrawForHunter];
                                UILabel *info = (UILabel *)[self.withDrawForHunter viewWithTag:1];
                                [info setText:@"已处理：不同意退款"];
                            }
                        } else {
                            [tasktailView addSubview:self.failView];
                            UILabel *text = (UILabel *)[self.failView viewWithTag:1];
                            [text setText:@"该任务正在进行"];
                        }
                    }
                    else if([status isEqualToString:@"8"]){
                        // 等待猎人应邀的私密任务
                        [tasktailView addSubview:self.buyskillHunterDealView];
                    }else if([status isEqualToString:@"9"]){
                        // 私密任务，猎人已拒绝，主人可以修改任务和退款，猎人只能看到已拒绝
                        [tasktailView addSubview:self.failView];
                        UILabel *text = (UILabel *)[self.failView viewWithTag:1];
                        [text setText:@"已拒绝该任务"];
                    }
                }else if ([isowner isEqualToString:@"1"]){
                    //登陆 赏金 竞标中 任务主人
                    self.taskCollectImgV.hidden = YES;
                    if([status isEqualToString:@"1"]){
                        // 选择猎人
                        self.selectView = [[UIView alloc] initWithFrame:CGRectMake( self.leftBtn.frame.origin.x*0.5 - 45, 7,90, 33)];
                        [self.choosehunterView addSubview:self.selectView];
                        self.selectView.backgroundColor = RGBCOLOR(234, 85, 20);
                        self.selectView.clipsToBounds = YES;
                        self.selectView.layer.cornerRadius = 2;
                        
                        self.selectImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
                        [self.selectView addSubview:self.selectImg];
                        self.selectImg.userInteractionEnabled = YES;
                        self.selectImg.image = [UIImage imageNamed:@"white_hunter"];
                        self.selectLb = [[UILabel alloc] initWithFrame:CGRectMake(self.selectView.frame.size.width-60, 6, 55, 20)];
                        self.selectLb.text = @"选择猎人";
                        self.selectLb.userInteractionEnabled = YES;
                        self.selectLb.textColor = [UIColor whiteColor];
                        self.selectLb.font = [UIFont systemFontOfSize:13];
                        [self.selectView addSubview:self.selectLb];
                        self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (mainScreenWidth - 2) / 3, 44)];
                        [self.choosehunterView addSubview:self.selectBtn];
                        [self.choosehunterView addSubview:self.leftBtn];
                        [self.choosehunterView addSubview:self.rightBtn];
                        [self.selectBtn addTarget:self action:@selector(selectHunter:) forControlEvents:UIControlEventTouchUpInside];
                        
                        self.moreBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3 * 2 + 2, 0, (mainScreenWidth - 2) / 3, 44)];
                        [self.choosehunterView addSubview:self.moreBtn];
                        [self.moreBtn setImage:[UIImage imageNamed:@"更多内容"] forState:UIControlStateNormal];
                        self.moreBtn.userInteractionEnabled = YES;
                        [self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
                        [self.moreBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
                        self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                        [self.moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
                        
                        self.selectCommentBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3 + 1, 0, (mainScreenWidth - 2) / 3, 44)];
                        [self.choosehunterView addSubview:self.selectCommentBtn];
                        [self.selectCommentBtn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
                        self.selectCommentBtn.userInteractionEnabled = YES;
                        [self.selectCommentBtn setTitle:@"评论" forState:UIControlStateNormal];
                        [self.selectCommentBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
                        self.selectCommentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                        [self.selectCommentBtn addTarget:self action:@selector(selectComment:) forControlEvents:UIControlEventTouchUpInside];
                        [self.choosehunterView addSubview:self.leftBtn];
                        [self.choosehunterView addSubview:self.rightBtn];
                        
                        [tasktailView addSubview:self.choosehunterView];
                    }else if ([status isEqualToString:@"2"]){
                        // 评价支付
                        self.commentAndPay = [[UIView alloc] initWithFrame:CGRectMake(10, 10, (mainScreenWidth - 2) / 3 - 20, 25)];
                        self.commentAndPay.clipsToBounds = YES;
                        self.commentAndPay.layer.cornerRadius = 2.0;
                        self.commentAndPay.backgroundColor = RGBCOLOR(234, 85, 20);
                        [self.payView addSubview:self.commentAndPay];
                        self.commentAndPayAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(9, 4, 17, 17)];
                        self.commentAndPayAvatar.userInteractionEnabled = YES;
                        self.commentAndPayAvatar.image = [UIImage imageNamed:@"task_pay"];
                        [self.commentAndPay addSubview: self.commentAndPayAvatar];
                        [self.commentAndPay addSubview:[self leftBtn]];
                        [self.commentAndPay addSubview:[self rightBtn]];
                        self.commentAndPayLb = [[UILabel alloc] initWithFrame:CGRectMake(self.commentAndPayAvatar.frame.origin.x + 5, 3, self.commentAndPay.frame.size.width - 17, 20)];
                        self.commentAndPayLb.userInteractionEnabled = YES;
                        self.commentAndPayLb.text = @"评价并支付";
                        self.commentAndPayLb.textAlignment = NSTextAlignmentCenter;
                        self.commentAndPayLb.textColor = [UIColor whiteColor];
                        self.commentAndPayLb.font = [UIFont systemFontOfSize:13];
                        [self.commentAndPay addSubview:self.commentAndPayLb];
                        
                        self.confirmPay = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (mainScreenWidth - 2) / 3, 44)];
                        [self.payView addSubview:self.confirmPay];
                        [self.confirmPay addTarget:self action:@selector(confirmPay:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        [self.payView addSubview:self.leftBtn];
                        [self.payView addSubview:self.rightBtn];
                        
                        self.contactHunterBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3 + 1, 0, (mainScreenWidth - 2) / 3, 44)];
                        [self.payView addSubview:self.contactHunterBtn];
                        [self.contactHunterBtn setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
                        self.contactHunterBtn.userInteractionEnabled = YES;
                        [self.contactHunterBtn setTitle:@"联系猎人" forState:UIControlStateNormal];
                        [self.contactHunterBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
                        self.contactHunterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                        [self.contactHunterBtn addTarget:self action:@selector(contactHunter:) forControlEvents:UIControlEventTouchUpInside];
                        self.withdrawPayBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3 * 2 + 2, 0, (mainScreenWidth - 2) / 3, 44)];
                        [self.payView addSubview:self.withdrawPayBtn];
                        [self.withdrawPayBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                        self.withdrawPayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                        [self.withdrawPayBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
                        [self.withdrawPayBtn addTarget:self action:@selector(withdrawPay:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [tasktailView addSubview:self.payView];
                    }else if ([status isEqualToString:@"3"]){
                        self.contactHunterEvaBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 1) / 2 + 0.5, 0, (mainScreenWidth - 1) / 2, 44)];
                        self.contactHunterEvaBtn.backgroundColor = [UIColor clearColor];
                        [self.contactHunterEvaBtn setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
                        [self.contactHunterEvaBtn setTitle:@"联系Ta" forState:UIControlStateNormal];
                        [self.contactHunterEvaBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
                        self.contactHunterEvaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                        [self.commentedView addSubview:self.contactHunterEvaBtn];
                        [self.contactHunterEvaBtn addTarget:self action:@selector(contactAfterFinish:) forControlEvents:UIControlEventTouchUpInside];
                        UIView * centerView = [[UIView alloc] initWithFrame:CGRectMake(mainScreenWidth / 2 - 0.5, 0, 1, 44)];
                        centerView.backgroundColor = RGBCOLOR(235, 235, 235);
                        [self.commentedView addSubview:centerView];
                        
                        self.showCommentView = [[UIView alloc] initWithFrame:CGRectMake(20, 6, centerView.frame.origin.x - 40, 36)];
                        self.showCommentView.backgroundColor = RGBCOLOR(234, 85, 20);
                        [self.commentedView addSubview:self.showCommentView];
                        
                        self.evaImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 17, 17)];
                        [self.showCommentView addSubview:self.evaImage];
                        self.evaImage.image = [UIImage imageNamed:@"task_pay"];
                        self.evaLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.evaImage.frame.origin.x + self.evaImage.frame.size.width + 5, 7, 60, 20)];
                        self.evaLabel.textColor = [UIColor whiteColor];
                        self.evaLabel.font = [UIFont systemFontOfSize:14];
                        self.evaLabel.text = @"查看评价";
                        [self.showCommentView addSubview:self.evaLabel];
                        
                        self.evaBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (mainScreenWidth - 1) / 2, 44)];
                        [self.evaBtn addTarget:self action:@selector(showComment:) forControlEvents:UIControlEventTouchUpInside];
                        [self.showCommentView addSubview:self.evaBtn];

                        
                        [tasktailView addSubview:self.commentedView];
                    }else if ([status isEqualToString:@"4"]){
                        [tasktailView addSubview:self.overTimeView];
                    }else if ([status isEqualToString:@"5"]){
                        [tasktailView addSubview:self.failView];
                        UILabel *text = (UILabel *)[self.failView viewWithTag:1];
                        [text setText:@"任务已被屏蔽"];
                    }else if ([status isEqualToString:@"6"]){
                        [tasktailView addSubview:self.failView];
                        UILabel *text = (UILabel *)[self.failView viewWithTag:1];
                        [text setText:@"任务已退款"];
                    }else if ([status isEqualToString:@"7"]){
                        NSDictionary *withdraw = [task objectForKey:@"withdraw"];
                        NSString *result = [withdraw objectForKey:@"dealresult"];
                        if([result isEqualToString:@"0"]){
                            [tasktailView addSubview:self.withdrawForGold];
                            UILabel *text = (UILabel *)[self.withdrawForGold viewWithTag:1];
                            [text setText:@"猎人未处理"];
                        }else if ([result isEqualToString:@"1"]){
                            [tasktailView addSubview:self.failView];
                            UILabel *text = (UILabel *)[self.failView viewWithTag:1];
                            [text setText:@"任务已退款"];
                        }else if ([result isEqualToString:@"2"]){
                            [tasktailView addSubview:self.withdrawForGold];
                            UILabel *text = (UILabel *)[self.withdrawForGold viewWithTag:1];
                            [text setText:@"猎人不同意退款"];
                        }
                    }
                    else if([status isEqualToString:@"8"]){
                        // 等待猎人应邀的私密任务
                        [tasktailView addSubview:self.orienttaskOwnerDeal];
                    }else if([status isEqualToString:@"9"]){
                        // 私密任务，猎人已拒绝，主人可以修改任务和退款，猎人只能看到已拒绝
                        [tasktailView addSubview:self.orienttaskOwnerDeal];
                        UILabel *text = (UILabel *)[self.failView viewWithTag:1];
                        [text setText:@"对方拒绝"];
                    }
                }
            }
            requested = YES;
            [taskTable reloadData];
            //刷新或获取任务评论
            if (isWithComments) {
                [self didGetComments4TaskIsloading:NO page:1];
            }
            // 任务秀
            if (isWithComments) {
                [self didGetTaskShow4TaskIsloading:NO WithTaskTid:self.tid andWithPages:1];
            }

        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
            taskTable.pullTableIsRefreshing = NO;
        }
    } fail:^{
        taskTable.pullTableIsRefreshing = NO;
        if (isloading) {
            [self endLoad];
        }
    }];
}

#pragma mark --- 获得评论详情 ---
-(void)didGetComments4TaskIsloading:(BOOL)isloading page:(NSInteger)p{
    if (isloading) {
        [self startLoad];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?oid=%@&type=2&page=%zd",URL_GET_TASK_COMMENT,self.tid, p];
    [AFNetworkTool httpRequestWithUrl:url params:nil success:^(NSData *data) {
       
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [imgarray addObject:[result objectForKey:@"comments"]];
        
        if ([[result objectForKey:@"error"]integerValue] == 0) {
             [self endLoad];
            if (p == 1) {
                // 停止刷新
                taskTable.pullTableIsRefreshing = NO;
                
                [taskcommentArray removeAllObjects];
                page = 2;
                NSArray *array = [result valueForKey:@"comments"];
                [taskcommentArray addObjectsFromArray:array];
                [taskTable reloadData];
            }else{
                page++;
                NSArray *array = [result valueForKey:@"comments"];
                [taskcommentArray addObjectsFromArray:array];
                [taskTable reloadData];
                
                taskTable.pullTableIsLoadingMore = NO;
            }
        }else{
            if (isloading) {
                [self endLoad];
            }
            taskTable.pullTableIsLoadingMore = NO;
            [ProgressHUD show:[result objectForKey:@"msg"]];
        }
     } fail:^{
         taskTable.pullTableIsLoadingMore = NO;
         if (isloading) {
             [self endLoad];
         }
     }];
}


#pragma mark --- 获得任务秀详情
- (void)didGetTaskShow4TaskIsloading:(BOOL) isloading WithTaskTid:(NSString *)tid andWithPages:(NSInteger )p {
    
    if (isloading) {
        [self startLoad];
    }
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:tid forKey:@"tid"];
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)p] forKey:@"page"];
    
    [AFNetworkTool httpRequestWithUrl:URL_TASK_SHOW_LIST params:dict success:^(NSData *data) {
        
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            [self endLoad];
            if (p == 1) {
                // 停止刷新
                taskTable.pullTableIsRefreshing = NO;
                
                [taskShowArray removeAllObjects];
                taskPage = 2;
                NSArray *array = [result valueForKey:@"taskshows"];
                self.taskShowDict = [[NSMutableDictionary alloc] initWithDictionary:result];
                
                [taskShowArray addObjectsFromArray:array];
                [taskTable reloadData];
            }else{
                taskPage++;
                NSArray *array = [result valueForKey:@"taskshows"];
                [taskShowArray addObjectsFromArray:array];
                [taskTable reloadData];
                
                taskTable.pullTableIsLoadingMore = NO;
            }
        }else{
            if (isloading) {
                [self endLoad];
            }
            taskTable.pullTableIsLoadingMore = NO;
            [ProgressHUD show:[result objectForKey:@"msg"]];
        }
    } fail:^{
        taskTable.pullTableIsLoadingMore = NO;
        if (isloading) {
            [self endLoad];
        }
    }];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    
    if ([[Monitor sharedInstance].Identify isEqualToString:@"PL"] || [Monitor sharedInstance].Identify == nil) {
        NSDictionary *comment = [taskcommentArray objectAtIndex:indexPath.row - 1];
        if([[comment objectForKey:UID] isEqualToString:[ghunterRequester getUserInfo:UID]]){
            [self comment:nil];
            self.reply_cid = @"";
            self.reply_uid = @"";
            textViewTip.text = @"";
            textViewTip.hidden = YES;
        }else{
            [self comment:nil];
            if ([[comment objectForKey:UID] isEqualToString:[[task objectForKey:@"owner"] objectForKey:UID]]) {
                self.reply_uid = @"";
                self.reply_cid  = [comment objectForKey:@"cid"];
                
                replyStr = [NSString stringWithFormat:@"回复@%@：", [comment objectForKey:@"username"]];
                textViewTip.text = [NSString stringWithFormat:@"回复@%@：", [comment objectForKey:@"username"]];
                tmpString = textViewTip.text;
                textViewTip.hidden = NO;
            }else{
                self.reply_uid = [comment objectForKey:UID];
                self.reply_cid  = [comment objectForKey:@"cid"];
                
                replyStr = [NSString stringWithFormat:@"回复@%@：", [comment objectForKey:@"username"]];
                textViewTip.text = [NSString stringWithFormat:@"回复@%@：", [comment objectForKey:@"username"]];
                tmpString = textViewTip.text;
                textViewTip.hidden = NO;
            }
        }
    }else{
        
        NSLog(@"点击了任务秀");
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (indexPath.row==0) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else{
        NSArray *qwe = [[taskcommentArray objectAtIndex:indexPath.row-1] objectForKey:@"pics"];
        if (qwe.count ==0) {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }else{
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }
    }
     */
    if (indexPath.row==0) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else{
        if ([[Monitor sharedInstance].Identify isEqualToString:@"PL"]) {
            NSDictionary* comment;
            comment = [taskcommentArray objectAtIndex:indexPath.row - 1];

            NSArray *picsarray = [comment objectForKey:@"pics"];
            if (picsarray.count ==0) {
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.frame.size.height;
            }else{
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.frame.size.height;
            }
        }else{
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }
    }
}
#pragma mark - UITableviewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!requested){
        return 0;
    }
//    return [taskcommentArray count] + 1;
    if ([[Monitor sharedInstance].Identify isEqualToString:@"PL"]) {
        return [taskcommentArray count] + 1;
    }else {
        return taskShowArray.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info;
    NSDictionary *owner;
    NSDictionary *stat;
    NSArray *joiners;
    NSDictionary* skillInfo;
    NSDictionary * shareDic;
    
    info = [task objectForKey:@"info"];
    owner = [task objectForKey:@"owner"];
    stat = [task objectForKey:@"stat"];
    joiners = [task objectForKey:@"joiners"];
    skillInfo=[task objectForKey:@"skillshow"];
    shareDic = [task objectForKey:@"share"];
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"taskContent" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

       
        UIView * taskBG = [[UIView alloc] initWithFrame:CGRectMake(0, 90, mainScreenWidth, 300)];
        [cell.contentView addSubview:taskBG];
        taskBG.backgroundColor = [UIColor whiteColor];
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, mainScreenWidth, 70)];
        view.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:view];
        
        CGRect viewFrame = view.frame;
        viewFrame.size.width = mainScreenWidth;
        view.frame = viewFrame;
        
        
        //分割线
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, mainScreenWidth, 0.5)];
        line.backgroundColor = RGBCOLOR(235, 235, 235);
        [taskBG addSubview:line];

//        UILabel *university = (UILabel *)[cell viewWithTag:22];
        CGRect taskBGFrame = taskBG.frame;
        
        // 头像
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [view addSubview:icon];
        icon.layer.masksToBounds =YES;
        icon.layer.cornerRadius = 25;
        [icon sd_setImageWithURL:[owner objectForKey:TINY_AVATAR] placeholderImage:[UIImage imageNamed:@"avatar"]];
        
        [icon setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped)];
        [icon addGestureRecognizer:tap];
        icon.userInteractionEnabled = YES;
        
        // 名字
        UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [cell.contentView addSubview:name];
        [name setText:[owner objectForKey:@"username"]];
        name.font = [UIFont systemFontOfSize:14];
        CGSize nameSize = [[owner objectForKey:@"username"] sizeWithFont:name.font];
        UIImageView * gender = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        [cell.contentView addSubview:gender];
        CGRect genderFrame = gender.frame;
        if([[owner objectForKey:@"sex"] isEqualToString:@"0"]){
            [gender setImage:[UIImage imageNamed:@"female"]];
        }else{
            [gender setImage:[UIImage imageNamed:@"male"]];
        }
        
        CGRect nameFrame = name.frame;
//        if (nameSize.width > 76) {
        nameFrame.origin.x = icon.frame.origin.x + icon.frame.size.width + 10;
        nameFrame.origin.y = icon.frame.origin.y + 15;
        nameFrame.size.width = nameSize.width;
        nameFrame.size.height = 18;
//        }
        name.frame = nameFrame;
        
        genderFrame.origin.x = name.frame.origin.x + name.frame.size.width + 5;
        genderFrame.origin.y = name.frame.origin.y + 5;
        gender.frame = genderFrame;
        
        // 距离
        UILabel * distance = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth - 100, 10, 100, 17)];
        [view addSubview:distance];
        distance.font = [UIFont systemFontOfSize:12];
        distance.textColor = [UIColor grayColor];

        if ([[owner objectForKey:@"uid"] isEqualToString:[ghunterRequester getUserInfo:UID]]) {
            [distance setText:@"0m"];
        }
        
        NSString *distanceStr = [ghunterRequester calculateDistanceWithLatitude:[info objectForKey:@"latitude"] withLongitude:[info objectForKey:@"longitude"]];
        CGSize disSize = [distanceStr sizeWithFont:distance.font];
        CGRect disFrame = distance.frame;
        disFrame.size.width = disSize.width;
        disFrame.origin.x = mainScreenWidth - disSize.width - 10;
        distance.frame = disFrame;
        distance.text = distanceStr;
        
//        NSString *universityStr = [owner objectForKey:@"university_name"];
//        CGSize universitySize = [universityStr sizeWithFont:university.font];
//        CGRect universityFrame = university.frame;
//        universityFrame.origin.x = distance.frame.origin.x + distance.frame.size.width + 3;
//        universityFrame.size.width = universitySize.width;
//        university.frame = universityFrame;
//        [university setText:universityStr];

        // 职业
        UILabel * jobLb = [[UILabel alloc] initWithFrame:CGRectMake(gender.frame.origin.x + gender.frame.size.width + 5, gender.frame.origin.y - 2, 100, 20)];
        jobLb.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:jobLb];
        jobLb.text = [owner objectForKey:@"job"];
        jobLb.textColor = RGBCOLOR(102, 102, 102);
        jobLb.textAlignment = NSTextAlignmentLeft;
        
        NSDictionary * dict = [owner objectForKey:@"wicon"];
        NSString * IndustryStr = [dict objectForKey:@"word"];
        // 职业图标
        UIImageView * industryImg = [[UIImageView alloc] initWithFrame:CGRectMake(gender.frame.origin.x + gender.frame.size.width + 5, gender.frame.origin.y - 2, 12, 12)];
        if (![IndustryStr isEqualToString:@""]) {
            
            industryImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [AFNetworkTool getIndustryIcon:IndustryStr]]];
            
            [cell addSubview:industryImg];
            CGRect jobFrame = jobLb.frame;
            
            jobFrame.origin.x = industryImg.frame.origin.x + industryImg.frame.size.width + 5;
            jobFrame.origin.y = name.frame.origin.y + 1;
            jobLb.frame = jobFrame;
        }else {
            CGRect jobFrame = jobLb.frame;
            
            jobFrame.origin.x = gender.frame.size.width + gender.frame.origin.x + 5;
            jobFrame.origin.y = name.frame.origin.y + 1;
            jobLb.frame = jobFrame;
        }
        
        UIView * secLayout = [[UIView alloc] initWithFrame:CGRectMake(name.frame.origin.x, name.frame.size.height + name.frame.origin.y + 5, mainScreenWidth - 80, 29)];
        [cell.contentView addSubview:secLayout];
        UIImageView *levelImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        NSInteger i = [NSString stringWithFormat:@"%@",[owner objectForKey:@"level"]].intValue;
        levelImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级%ld", (long)i]];
        [secLayout addSubview:levelImgV];
        
        UIImageView *imgV;
        TQStarRatingView *star;
        if([[owner objectForKey:@"is_identity"] isEqualToString:@"1"]){
            imgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 14, 14)];
            imgV.image = [UIImage imageNamed:@"实名认证"];
            [secLayout addSubview:imgV];
            
            // 星级
            star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(40, 2, 50, 10) numberOfStar:5];
            [star setScore:[[owner objectForKey:@"kopubility"] floatValue]];
            [star setuserInteractionEnabled:NO];
            [secLayout addSubview:star];
        }else{
            // 星级
            star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(20, 2, 50, 10) numberOfStar:5];
            [star setScore:[[owner objectForKey:@"kopubility"] floatValue]];
            [star setuserInteractionEnabled:NO];
            [secLayout addSubview:star];
        }
        
        NSArray *identities = [owner objectForKey:@"identities"];
        if ([identities count] > 0) {
            int offset = 0;
            for (NSDictionary *ide in identities) {
                UILabel *ideLabel = [[UILabel alloc] init];
                // 处理16进制的颜色
                ideLabel.backgroundColor = [Monitor colorWithHexString:[ide objectForKey:@"color"] alpha:1.0];
                ideLabel.text = [ide objectForKey:@"title"];
                ideLabel.textColor = [UIColor whiteColor];
                ideLabel.font = [UIFont systemFontOfSize:10];
                ideLabel.textAlignment = NSTextAlignmentCenter;
                // add Label
                CGSize ideSize = [ideLabel.text sizeWithFont:[UIFont systemFontOfSize:10.0]];
                CGRect ideFrame = ideLabel.frame;
                ideFrame.size.width = ideSize.width + 6;
                ideFrame.size.height = 14;
                ideFrame.origin.y = 0;
                if ( imgV != nil ) {
                    if (offset == 0) {
                        ideFrame.origin.x = 40;
                    }else{
                        ideFrame.origin.x = 40 + offset;
                    }
                }else{
                    if (offset == 0) {
                        ideFrame.origin.x = 20;
                    }else{
                        ideFrame.origin.x = 20 + offset;
                    }
                }
                ideLabel.frame = ideFrame;
                [secLayout addSubview:ideLabel];
                
                offset = offset + ideFrame.size.width + 6;
            }
            CGRect starFrame = star.frame;
            starFrame.origin.x = starFrame.origin.x + offset;
            star.frame = starFrame;
        }
        
        UIImageView * catalog = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [taskBG addSubview:catalog];
        [catalog setImage:[UIImage imageNamed:[ghunterRequester getTaskCatalogImg:[info objectForKey:@"fcid"]]]];
        
        NSString *bountyStr;
        NSString *bountySelf;
        
        UILabel * goldLabel = [[UILabel alloc] initWithFrame:CGRectMake(catalog.frame.origin.x + catalog.frame.size.width + 10, 10, 30, 30)];
        [taskBG addSubview:goldLabel];
        goldLabel.textColor = RGBCOLOR(234, 85, 20);
        goldLabel.text=@"赏";
        goldLabel.layer.cornerRadius = goldLabel.frame.size.width / 2;
        goldLabel.clipsToBounds = YES;
        [goldLabel.layer setBorderWidth:1.0f];
        [goldLabel.layer setBorderColor:RGBCOLOR(234, 85, 20).CGColor];
        goldLabel.textAlignment = NSTextAlignmentCenter;
        
        OHAttributedLabel * bounty = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(goldLabel.frame.size.width + goldLabel.frame.origin.x + 5, 13, 100, 30)];
        [taskBG addSubview:bounty];
        bounty.textColor = RGBCOLOR(234, 85, 20);

        bountySelf = [info objectForKey:@"bounty"];
        bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
//        [attrStr setTextColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0]];
//        [bounty setAttributedText:attrStr];
        bounty.text = bountyStr;
        [bounty setFont:[UIFont systemFontOfSize:16]];
        
        CGRect bountyFrame = bounty.frame;
        bountyFrame.origin.x = goldLabel.frame.origin.x + 30 + 5;
        bountyFrame.origin.y = goldLabel.frame.origin.y + 5;
        bounty.frame = bountyFrame;
        
        NSString *titleStr;
        OHAttributedLabel * taskTitle = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(10, 55, mainScreenWidth - 20, 28)];
//        taskTitle.backgroundColor = [UIColor redColor];
        // 标题
        titleStr= [NSString stringWithFormat:@"任务标题: %@", [info objectForKey:@"title"]];
        NSMutableAttributedString * taskTitleStr = [NSMutableAttributedString attributedStringWithString:titleStr];
        [taskTitleStr setFont:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 5)];
        [taskTitleStr setFont:[UIFont systemFontOfSize:15.0] range:NSMakeRange(5, [[info objectForKey:@"title"] length] + 1)];
        CGSize titleSize = [titleStr sizeWithFont:taskTitle.font constrainedToSize:CGSizeMake(taskTitle.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
     
        // 颜色
        [taskTitleStr setTextColor:[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0] range:NSMakeRange(0,5)];
        [taskTitleStr setTextColor:[UIColor colorWithRed:17.0 / 255.0 green:17.0 / 255.0 blue:17.0 / 255.0 alpha:1.0] range:NSMakeRange(5, [[info objectForKey:@"task"] length])];
        
        [taskTitle setAttributedText:taskTitleStr];
        [taskBG addSubview:taskTitle];
        
        CGRect titleFrameOrigin = taskTitle.frame;
        CGFloat diffTitle = titleSize.height - titleFrameOrigin.size.height;
        titleFrameOrigin.origin.y = 55;
        titleFrameOrigin.size.height = titleSize.height;
        [taskTitle setFrame:titleFrameOrigin];
        
        // 内容
        OHAttributedLabel * description = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(10, 75, mainScreenWidth - 20, 300)];
//        description.backgroundColor = [UIColor redColor];
        description.numberOfLines = 0;
        [taskBG addSubview:description];
        
        description.textColor = RGBCOLOR(102, 102, 102);
        description.delegate = self;

        NSString *descriptionSelf = [info objectForKey:@"description"];
        NSString *descriptionStr;
    
        descriptionStr = [NSString stringWithFormat:@"任务详情: %@",descriptionSelf];
        NSMutableAttributedString *descriptionattrStr                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              = [NSMutableAttributedString attributedStringWithString:descriptionStr];
        [descriptionattrStr setFont:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 5)];
        [descriptionattrStr setFont:[UIFont systemFontOfSize:13.0] range:NSMakeRange(5, [descriptionSelf length])];
        [descriptionattrStr setTextColor:[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0] range:NSMakeRange(0,5)];
        [descriptionattrStr setTextColor:[UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0] range:NSMakeRange(5, [descriptionSelf length])];
        
        CGSize descriptionSize = [descriptionStr sizeWithFont:description.font constrainedToSize:CGSizeMake(mainScreenWidth, 1000)];
    
        CGSize labelSize = [descriptionStr boundingRectWithSize:CGSizeMake(mainScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
        
        CGRect descriptionFrameOrigin = description.frame;
//        CGFloat diffDescription = labelSize.height - labelSize.height+25;
        
        descriptionFrameOrigin.size.height = labelSize.height + 40;
        if (titleSize.height > 38) {
            
            descriptionFrameOrigin.origin.y = taskTitle.frame.origin.y + titleSize.height / 2 + 3;
        }else {
            
            descriptionFrameOrigin.origin.y = taskTitle.frame.origin.y + titleSize.height + 3;
        }
        
        [description setFrame:descriptionFrameOrigin];
        [description setAttributedText:descriptionattrStr];

        if(skillInfo.count!=0)
        {
            taskBGFrame.size.height = description.frame.origin.y + description.frame.size.height;
        }
        else
        {
            taskBGFrame.size.height += (diffTitle + description.frame.size.height + 10);
        }

        
        if(skillInfo.count!=0)
        {
            [description setFrame:descriptionFrameOrigin];
            UIView* skillView=[[UIView alloc] initWithFrame:CGRectMake(description.frame.origin.x, description.frame.origin.y+description.frame.size.height+20, mainScreenWidth - description.frame.origin.x - 10, 60)];
            skillView.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
            skillView.layer.cornerRadius=8.0;
            [taskBG addSubview:skillView];
            UILabel* skillLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, -16, 150, 10)];
            skillLabel.text=@"所购技能：";
            skillLabel.font=[UIFont systemFontOfSize:12];
            skillLabel.textColor=[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1];
            [skillView addSubview:skillLabel];
            
            UIImageView* skillOwn=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
            // 圆角头像
            skillOwn.clipsToBounds = YES;
            skillOwn.layer.cornerRadius = Radius;
            
            [skillOwn sd_setImageWithURL:[skillInfo objectForKey:@"owner_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
            [skillView addSubview:skillOwn];
            [skillOwn setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skillTaped)];
            [skillOwn addGestureRecognizer:tap];
            
            UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(70, 15, 150, 10)];
            nameLabel.text=[skillInfo objectForKey:@"owner_username"];
            nameLabel.font=[UIFont systemFontOfSize:11];
            nameLabel.textColor=[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1];
            [skillView addSubview:nameLabel];
            UILabel* skillName=[[UILabel alloc] initWithFrame:CGRectMake(70, 30, 150, 15)];
            skillName.text=[skillInfo objectForKey:@"skill"];
            skillName.font=[UIFont systemFontOfSize:13];
            skillName.textColor=[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
            [skillView addSubview:skillName];
            UILabel* priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(skillView.frame.size.width - 120, 23, 100, 14)];
            priceLabel.textAlignment=NSTextAlignmentRight;
            NSString* str=[NSString stringWithFormat:@"%@元/%@",[skillInfo objectForKey:@"price"],[skillInfo objectForKey:@"priceunit"]];
            priceLabel.text=str;
            priceLabel.font=[UIFont systemFontOfSize:14];
            priceLabel.textColor=[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1];
            [skillView addSubview:priceLabel];
           
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.text=@"";
            btn.backgroundColor=[UIColor clearColor];
            [btn addTarget:self action:@selector(skillBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame=CGRectMake(60, 0, 220, 60);
            [skillView addSubview:btn];
        }
      
        
                /*
        CGFloat top = 20; // 顶端盖高度
        CGFloat bottom = task_round.frame.size.height - top - 1; // 底端盖高度
        CGFloat left = 20; // 左端盖宽度
        CGFloat right = task_round.frame.size.width - left - 1; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
         */
        
        NSArray *picArray;
        picArray= [task objectForKey:@"images"];

        CGFloat picWidth = 60.0;
        NSInteger desHeight = (NSInteger)descriptionSize.height;
        NSInteger row_space = desHeight/20;
        if (row_space > 3) {
            row_space = 3;
        }
        
        CGFloat taskSpace = row_space * 3;
        if([picArray count] > 0) {
            UILabel *pic_label;
            if(skillInfo.count!=0)
            {
                pic_label= [[UILabel alloc] initWithFrame:CGRectMake(10, description.frame.origin.y +description.frame.size.height + 20 + 80, mainScreenWidth - 40, 12)];
                taskBGFrame.size.height = description.frame.origin.y + descriptionSize.height + 85 + 10 + pic_label.frame.size.height + picWidth + 60;

                [taskBG setFrame:taskBGFrame];
            }
            else
            {
                pic_label= [[UILabel alloc] initWithFrame:CGRectMake(10, description.frame.origin.y + description.frame.size.height + 5 - taskSpace + 6, mainScreenWidth - 40, 12)];
                
                taskBGFrame.size.height = description.frame.origin.x + description.frame.size.height + pic_label.frame.size.height + 5 +picWidth + 10 + picWidth + 20 + 20;
                [taskBG setFrame:taskBGFrame];
            }
            
            [pic_label setText:@"任务图片："];
            [pic_label setTextColor:RGBA(137.0, 137.0, 137.0, 1.0)];
            [pic_label setFont:[UIFont systemFontOfSize:12.0]];
            [taskBG addSubview:pic_label];
            
            NSMutableArray * newPicArray=[[NSMutableArray alloc] init];
            for(NSInteger j = 0;j <[picArray count];j++)
            {
                newPicArray[j] = picArray[[picArray count]-j-1];
            }
            
            
            for(NSInteger i = 0;i < [newPicArray count];i++) {
                
                NSDictionary *picDic = [newPicArray objectAtIndex:[newPicArray count] - 1 -i];
                UIImageView * picView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (10 + 70) * i, pic_label.frame.origin.y + pic_label.frame.size.height + 5 , picWidth, picWidth)];
                picView.tag = (100 + i);
                picView.contentMode = UIViewContentModeScaleAspectFill;
                picView.userInteractionEnabled = YES;
                picView.clipsToBounds = YES;
//                picView.layer.cornerRadius = 3.0;
                [picView sd_setImageWithURL:[picDic objectForKey:@"largeurl"] placeholderImage:[UIImage imageNamed:@"avatar"]];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pic_taped:)];
                [picView addGestureRecognizer:tap];
                // 长按图片
                UILongPressGestureRecognizer *long_press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
                [picView addGestureRecognizer:long_press];
                
                [taskBG addSubview:picView];
            }
        }
        else if([picArray count] == 0){
            if(skillInfo.count!=0)
            {
                taskBGFrame.size.height = description.frame.origin.y + labelSize.height + picWidth + 30 + 60;
                [taskBG setFrame:taskBGFrame];
            }
            else
            {
                taskBGFrame.size.height = description.frame.size.height + description.frame.origin.y + 30;
                [taskBG setFrame:taskBGFrame];
            }
        }
        
        // 添加分享view
        UIView * sharePlantView = [[UIView alloc] initWithFrame:CGRectMake(0, taskBG.frame.size.height + taskBG.frame.origin.y + 10, mainScreenWidth, 53)];
        sharePlantView.backgroundColor = [UIColor whiteColor];
        sharePlantView.frame = CGRectMake(0, taskBG.frame.size.height + taskBG.frame.origin.y + 10, mainScreenWidth, 53);
        UILabel * shareGoldTotalLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 136, 20)];
        shareGoldTotalLb.font = [UIFont systemFontOfSize:12];
        shareGoldTotalLb.textAlignment = NSTextAlignmentLeft;
        shareGoldTotalLb.text = [NSString stringWithFormat:@"分享金币：%@", [shareDic objectForKey:@"reward"]];
        CGSize goldSize = [shareGoldTotalLb.text sizeWithFont:shareGoldTotalLb.font];
        
        UILabel * balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(goldSize.width + shareGoldTotalLb.frame.origin.x + 10, 10, 110, 20)];
        balanceLabel.textAlignment = NSTextAlignmentLeft;
        balanceLabel.font = [UIFont systemFontOfSize:12];
        balanceLabel.text = [NSString stringWithFormat:@"剩余：%@", [shareDic objectForKey:@"balance"]];
        UILabel * shareCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(shareGoldTotalLb.frame.origin.x + goldSize.width + 10, 17, 74, 21)];
        shareCountLabel.text = [NSString stringWithFormat:@"%@人已分享", [shareDic objectForKey:@"share_count"]];
        shareCountLabel.textColor = [UIColor lightGrayColor];
        shareCountLabel.textAlignment = NSTextAlignmentCenter;
        shareCountLabel.font = [UIFont systemFontOfSize:10];
        CGSize size = [shareCountLabel.text sizeWithFont:shareCountLabel.font];
        shareCountLabel.frame = CGRectMake(mainScreenWidth - size.width - 28, 17, 74, 21);
        
        UIImageView * goImg = [[UIImageView alloc] initWithFrame:CGRectMake(shareCountLabel.frame.size.width + shareCountLabel.frame.origin.x - 10, 22, 6, 10)];
        goImg.image = [UIImage imageNamed:@"goto"];
        
        NSArray *array = @[@"分享金币空间", @"分享金币qq好友", @"分享金币朋友圈", @"分享金币微信好友", @"分享金币微博"];
        NSArray * plantArray = @[@"rw_qzone", @"rw_qq", @"rw_wxmoments", @"rw_wechat", @"rw_weibo"];
        //平台
        for (int i = 1; i < array.count + 1; i++) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10 + (i - 1) * 32 + (i - 1) * 5, 31, 37, 16)];
            view.backgroundColor = [UIColor whiteColor];
            
            UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 14, 14)];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(17, 3, 22, 16)];
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:10];
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", array[i - 1]]];
            label.text = [NSString stringWithFormat:@"x%@", [shareDic objectForKey:[NSString stringWithFormat:@"%@", plantArray[i - 1]]]];
            
            [view addSubview:img];
            [view addSubview:label];
            [sharePlantView addSubview:view];
        }

        [cell addSubview:sharePlantView];
        [sharePlantView addSubview:balanceLabel];
        [sharePlantView addSubview:shareGoldTotalLb];
        [sharePlantView addSubview:shareCountLabel];
        [sharePlantView addSubview:goImg];
        
        UIButton * shareCountBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 53)];
        shareCountBtn.backgroundColor = [UIColor clearColor];
        [sharePlantView addSubview:shareCountBtn];
        // 添加跳转统计页面的事件
        [shareCountBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * stateBG = [[UIView alloc] initWithFrame:CGRectMake(0, taskBG.frame.size.height + taskBG.frame.origin.y + 5, mainScreenWidth, 20)];
        [cell.contentView addSubview:stateBG];
        stateBG.backgroundColor = [UIColor clearColor];
        
        UILabel * biddingBum = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, mainScreenWidth, 20)];
        [stateBG addSubview:biddingBum];
        biddingBum.font = [UIFont systemFontOfSize:12];
        biddingBum.textColor = RGBCOLOR(153, 153, 153);
        if ([[owner objectForKey:@"uid"] isEqualToString:[ghunterRequester getUserInfo:@"uid"]] && [[stat objectForKey:@"biddingCount"] integerValue] > 0){
            [biddingBum setText:[NSString stringWithFormat:@"%@人竞标（长按头像可以进行打赏）",[stat objectForKey:@"biddingCount"]]];
        }
        [biddingBum setText:[NSString stringWithFormat:@"%@人竞标",[stat objectForKey:@"biddingCount"]]];
        
        CGRect stateBGSize = stateBG.frame;
        if (shareDic.count == 0) {
            [sharePlantView removeFromSuperview];
            stateBGSize.origin.y = taskBG.frame.origin.y + taskBG.frame.size.height+ 5;
            stateBGSize.size.height = 20;
            [stateBG setFrame:stateBGSize];
        }else {
            stateBGSize.origin.y = taskBG.frame.origin.y + taskBG.frame.size.height+ 5 + sharePlantView.frame.size.height + 10;
            stateBGSize.size.height = 20;
            [stateBG setFrame:stateBGSize];
        }
        
        UIButton * report = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenWidth - 60, taskBG.frame.size.height - 50, 60, 60)];
        [report setTitle:@"举报" forState:UIControlStateNormal];
        [report setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
        report.titleLabel.font = [UIFont systemFontOfSize:12];
        [taskBG addSubview:report];
        if([[owner objectForKey:@"uid"] isEqualToString:[ghunterRequester getUserInfo:UID]]){
            report.hidden = YES;
        }else{
            report.hidden = NO;
        }
        [report addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
        
      
        NSInteger avatarPerRow = 6;
        CGFloat avatarSize = 48.0;
        CGFloat backWidth = mainScreenWidth - 20;
        CGFloat space = (backWidth - 20 - avatarSize * (avatarPerRow)) / (avatarPerRow - 1) + 3;
        NSInteger joinerNum,rowNUm;
        joinerNum = [joiners count];
        if(joinerNum % avatarPerRow == 0) rowNUm = joinerNum/avatarPerRow;
        else rowNUm = joinerNum/avatarPerRow + 1;
        // for头像
        UIView * back = [[UIView alloc] initWithFrame:CGRectMake(0, stateBG.frame.origin.y + stateBG.frame.size.height + 2, mainScreenWidth, avatarSize * rowNUm + 20 + (rowNUm - 1) * 5)];
        back.backgroundColor = [UIColor redColor];
        NSDictionary * tradeuser;
        if(joinerNum != 0) {
            tradeuser = [task objectForKey:@"tradeuser"];
        }
        CGRect backFrame = back.frame;
        if(rowNUm == 0){
            backFrame.size.height = 0;
            [back setFrame:backFrame];
        }
        back.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:back];
        if ([self.yesorno isEqualToString:@""]||self.yesorno==nil) {
            self.yesorno =@"yes";
        }
        if ([self.yesorno isEqualToString:@"yes"]) {
            zankaibtn.hidden =NO;
            Stopbtn.hidden = YES;
        }else{
            zankaibtn.hidden =YES;
            Stopbtn.hidden = NO;
        }
        NSInteger number;
        number = joinerNum;
        if ([self.yesorno isEqualToString:@"yes"]) {
            if (joinerNum > 17) {
                joinerNum = 17;
                backFrame.size.height = 50 * 3 + 5 * 2 + 20;
                back.frame = backFrame;
            }
            if (joinerNum==0) {
                
            }else{
                if (number > 17) {
                    zankaibtn= [[UIButton alloc]initWithFrame:CGRectMake(mainScreenWidth - 10 - 50,backFrame.size.height-60, 50, 50)];
                    [zankaibtn setImage:[UIImage imageNamed:@"open"] forState:(UIControlStateNormal)];
                    [zankaibtn addTarget:self action:@selector(zankai:) forControlEvents:(UIControlEventTouchUpInside)];
                    zankaibtn.tag = rowNUm;
                    [back addSubview:zankaibtn];
                }else{
                    
                }
            }
        }else{
            if (joinerNum==0) {
                
            }else{
                NSString *strss = [NSString stringWithFormat:@"%ld",(long)joinerNum];
                int num = strss.integerValue % 6;
                NSString * line = [NSString stringWithFormat:@"%d", num];

                float joinerffff = [strss floatValue];
                int y = joinerffff / 6;
//                NSString *strjie = [NSString stringWithFormat:@"%.1f",y];
//                NSString * b = [strjie substringFromIndex:strjie.length-1];
                //            NSLog(@"nihao ========%@",b);
                if ([line isEqualToString:@"0"]) {
                    backFrame.size.height = avatarSize * (rowNUm + 1) + 20 + rowNUm * 5;
                    back.frame = backFrame;
                    Stopbtn= [[UIButton alloc]initWithFrame:CGRectMake(15, 10 + y * (avatarSize + 5), 50, 50)];
                    Stopbtn.tag = rowNUm;
                    [Stopbtn setImage:[UIImage imageNamed:@"Shoq"] forState:(UIControlStateNormal)];
                    [Stopbtn addTarget:self action:@selector(stopbtn:) forControlEvents:(UIControlEventTouchUpInside)];
                    [back addSubview:Stopbtn];
                }
                if ([line isEqualToString:@"1"]) {
                    Stopbtn= [[UIButton alloc]initWithFrame:CGRectMake(15 + avatarSize + space, 10 + y * avatarSize + y * 5, 50, 50)];
                    Stopbtn.tag = rowNUm;
                    [Stopbtn setImage:[UIImage imageNamed:@"Shoq"] forState:(UIControlStateNormal)];
                    [Stopbtn addTarget:self action:@selector(stopbtn:) forControlEvents:(UIControlEventTouchUpInside)];
                    [back addSubview:Stopbtn];
                }
                if ([line isEqualToString:@"2"]) {
                    Stopbtn= [[UIButton alloc]initWithFrame:CGRectMake(15 + (avatarSize + space) * 2, 10 + y * (avatarSize + 5), 50, 50)];
                    Stopbtn.tag = rowNUm;
                    [Stopbtn setImage:[UIImage imageNamed:@"Shoq"] forState:(UIControlStateNormal)];
                    [Stopbtn addTarget:self action:@selector(stopbtn:) forControlEvents:(UIControlEventTouchUpInside)];
                    [back addSubview:Stopbtn];
                }
                if ([line isEqualToString:@"3"]) {
                    Stopbtn= [[UIButton alloc]initWithFrame:CGRectMake(15 + (avatarSize + space) * 3, 10 + y * (avatarSize + 5), 50, 50)];
                    [Stopbtn setImage:[UIImage imageNamed:@"Shoq"] forState:(UIControlStateNormal)];
                    Stopbtn.tag = rowNUm;
                    [Stopbtn addTarget:self action:@selector(stopbtn:) forControlEvents:(UIControlEventTouchUpInside)];
                    [back addSubview:Stopbtn];
                }
                if ([line isEqualToString:@"4"]) {
                    Stopbtn= [[UIButton alloc]initWithFrame:CGRectMake(15 + (avatarSize + space) * 4, 10 + y * (avatarSize + 5), 50, 50)];
                    Stopbtn.tag = rowNUm;
                    [Stopbtn setImage:[UIImage imageNamed:@"Shoq"] forState:(UIControlStateNormal)];
                    [Stopbtn addTarget:self action:@selector(stopbtn:) forControlEvents:(UIControlEventTouchUpInside)];
                    [back addSubview:Stopbtn];
                }
                if([line isEqualToString:@"5"]){
                    
                    Stopbtn= [[UIButton alloc]initWithFrame:CGRectMake(mainScreenWidth - 10 - avatarSize, 10 + y * (avatarSize + 5), 50, 50)];
                    Stopbtn.tag = rowNUm;
                    [Stopbtn setImage:[UIImage imageNamed:@"Shoq"] forState:(UIControlStateNormal)];
                    [Stopbtn addTarget:self action:@selector(stopbtn:) forControlEvents:(UIControlEventTouchUpInside)];
                    [back addSubview:Stopbtn];
                }
            }
            
        }
        NSInteger colum = 0;
        
        for (NSInteger i = 0 ; i < joinerNum; i++) {
            UIImageView *image = [[UIImageView alloc] init];
            NSInteger row = i/avatarPerRow;
            colum = i%avatarPerRow;
            image.frame = CGRectMake(colum * avatarSize + colum * space + 15, row * avatarSize + 10 + row * 5, avatarSize, avatarSize);
            image.userInteractionEnabled = YES;
            image.layer.masksToBounds = YES;
            image.layer.cornerRadius = image.frame.size.height / 2.0;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
            [image addGestureRecognizer:singleTap];
            UIView *gestureView = [singleTap view];
            gestureView.tag = i;
            NSDictionary *joiner = [joiners objectAtIndex:i];
            [image sd_setImageWithURL:[joiner objectForKey:@"tiny_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
            [back addSubview:image];
            if ([[tradeuser objectForKey:UID] length] > 0) {
                //进行中或已完成
                UIImageView *foreImage = [[UIImageView alloc] initWithFrame:image.frame];
                foreImage.backgroundColor = [UIColor clearColor];
                foreImage.clipsToBounds = YES;
                foreImage.layer.cornerRadius = foreImage.frame.size.height / 2.0;
                
                if([[tradeuser objectForKey:UID] isEqualToString:[joiner objectForKey:UID]]) {
                    [foreImage setImage:[UIImage imageNamed:@"selected_hunter"]];
                    [back addSubview:foreImage];
                } else if([[joiner objectForKey:@"fee"] doubleValue] > 0 || [[joiner objectForKey:@"coinfee"] integerValue] > 0 || [[joiner objectForKey:@"codeid"] integerValue] > 0){
                    [foreImage setImage:[UIImage imageNamed:@"hunter_rewarded"]];
                    [back addSubview:foreImage];
                }
                if ([[owner objectForKey:@"uid"] isEqualToString:[ghunterRequester getUserInfo:@"uid"]]) {
                    UILongPressGestureRecognizer *long_press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tip_hunter:)];
                    [image addGestureRecognizer:long_press];
                }
            }
            else {
                //竞标中
                UIImageView *foreImage = [[UIImageView alloc] initWithFrame:image.frame];
                foreImage.backgroundColor = [UIColor clearColor];
                foreImage.clipsToBounds = YES;
                foreImage.layer.cornerRadius = foreImage.frame.size.height / 2.0;
                if([[joiner objectForKey:@"fee"] doubleValue] > 0 || [[joiner objectForKey:@"coinfee"] integerValue] > 0 || [[joiner objectForKey:@"codeid"] integerValue] > 0){
                    [foreImage setImage:[UIImage imageNamed:@"hunter_rewarded"]];
                    [back addSubview:foreImage];
                }
                if ([[owner objectForKey:@"uid"] isEqualToString:[ghunterRequester getUserInfo:@"uid"]]) {
                    UILongPressGestureRecognizer *long_press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tip_hunter:)];
                    [image addGestureRecognizer:long_press];
                }
            }
        }
        
        UIImageView * icon2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 10, 10)];
        [taskBG addSubview:icon2];
        icon2.image = [UIImage imageNamed:@"task_dateline"];
        
        UILabel * dateline = [[UILabel alloc] initWithFrame:CGRectMake(icon2.frame.size.width + icon2.frame.origin.x + 5, 100, 100, 20)];
        [taskBG addSubview:dateline];
        dateline.textColor = RGBCOLOR(137, 137, 137);
        dateline.font = [UIFont systemFontOfSize:10];
        NSString * datelineDescription = [ghunterRequester getTimeDescripton:[info objectForKey:@"dateline"]];
        [dateline setText:datelineDescription];

        UIImageView * icon3 = [[UIImageView alloc] initWithFrame:CGRectMake(dateline.frame.size.width + dateline.frame.origin.x + 10, 100, 10, 10)];
        [taskBG addSubview:icon3];
        icon3.image = [UIImage imageNamed:@"task_hot"];
        
        UILabel * hotNum = [[UILabel alloc] initWithFrame:CGRectMake(icon3.frame.size.width + icon3.frame.origin.x + 5, 100, 100, 20)];
        hotNum.textColor = RGBCOLOR(137, 137, 137);
        hotNum.font = [UIFont systemFontOfSize:10];
        [hotNum setText:[NSString stringWithFormat:@"%@热度",[stat objectForKey:@"hot"]]];
        [taskBG addSubview:hotNum];
        
        CGRect datelineFrame = dateline.frame;
        CGRect hotNumFrame = hotNum.frame;
        CGRect taskBGframe = taskBG.frame;
        CGRect icon2Frame = icon2.frame;
        CGRect icon3Frame = icon3.frame;
        datelineFrame.origin.y = taskBGFrame.size.height-25;
        datelineFrame.size.width = [dateline.text sizeWithFont:[UIFont systemFontOfSize:12]].width;
        hotNumFrame.size.width = [hotNum.text sizeWithFont:[UIFont systemFontOfSize:10]].width;
        icon3Frame.origin.x = datelineFrame.origin.x + datelineFrame.size.width + 10;
        icon3Frame.origin.y =taskBGFrame.size.height-20;
        icon2Frame.origin.y =taskBGFrame.size.height-20;
        hotNumFrame.origin.y = taskBGframe.size.height-25;
        hotNumFrame.origin.x = icon3Frame.origin.x + icon3Frame.size.width + 5;

        hotNum.frame = hotNumFrame;
        dateline.frame = datelineFrame;
        icon2.frame = icon2Frame;
        icon3.frame = icon3Frame;
        
        trade_dateline.textAlignment= NSTextAlignmentRight;
        
        UILabel * lb = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth-130, 6, 130, 20)];
        lb.text = [ghunterRequester getTaskTimeDescription:[info objectForKey:@"trade_dateline"]];
        
        NSMutableString * string = [[NSMutableString alloc] initWithString:lb.text];
        NSRange range = [lb.text rangeOfString:@":"];
        NSRange newRange = range;
        newRange.location = range.location - 2;
        
        NSString * str = [lb.text substringWithRange:NSMakeRange(newRange.location, 2)];
        NSMutableString * mutString = [[NSMutableString alloc] initWithString:str];
        
        if (mutString.intValue == 0) {
            [string insertString:@"0" atIndex:newRange.location + 1];
        }
        
        NSString * str2 = [lb.text substringWithRange:NSMakeRange(range.location + 1, 2)];
        NSMutableString * mutString2 = [[NSMutableString alloc] initWithString:str2];
        
        NSRange range2 = [string rangeOfString:@":"];
        if (!(mutString2.intValue > 10)) {
            [string insertString:@"0" atIndex:range2.location + 1];
        }
    
        [trade_dateline setText:string];
        trade_dateline = [[UILabel alloc]initWithFrame:CGRectMake(mainScreenWidth-180, 6, 170, 20)];
        trade_dateline.textColor = [UIColor grayColor];
        trade_dateline.font = [UIFont systemFontOfSize:11];
        trade_dateline.textAlignment = NSTextAlignmentRight;
        [taskBG addSubview:trade_dateline];
        
        taksaddres = [[UILabel alloc]initWithFrame:CGRectMake(mainScreenWidth-250, 25, 240, 20)];
        taksaddres.text = [[task objectForKey:@"info"] objectForKey:@"location"];
        taksaddres.textColor = [UIColor grayColor];
        taksaddres.textAlignment = NSTextAlignmentRight;
        taksaddres.font = [UIFont systemFontOfSize:11];
        [taskBG addSubview:taksaddres];
        
        NSString *comentcount = [[task objectForKey:@"stat"] objectForKey:@"commentCount"];
        NSString *comstr = [NSString stringWithFormat:@"评论(%@)",comentcount];
        Coment = [[UIButton alloc]initWithFrame:CGRectMake(0, back.frame.size.height + back.frame.origin.y + 10, mainScreenWidth/2, 44)];
        [Coment addTarget:self action:@selector(coment:) forControlEvents:(UIControlEventTouchUpInside)];
        Coment.titleLabel.font = [UIFont systemFontOfSize:14];
        [Coment setTitle:comstr forState:(UIControlStateNormal)];
        Coment.tag = indexPath.row;
        Coment.backgroundColor = [UIColor whiteColor];
        [cell addSubview:Coment];
        
        redlin1 = [[UILabel alloc]initWithFrame:CGRectMake(0, Coment.frame.origin.y+Coment.frame.size.height-0.2, mainScreenWidth/2-0.5, 1.5)];
        redlin1.backgroundColor = RGBCOLOR(234, 85, 20);
        [cell addSubview:redlin1];
        
        UILabel * liness = [[UILabel alloc]initWithFrame:CGRectMake(mainScreenWidth/2-0.5, Coment.frame.origin.y + 15, 1, 20)];
        liness.backgroundColor =  RGBCOLOR(229, 229, 229);
        [cell addSubview:liness];
        cell.frame = CGRectMake(0, 0, mainScreenWidth, back.frame.size.height + back.frame.origin.y + 44 + 10 + 1);
        
//        UILabel * line4 = [[UILabel alloc] initWithFrame:CGRectMake(0,  Coment.frame.origin.y+Coment.frame.size.height-0.2, mainScreenWidth, 1.5)];
//        [cell.contentView addSubview:line4];
//        line4.backgroundColor = RGBCOLOR(0, 0, 0);
        
        // 任务秀数目
        //        NSString *soldnum = [[self.taskShowDict objectForKey:@"stat"] objectForKey:@"soldnum"];
        NSString * soldnum = [NSString stringWithFormat:@"%lu", (unsigned long)taskShowArray.count];
        NSString *soldstr = [NSString stringWithFormat:@"任务秀(%@)",soldnum];
        Evaluation = [[UIButton alloc]initWithFrame:CGRectMake(mainScreenWidth/2, back.frame.size.height + back.frame.origin.y + 10, mainScreenWidth/2, 44)];
        [Evaluation addTarget:self action:@selector(Evaluation:) forControlEvents:(UIControlEventTouchUpInside)];
        Evaluation.tag = indexPath.row;
        Evaluation.titleLabel.font = [UIFont systemFontOfSize:14];
        Evaluation.backgroundColor = [UIColor whiteColor];
        [Evaluation setTitle:soldstr forState:(UIControlStateNormal)];
        [cell addSubview:Evaluation];
        [Evaluation setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        redlin2 = [[UILabel alloc]initWithFrame:CGRectMake(mainScreenWidth/2, Coment.frame.origin.y+Coment.frame.size.height-0.2, mainScreenWidth/2-0.5, 0.5)];
        redlin2.backgroundColor = RGBCOLOR(234, 85, 20);
        [cell addSubview:redlin2];
        
        if (flagClick == NO) {
            
            redlin1.backgroundColor = RGBCOLOR(234, 85, 20);
            [Coment setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
            [Evaluation setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            redlin2.backgroundColor = RGBCOLOR(229, 229, 229);
            CGRect heightone = redlin1.frame;
            heightone.size.height = 1.5;
            redlin1.frame = heightone;
            CGRect heighttwo = redlin2.frame;
            heighttwo.size.height = 0.5;
            redlin2.frame = heighttwo;
        }else if (flagClick == YES) {
            
            redlin1.backgroundColor = RGBCOLOR(229, 229, 229);
            [Coment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [Evaluation setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
            redlin2.backgroundColor = RGBCOLOR(234, 85, 20);
            CGRect heightone = redlin1.frame;
            heightone.size.height = 0.5;
            redlin1.frame = heightone;
            CGRect heighttwo = redlin2.frame;
            heighttwo.size.height = 1.5;
            redlin2.frame = heighttwo;
            
        }
        return cell;
    }
    else{
        
        //********************** 评论 *****************
        if ([[Monitor sharedInstance].Identify isEqualToString:@"PL"]) {
            
            NSDictionary* comment;
            comment = [taskcommentArray objectAtIndex:indexPath.row - 1];
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"commentCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *lines = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 0.5)];
            lines.backgroundColor = RGBCOLOR(221, 221, 222);
            [cell addSubview:lines];
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1];
            UILabel *username = (UILabel *)[cell viewWithTag:2];
            UILabel *dateline = (UILabel *)[cell viewWithTag:4];
            UILabel *line = (UILabel *)[cell viewWithTag:6];
            dateline.textColor = [UIColor grayColor];
            
            username.font = [UIFont systemFontOfSize:12];
            username.textColor = RGBCOLOR(102, 102, 102);
          
            
            UILabel *commentContent =[[UILabel alloc]initWithFrame:CGRectMake(58, 25, ScreenWidthFull-63, 0)];
            commentContent.font = [UIFont systemFontOfSize:13];
            NSString *contenttext = [comment objectForKey:@"content"];
            CGRect ssss;
            NSDictionary *adssada = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
            if (contenttext.length<1) {
                ssss.size.height=0;
            }else{
                ssss = [contenttext boundingRectWithSize:CGSizeMake(ScreenWidthFull-63, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:adssada context:nil];
            }
            
            [commentContent setFrame:CGRectMake(58, username.frame.origin.y + username.frame.size.height - 2, mainScreenWidth-63, ssss.size.height+15)];
            
            NSMutableAttributedString* str=[NSMutableAttributedString attributedStringWithAttributedString:[ghunterWordChange wordChange:contenttext]];
            [str addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]} range:NSMakeRange(0, str.length)];
            [commentContent setAttributedText:str];
            [commentContent setNumberOfLines:0];
            [cell addSubview:commentContent];
            
            NSString * usernameStr;
            
            [icon sd_setImageWithURL:[comment objectForKey:@"tiny_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
            if(![comment objectForKey:@"tiny_avatar"])
            {
                [icon sd_setImageWithURL:[comment objectForKey:@"thumb_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
            }
            usernameStr = [comment objectForKey:@"username"];
            icon.layer.cornerRadius = icon.frame.size.height / 2;
            icon.clipsToBounds = YES;
            icon.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentHunter:)];
            icon.tag = indexPath.row - 1;
            [icon addGestureRecognizer:tap];
            
            NSString *datelineStr = [comment objectForKey:@"dateline"];
            [username setText:[NSString stringWithFormat:@"%@:",usernameStr]];
            CGRect commentContentFrame = commentContent.frame;
            
            UIImage* image=[UIImage imageNamed:@"emoji_1"];
            CGFloat imageHeight=image.size.height;
            
            if(ssss.size.height<imageHeight)
            {
                
            }
            if(commentContentFrame.size.height>135)
            {
                commentContentFrame.size.height-=9;
            }
            if(commentContentFrame.size.height>65&&commentContentFrame.size.height<135)
            {
                commentContentFrame.size.height-=3;
            }
            
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = commentContent.frame.origin.y + ssss.size.height + 20;
            [cell setFrame:cellFrame];
            
            [dateline setText:[ghunterRequester getTimeDescripton:datelineStr]];
            if(indexPath.row == 1){
                line.hidden = YES;
            }
            
            if([[comment objectForKey:UID] isEqualToString:[ghunterRequester getUserInfo:UID]]){
                UILongPressGestureRecognizer *long_press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(commentHunter:)];
                cell.tag = indexPath.row;
                [cell addGestureRecognizer:long_press];
            }
            [cell bringSubviewToFront:commentContent];
            NSArray *picsarray = [comment objectForKey:@"pics"];
            if (picsarray>0){
                for (int i = 0; i<picsarray.count; i++) {
                    //cell 评论图片
                    UIImageView *pullimage= [[UIImageView alloc]initWithFrame:CGRectMake(i*60+60, commentContentFrame.origin.y+ssss.size.height + 15, 50, 50)];
                    NSURL *imgurl = [NSURL URLWithString:[[picsarray objectAtIndex:picsarray.count - 1 - i]objectForKey:@"largeurl"]];
                    pullimage.tag = i;
                    [pullimage sd_setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:@"avatar"]];
                    [cell addSubview:pullimage];
                    pullimage.userInteractionEnabled = YES;
                    pullimage.contentMode = UIViewContentModeScaleAspectFill;
                    pullimage.clipsToBounds = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pullimage:)];
                    pullimage.tag = i;
                    [pullimage addGestureRecognizer:tap];
                    
                    cellFrame.size.height = commentContent.frame.origin.y + ssss.size.height + pullimage.frame.size.height + 30;
                }
            }
            
            if ( [comment objectForKey:@"cmt_added_pics"] ) {
                NSArray *picArr = [comment objectForKey:@"cmt_added_pics"];
                for (int i = 0; i< [picArr count]; i++) {
                    // cell 评论图片
                    UIImageView *pullimage= [[UIImageView alloc]initWithFrame:CGRectMake(i*60+60, commentContentFrame.origin.y+ssss.size.height + 15, 50, 50)];
                    pullimage.tag = i;
                    [pullimage setImage:[picArr objectAtIndex:i]];
                    [cell addSubview:pullimage];
                    pullimage.userInteractionEnabled = YES;
                    pullimage.contentMode = UIViewContentModeScaleAspectFill;
                    pullimage.clipsToBounds = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pullimage:)];
                    pullimage.tag = i;
                    [pullimage addGestureRecognizer:tap];
                    
                    cellFrame.size.height = commentContent.frame.origin.y + ssss.size.height + pullimage.frame.size.height + 30;
                }
            }
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.frame = cellFrame;
            
            if([[comment objectForKey:UID] isEqualToString:[ghunterRequester getUserInfo:UID]]){
                UILongPressGestureRecognizer *long_press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(comment_longpressed:)];
                cell.tag = indexPath.row;
                [cell addGestureRecognizer:long_press];
            }
            
            if ([[owner objectForKey:@"uid"] isEqualToString:[ghunterRequester getUserInfo:UID]]) {
                if ([[comment objectForKey:@"uid"] isEqualToString:[ghunterRequester getUserInfo:UID]]) {
                    
                    
                }else {
                    UILongPressGestureRecognizer * rewardLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rewardLongPress:)];
                    icon.tag = indexPath.row;
                    [icon addGestureRecognizer:rewardLongPress];
                }
            }
            
            return cell;
        }
    
        //  任务秀
        if ([[Monitor sharedInstance].Identify isEqualToString:@"PJ"]) {
            
            NSDictionary * dict;
            dict = [taskShowArray objectAtIndex:indexPath.row - 1];
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"taskShow" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            
            UIImageView * userIcon = (UIImageView *)[cell viewWithTag:10];
            UILabel * userNameLabel = (UILabel *)[cell viewWithTag:14];
//            UIView * choseView = (UIView *)[cell viewWithTag:13];
            UILabel * timeLabel = (UILabel *)[cell viewWithTag:12];
            
            // 头像
            userIcon.layer.masksToBounds =YES;
            userIcon.layer.cornerRadius = userIcon.frame.size.width / 2;
            [userIcon sd_setImageWithURL:[dict objectForKey:TINY_AVATAR] placeholderImage:[UIImage imageNamed:@"avatar"]];
            [userIcon setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped)];
            [userIcon addGestureRecognizer:tap];
            userIcon.userInteractionEnabled = YES;
            
            // 名字
            userNameLabel.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"username"]];
            userNameLabel.textAlignment = NSTextAlignmentLeft;
            userNameLabel.font = [UIFont systemFontOfSize:12];
            
            UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x, userNameLabel.frame.origin.y + userNameLabel.frame.size.height + 5, 270, 20)];
            [cell addSubview:descLabel];
            // 内容
            descLabel.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"content"]];
            descLabel.numberOfLines = 0;
            descLabel.font = [UIFont systemFontOfSize:12];
            
            NSString * descString = [dict objectForKey:@"content"];
            CGSize descSize;
            descSize = [descString sizeWithFont:descLabel.font constrainedToSize:CGSizeMake(descLabel.frame.size.width, MAXFLOAT)];
            
            CGRect frame = descLabel.frame;
            frame.size.height = descSize.height + 15;
            frame.size.width = mainScreenWidth - 20 - userNameLabel.frame.origin.x;
            descLabel.frame = frame;
            
            // 时间
            timeLabel.text = [ghunterRequester getTimeDescripton:[dict objectForKey:@"createtime"]];
            CGSize size = [[ghunterRequester getTimeDescripton:[dict objectForKey:@"createtime"]] sizeWithFont:[UIFont systemFontOfSize:11]];
            timeLabel.textColor = [UIColor grayColor];
            timeLabel.font = [UIFont systemFontOfSize:11];
            timeLabel.textAlignment = NSTextAlignmentRight;
            CGRect timeFrame = timeLabel.frame;
            timeFrame.origin.x = mainScreenWidth - size.width - 10;
            timeLabel.frame = timeFrame;
            
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = descLabel.frame.origin.y + descLabel.frame.size.height + 20;
            cell.frame = cellFrame;
            
            // 图片
            NSArray *picsarray = [dict objectForKey:@"pics"];
            if (picsarray>0){
                for (int i = 0; i<picsarray.count; i++) {
                    //cell 评论图片
                    UIImageView *pullimage= [[UIImageView alloc]initWithFrame:CGRectMake(i*60+60, descLabel.frame.origin.y + descSize.height + 10, 50, 50)];
                    NSURL *imgurl = [NSURL URLWithString:[[picsarray objectAtIndex:picsarray.count - 1 - i]objectForKey:@"largeurl"]];
                    pullimage.tag = i;
                    [pullimage sd_setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:@"avatar"]];
                    [cell addSubview:pullimage];
                    pullimage.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pullimage:)];
                    pullimage.tag = i;
                    [pullimage addGestureRecognizer:tap];
                    
                    cellFrame.size.height = descLabel.frame.origin.y + descSize.height + pullimage.frame.size.height + 50;
                    cell.frame = cellFrame;
                }
            }
            
            // 任务秀按钮
            UIButton * detailBtn = (UIButton *)[cell viewWithTag:20];
            CGRect btnFrame = detailBtn.frame;
            btnFrame.origin.y = cell.frame.size.height - 40;
            detailBtn.frame = btnFrame;

            detailBtn.tag = indexPath.row;
            detailBtn.alpha = 0;
            [detailBtn setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateNormal];
            if ([[owner objectForKey:@"uid"] isEqualToString:[ghunterRequester getUserInfo:UID]]) {
                
                detailBtn.alpha = 1.0;
            }
            detailBtn.selected = NO;
            
            
            // 赏金
            UIImageView * feeImg = [[UIImageView alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x, descLabel.frame.size.height + descLabel.frame.origin.y + 5, 14, 13)];
            [cell.contentView addSubview:feeImg];
            feeImg.image = [UIImage imageNamed:@"赏"];
//            UILabel * feeLb = (UILabel *)[cell viewWithTag:31];
            feeLb = [[UILabel alloc] initWithFrame:CGRectMake(feeImg.frame.origin.x + feeImg.frame.size.width + 3, feeImg.frame.origin.y + 2, 30, 30)];
            feeLb.tag = indexPath.row + 1000;
            [cell.contentView addSubview:feeLb];
            feeLb.font = [UIFont systemFontOfSize:12];
            feeLb.textColor = RGBCOLOR(153, 153, 153);
            feeLb.text = [NSString stringWithFormat:@"x%@", [dict objectForKey:@"fee"]];
            
            // 金币
            UIImageView * coinFeeImg = [[UIImageView alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x, descLabel.frame.size.height + descLabel.frame.origin.y + 5, 14, 13)];
            coinFeeImg.image = [UIImage imageNamed:@"金币"];
            [cell.contentView addSubview:coinFeeImg];
            coinFeeLb = [[UILabel alloc] initWithFrame:CGRectMake(feeImg.frame.origin.x + feeImg.frame.size.width + 3, feeImg.frame.origin.y + 2, 30, 30)];
            coinFeeLb.tag = indexPath.row + 2000;
            [cell.contentView addSubview:coinFeeLb];
            coinFeeLb.font = [UIFont systemFontOfSize:12];
            coinFeeLb.textColor = RGBCOLOR(153, 153, 153);
            coinFeeLb.text = [NSString stringWithFormat:@"x%@", [dict objectForKey:@"coinfee"]];
            
            // 优惠券
            UIImageView * couponImg = [[UIImageView alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x, descLabel.frame.size.height + descLabel.frame.origin.y + 5, 14, 13)];
            couponImg.image = [UIImage imageNamed:@"券"];
            [cell.contentView addSubview:couponImg];
            couponLb = [[UILabel alloc] initWithFrame:CGRectMake(feeImg.frame.origin.x + feeImg.frame.size.width + 3, feeImg.frame.origin.y + 2, 30, 30)];
            couponLb.tag = indexPath.row + 3000;
            [cell.contentView addSubview:couponLb];
            couponLb.font = [UIFont systemFontOfSize:12];
            couponLb.textColor = RGBCOLOR(153, 153, 153);
            couponLb.text = [NSString stringWithFormat:@"x%@", [dict objectForKey:@"codeid"]];
            [detailBtn addTarget:self action:@selector(cellBtn:) forControlEvents:UIControlEventTouchUpInside];
            // 坐标
            CGRect feeFrame = feeImg.frame;
            CGRect feeLbFrame = feeLb.frame;
            CGRect coinFrame = coinFeeImg.frame;
            CGRect coinLbFrame = coinFeeLb.frame;
            CGRect couponImgFrame = couponImg.frame;
            CGRect couponLbFrame = couponLb.frame;
            CGFloat height;
            if (picsarray.count > 0) {
                height = descLabel.frame.origin.y + descSize.height + 5 + 60;
            }else {
                height = descLabel.frame.origin.y + descSize.height + 10;
            }
            
            feeFrame.origin.y = height + 3;
            feeFrame.origin.x = userNameLabel.frame.origin.x;
            feeImg.frame = feeFrame;
            
            feeLbFrame.origin.y = height - 5;
            feeLbFrame.origin.x = feeImg.frame.origin.x + feeImg.frame.size.width + 5;
            feeLb.frame = feeLbFrame;
            
            coinFrame.origin.y = height + 3;
            coinFrame.origin.x = feeLb.frame.size.width + feeLb.frame.origin.x + 5;
            coinFeeImg.frame = coinFrame;
            
            coinLbFrame.origin.y = height - 5;
            coinLbFrame.origin.x = coinFeeImg.frame.origin.x + coinFeeImg.frame.size.width + 5;
            coinFeeLb.frame = coinLbFrame;
            
            couponImgFrame.origin.y = height + 3;
            couponImgFrame.origin.x = coinFeeLb.frame.size.width + coinFeeLb.frame.origin.x + 5;
            couponImg.frame = couponImgFrame;
            
            couponLbFrame.origin.y = height - 5;
            couponLbFrame.origin.x = couponImg.frame.size.width + couponImg.frame.origin.x + 5;
            couponLb.frame = couponLbFrame;
            
            UILabel * lb1 = (UILabel *)[cell viewWithTag:37];
            UILabel * lb2 = (UILabel *)[cell viewWithTag:38];

            UIView * view = (UIView *)[cell viewWithTag:100];
            view.clipsToBounds = YES;
            view.layer.cornerRadius = 2;
            
            CGRect viewFrame = view.frame;
            viewFrame.origin.x = mainScreenWidth - 30;
            view.frame = viewFrame;
            
            UIButton * rewardBtn = (UIButton *)[view viewWithTag:101];
            UIButton * joinBtn = (UIButton *)[view viewWithTag:102];
            UIButton * rejectBtn = (UIButton *)[view viewWithTag:103];
            
            // 已赏 驳回 中意
            double d = [[dict objectForKey:@"fee"] doubleValue];
            if (d > 0) {
                isBounty = YES;
            }
            double i = d + [[dict objectForKey:@"coinfee"] integerValue] + [[dict objectForKey:@"codeid"] integerValue];
            if ([[dict objectForKey:@"coinfee"] integerValue] > 0) {
                isGold = YES;
            }
            if ([[dict objectForKey:@"codeid"] integerValue]) {
                isCoupon = YES;
            }
            if (d > 0 && [[dict objectForKey:@"coinfee"] integerValue] &&  [[dict objectForKey:@"codeid"] integerValue] > 0) {
                rewardBtn.enabled = NO;
                [rewardBtn setTitleColor:RGBCOLOR(76, 81, 84) forState:UIControlStateNormal];
            }
            
            NSInteger j = 0;
            NSInteger k = 0;
            if ([[dict objectForKey:@"status"] isEqualToString:@"2"]) {
                j = 1;
                rewardBtn.enabled = NO;
                [rewardBtn setTitleColor:RGBCOLOR(76, 81, 84) forState:UIControlStateNormal];
                rejectBtn.enabled = NO;
                [rejectBtn setTitleColor:RGBCOLOR(76, 81, 84) forState:UIControlStateNormal];
            }
            NSDictionary * taskuser = [task objectForKey:@"tradeuser"];
            NSDictionary * joinDic = [taskShowArray objectAtIndex:indexPath.row - 1];
            if([[taskuser objectForKey:UID] isEqualToString:[joinDic objectForKey:UID]]){
                k = 1;
                joinBtn.enabled = NO;
                [joinBtn setTitleColor:RGBCOLOR(76, 81, 84) forState:UIControlStateNormal];
                rejectBtn.enabled = NO;
                [rejectBtn setTitleColor:RGBCOLOR(76, 81, 84) forState:UIControlStateNormal];
            }
            //
            if (i > 0 && k > 0) {
                lb1.text = @"中意";
                lb1.textColor = [UIColor whiteColor];
                lb1.textAlignment = NSTextAlignmentCenter;
                lb1.backgroundColor = RGBCOLOR(157, 215, 131);
               
                lb2.text = @"已赏";
                lb2.textAlignment = NSTextAlignmentCenter;
                lb2.textColor = [UIColor whiteColor];
                lb2.backgroundColor = RGBCOLOR(249, 160, 133);
            }else if (i > 0 && j > 0){
                lb1.text = @"已赏";
                lb1.textAlignment = NSTextAlignmentCenter;
                lb1.textColor = [UIColor whiteColor];
                lb1.backgroundColor = RGBCOLOR(249, 160, 133);
                
                lb2.text = @"驳回";
                lb2.textAlignment = NSTextAlignmentCenter;
                lb2.textColor = [UIColor whiteColor];
                lb2.backgroundColor = RGBCOLOR(153, 153, 153);
            }else if (i > 0) {
                lb1.text = @"已赏";
                lb1.textAlignment = NSTextAlignmentCenter;
                lb1.textColor = [UIColor whiteColor];
                lb1.backgroundColor = RGBCOLOR(249, 160, 133);
            }else if (j > 0) {
                lb1.text = @"驳回";
                lb1.textAlignment = NSTextAlignmentCenter;
                lb1.textColor = [UIColor whiteColor];
                lb1.backgroundColor = RGBCOLOR(153, 153, 153);
            }else if (k > 0) {
                lb1.text = @"中意";
                lb1.textColor = [UIColor whiteColor];
                lb1.textAlignment = NSTextAlignmentCenter;
                lb1.backgroundColor = RGBCOLOR(157, 215, 131);
            }
            
            // 线
            UILabel * lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5, mainScreenWidth, 0.5)];
            lineLb.backgroundColor = RGBCOLOR(235, 235, 235);
            [cell addSubview:lineLb];
            
            return cell;
        }
        return cell;
    }
}

#pragma mark---------点击展开收起按钮-----------------

-(void)stopbtn:(UIButton *)btn{
    self.yesorno  = @"yes";
    Stopbtn.hidden = YES;
    zankaibtn.hidden =NO;
    [taskTable reloadData];
}
-(void)zankai:(UIButton *)btn{
    self.yesorno = @"no";
    Stopbtn.hidden = NO;
    zankaibtn.hidden =YES;
    [taskTable reloadData];
}

-(void)pullimage:(UITapGestureRecognizer *)tap{
    [SJAvatarBrowser showImage:(UIImageView*)tap.view];
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
}

#pragma mark - Refresh and load more methods

- (void)refreshTable
{
//    page = 1;
//    //获取任务详情
//    [self didGetTaskDetailIsloading:NO isWithCommets:YES];
    page = 1;
    //获取任务详情
    [self didGetTaskDetailIsloading:NO isWithCommets:YES];
    taskPage = 1;
    [self didGetTaskShow4TaskIsloading:NO WithTaskTid:self.tid andWithPages:taskPage];
}

- (void)loadMoreDataToTable
{
//    //加载更多评论
//    [self didGetComments4TaskIsloading:NO page:page];
    //加载更多评论
    if ( [[Monitor sharedInstance].Identify isEqualToString:@"PL"]) {
        [self didGetComments4TaskIsloading:NO page:page];
    }else{
        [self didGetTaskShow4TaskIsloading:NO WithTaskTid:self.tid andWithPages:taskPage];
    }
}

#pragma mark - CustomMethod

- (void)startLoad{
    loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [loadingView startAnimition];
}

- (void)endLoad{
    [loadingView inValidate];
}

- (IBAction)back:(id)sender {
    if (self.fromPush) {
        // 推送过来的任务
        self.callBackBlock();
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        self.callBackBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark========点击评论按钮btn=======
- (IBAction)comment:(id)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    [self.view addSubview:toolBar];
    [self.view addSubview:addedImageLayout];
    if ( [dataimgarr count] > 0 ) {
        addedImageLayout.hidden = NO;
    }else{
        addedImageLayout.hidden = YES;
    }
    self.reply_cid = @"";
    self.reply_uid = @"";
    textViewTip.text = @"";
    textViewTip.hidden = YES;
    [self.textView becomeFirstResponder];
}

#pragma mark --- 选择猎人评论 --- 
-(void)selectComment:(UIButton *) sender {
    
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    [self.view addSubview:toolBar];
    [self.view addSubview:addedImageLayout];
    if ( [dataimgarr count] > 0 ) {
        addedImageLayout.hidden = NO;
    }else{
        addedImageLayout.hidden = YES;
    }
    self.reply_cid = @"";
    self.reply_uid = @"";
    textViewTip.text = @"";
    textViewTip.hidden = YES;
    [self.textView becomeFirstResponder];

}

#pragma mark --- 分享 ---
- (IBAction)share:(id)sender {
    if (shareAlertView != nil) {
        [shareAlertView show];
        return;
    }
    shareAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"shareView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    [shareAlertView setCornerRadius:8.0];
    CGRect taskfilterFrame = taskFilter.frame;
    taskfilterFrame.size.width = mainScreenWidth - 20;
    taskFilter.frame = taskfilterFrame;
    
    shareAlertView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height - 10), taskfilterFrame.size.width, taskfilterFrame.size.height);
    shareAlertView.showView = taskFilter;
    UIButton *weixincircle = (UIButton *)[taskFilter viewWithTag:1];
    UIButton *weixinfried = (UIButton *)[taskFilter viewWithTag:2];
    UIButton *weibo = (UIButton *)[taskFilter viewWithTag:3];
    UIButton *qzone = (UIButton*)[taskFilter viewWithTag:6];
    UIButton *qq = (UIButton*)[taskFilter viewWithTag:7];
    UIButton *copy = (UIButton *)[taskFilter viewWithTag:4];
    UIButton *cancel = (UIButton *)[taskFilter viewWithTag:5];
    [weixincircle addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [weixinfried addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [weibo addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [copy addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [qzone addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [qq addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];

    shareAlertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    
    [shareAlertView show];
}

// 分享任务到第三方平台
-(void)shareToPlatforms:(id)sender{
    [shareAlertView dismissAnimated:YES];
    UIButton *btn = (UIButton *)sender;
    int code = [AFNetworkTool getHunterID:[[ghunterRequester getUserInfo:UID] intValue] :0];
    NSString *shareUrl = [NSString stringWithFormat:@"http://apiadmin.imgondar.com/mobile/task/view?tid=%@&code=%zd", self.tid, code];
    
    if ( [btn tag] == 1 ) {
        // wxcircle
        NSDictionary *info = [task objectForKey:@"info"];
        NSDictionary *owner = [task objectForKey:@"owner"];
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[owner objectForKey:MIDDLE_AVATAR]];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"【%@】悬赏￥%@，我需要「%@」", APP_NAME, [info objectForKey:@"bounty"],[info objectForKey:@"title"]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.tid :SHARETYPE_TASK :self.tid :SHAREPLATFORM_WXMOMENTS];
            }
        }];
    }else if([btn tag] == 2){
        // weixinfriend
        NSDictionary *info = [task objectForKey:@"info"];
        NSDictionary *owner = [task objectForKey:@"owner"];
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[owner objectForKey:MIDDLE_AVATAR]];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = APP_NAME;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"悬赏￥%@，我需要「%@」",[info objectForKey:@"bounty"],[info objectForKey:@"title"]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                 [AFNetworkTool share_record:self.tid :SHARETYPE_TASK :self.tid :SHAREPLATFORM_WECHAT];
            }
        }];
    }else if([btn tag] == 3){
        // weibo
        NSDictionary *owner = [task objectForKey:@"owner"];
        NSDictionary *info = [task objectForKey:@"info"];
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[owner objectForKey:MIDDLE_AVATAR]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"#赏金猎人#我在@赏金猎人imGondar 发现任务【悬赏￥%@】Ta需要「%@」 赶快戳进来看看 http://mob.imGondar.com/task/view?tid=%@",[info objectForKey:@"bounty"],[info objectForKey:@"title"],self.tid] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.tid :SHARETYPE_TASK :self.tid :SHAREPLATFORM_SINAWEIBO];
            }
        }];
    }else if([btn tag] == 4){
        // copy
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:shareUrl];
        [ProgressHUD show:@"已复制到剪贴板"];
        [shareAlertView dismissAnimated:YES];
    }else if([btn tag] == 5){
        // cancel
        [shareAlertView dismissAnimated:YES];
    }else if([btn tag] == 6){
        // qzone
        NSDictionary *owner = [task objectForKey:@"owner"];
        NSDictionary *info = [task objectForKey:@"info"];
        if (![QQApiInterface isQQInstalled]) {
            [AFNetworkTool isInstallQQ];
            return;
        }

        [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
        [UMSocialData defaultData].extConfig.qzoneData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[owner objectForKey:MIDDLE_AVATAR]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:[NSString stringWithFormat:@"悬赏￥%@，我需要「%@」",[info objectForKey:@"bounty"],[info objectForKey:@"title"]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.tid :SHARETYPE_TASK :self.tid:SHAREPLATFORM_QZONE];
            }
        }];
    }else if([btn tag] == 7){
        // qq
        NSDictionary *info = [task objectForKey:@"info"];
        NSDictionary *owner = [task objectForKey:@"owner"];
        if (![QQApiInterface isQQInstalled]) {
            [AFNetworkTool isInstallQQ];
            return;
        }

        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        [UMSocialData defaultData].extConfig.qqData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[owner objectForKey:MIDDLE_AVATAR]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[NSString stringWithFormat:@"悬赏￥%@，我需要「%@」",[info objectForKey:@"bounty"],[info objectForKey:@"title"]]  image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.tid :SHARETYPE_TASK :self.tid:SHAREPLATFORM_QQ];
            }
        }];
    }
}

#pragma mark --- 参与竞标 ---
// 竞标
- (void)bid:(UIButton *)sender {
    if (!imgondar_islogin) {
//        [ProgressHUD show:UNLOGIN_ERROR];
        [self click2Login];
        return;
    }
    // NSDictionary *info = [task objectForKey:@"info"];
    if([self.biddingLabel.text isEqualToString:@"参与竞标"])
    {
//        self.actionJoin = [[UIActionSheet alloc] initWithTitle:@"若任务主人选择您,您的手机号将显示给对方,您也将获知对方的手机号,确定参与吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
//        [self.actionJoin showInView:self.view];
        ghunterBiddingReasonViewController * biddingReason = [[ghunterBiddingReasonViewController alloc] init];
        biddingReason.tidStr = self.tid;
        biddingReason.flagStr = @"1";
        [self.navigationController pushViewController:biddingReason animated:YES];
    }
    else if([self.biddingLabel.text isEqualToString:@"任务秀"])
    {
//        self.actionCancel = [[UIActionSheet alloc] initWithTitle:@"取消竞标能力值-3，活跃度-3，且不能再次参与竞标此任务，确定取消竞标吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
//        [self.actionCancel showInView:self.view];
        ghunterBiddingReasonViewController * biddingReason = [[ghunterBiddingReasonViewController alloc] init];
        biddingReason.tidStr = self.tid;
        biddingReason.flagStr = @"2";
        [self.navigationController pushViewController:biddingReason animated:YES];
    }
}

#pragma mark --- 选择猎人 ---
- (void)selectHunter:(UIButton *)sender {

    ghunterselecthunterViewController *ghunterselecthunter = [[ghunterselecthunterViewController alloc] init];
    ghunterselecthunter.tid = self.tid;
    [self.textView resignFirstResponder];
    [self.navigationController pushViewController:ghunterselecthunter animated:YES];
    
    /*
    ghunterRewardAndSelectViewController * rewardVC = [[ghunterRewardAndSelectViewController alloc] init];
    rewardVC.bidString = [NSString stringWithFormat:@"%@", [[task objectForKey:@"stat"] objectForKey:@"biddingCount"]];
    rewardVC.tidString = self.tid;
    [self.navigationController pushViewController:rewardVC animated:YES];
     */
    
}


#pragma mark - 修改任务&申请退款
- (void)more:(UIButton *)sender {
    moreAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"moreView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    [moreAlertView setCornerRadius:8.0];
    CGRect taskfilterFrame = taskFilter.frame;
    moreAlertView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height) / 2.0, taskfilterFrame.size.width, taskfilterFrame.size.height);
    moreAlertView.showView = taskFilter;
    UIButton *modifyTask = (UIButton *)[taskFilter viewWithTag:1];
    UIButton *applyRefund = (UIButton *)[taskFilter viewWithTag:2];
    [modifyTask addTarget:self action:@selector(modifyTask:) forControlEvents:UIControlEventTouchUpInside];
    [applyRefund addTarget:self action:@selector(applyRefund:) forControlEvents:UIControlEventTouchUpInside];
    moreAlertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    [moreAlertView show];
}

- (IBAction)modify_overtime:(id)sender {
    ghunterModifyTaskViewController *modify = [[ghunterModifyTaskViewController alloc] init];
    [self.textView resignFirstResponder];
    modify.tid = self.tid;
    modify.titleStr = [[task objectForKey:@"info"] objectForKey:@"title"];
    modify.descriptionStr = [[task objectForKey:@"info"] objectForKey:@"description"];
    modify.goldNum = [[task objectForKey:@"info"] objectForKey:@"bounty"];
    modify.dateline = [[task objectForKey:@"info"] objectForKey:@"trade_dateline"];
    [self.navigationController pushViewController:modify animated:YES];
}

- (void)modify:(NSNotification *)notification{
    
    [self didGetTaskDetailIsloading:YES isWithCommets:NO];
}
- (void) tapImageViewTappedWithObject:(id)sender
{
    ImgScrollView *tmpImgView = sender;
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
    }];
}


- (void)report:(id)sender{
    if(imgondar_islogin) {
        reportAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"reportView" owner:self options:nil];
        self.popReportView = [[UIView alloc] init];
        self.popReportView = [nibs objectAtIndex:0];
        [reportAlertView setCornerRadius:8.0];
        CGRect width = self.popReportView.frame;
        width.size.width = mainScreenWidth - 20;
        self.popReportView.frame = width;
        CGRect taskfilterFrame = self.popReportView.frame;
        reportAlertView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, mainScreenheight - taskfilterFrame.size.height - 10, taskfilterFrame.size.width, taskfilterFrame.size.height);
        reportAlertView.showView = self.popReportView;
        UIButton *cancel = (UIButton *)[self.popReportView viewWithTag:1];
        UIButton *confirm = (UIButton *)[self.popReportView viewWithTag:2];
        self.reportText = (HPGrowingTextView *)[self.popReportView viewWithTag:3];
        
        self.textTip = (UILabel *)[self.popReportView viewWithTag:4];
        self.reportText.delegate = self;
        
        [cancel addTarget:self action:@selector(cancelReport:) forControlEvents:UIControlEventTouchUpInside];
        [confirm addTarget:self action:@selector(confirmReport:) forControlEvents:UIControlEventTouchUpInside];
        reportAlertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
        reportAlertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        [reportAlertView show];
    }
}

#pragma mark --- 联系Ta --- 
-(void)phoneHhunter:(UIButton *) sender {
    NSDictionary *owner = [task objectForKey:@"owner"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[owner objectForKey:@"phone"]]]];
}

- (void)fadeIn:(UIView *)popView{
    popView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    popView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        popView.alpha = 1;
        popView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)fadeOut:(UIView *)popView{
    [UIView animateWithDuration:0.3 animations:^{
        popView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        popView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [popView removeFromSuperview];
        }
    }];
}

- (void)cancelReport:(id)sender{
    [reportAlertView dismissAnimated:YES];
}

- (void)confirmReport:(id)sender{
    if ([self.reportText.text length] == 0) {
        [self.reportText resignFirstResponder];
        return;
    }
    [reportAlertView dismissAnimated:YES];
    self.reportText = (HPGrowingTextView *)[self.popReportView viewWithTag:3];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.tid forKey:@"oid"];
    [dic setObject:@"3" forKey:@"type"];
    [dic setObject:self.reportText.text forKey:@"content"];
    [ghunterRequester postwithDelegate:self withUrl:URL_REPORT_TASK withUserInfo:REQUEST_FOR_REPORT withDictionary:dic];
}

- (void)selectHunterOK:(id)sender{
    [self didGetTaskDetailIsloading:YES isWithCommets:NO];
}

- (void)confirmPay:(UIButton *)sender {
    ghunterEvaluationViewController *evaluation = [[ghunterEvaluationViewController alloc] init];
    evaluation.tid = self.tid;
    evaluation.dic = [task objectForKey:@"info"];
    evaluation.type = 0;
    evaluation.user_avatar = [[task objectForKey:@"owner"] objectForKey:MIDDLE_AVATAR];
    [self.textView resignFirstResponder];
    [self.navigationController pushViewController:evaluation animated:YES];
}

- (void)pay_comment:(id)sender{
    for (UIView *view in [tasktailView subviews]) {
        [view removeFromSuperview];
    }
    [tasktailView addSubview:self.commentedView];
}

- (void)contactHunter:(UIButton *)sender {
    contactAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"contactView" owner:self options:nil];
    self.popContactView = [[UIView alloc] init];
    self.popContactView = [nibs objectAtIndex:0];
    [contactAlertView setCornerRadius:8.0];
    CGRect taskfilterFrame = self.popContactView.frame;
//    taskfilterFrame.size.width = mainScreenWidth - 20;
//    self.popContactView.frame = taskfilterFrame;
    contactAlertView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, mainScreenheight - taskfilterFrame.size.height - 10, taskfilterFrame.size.width, taskfilterFrame.size.height);
    contactAlertView.showView = self.popContactView;
    UIImageView *icon = (UIImageView *)[self.popContactView viewWithTag:1];
    UILabel *username = (UILabel *)[self.popContactView viewWithTag:2];
    UILabel *phone = (UILabel *)[self.popContactView viewWithTag:3];
    UIButton *phoneCall = (UIButton *)[self.popContactView viewWithTag:4];
    UIButton *SMS = (UIButton *)[self.popContactView viewWithTag:5];
    UIButton *add2Contacts = (UIButton *)[self.popContactView viewWithTag:6];
    UIButton *cancel = (UIButton *)[self.popContactView viewWithTag:7];
    NSDictionary *tradeuser = [task objectForKey:@"tradeuser"];
    icon.clipsToBounds = YES;
    icon.layer.cornerRadius = Radius;
    [icon sd_setImageWithURL:[tradeuser objectForKey:MIDDLE_AVATAR] placeholderImage:[UIImage imageNamed:@"avatar"]];
    [username setText:[tradeuser objectForKey:@"username"]];
    [phone setText:[tradeuser objectForKey:@"phone"]];
    [phoneCall addTarget:self action:@selector(phoneCall) forControlEvents:UIControlEventTouchUpInside];
    [SMS addTarget:self action:@selector(SMS) forControlEvents:UIControlEventTouchUpInside];
    [add2Contacts addTarget:self action:@selector(add2Contacts) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(contactCancel) forControlEvents:UIControlEventTouchUpInside];
    contactAlertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    contactAlertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [contactAlertView show];
}

- (void)phoneCall{
    [contactAlertView dismissAnimated:YES];
    NSDictionary *tradeuser = [task objectForKey:@"tradeuser"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[tradeuser objectForKey:@"phone"]]]];
    [self fadeOut:self.popContactView];
}

- (void)SMS{
    [contactAlertView dismissAnimated:YES];
    NSDictionary *tradeuser = [task objectForKey:@"tradeuser"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",[tradeuser objectForKey:@"phone"]]]];
    [self fadeOut:self.popContactView];
}

- (void)contactCancel {
    [contactAlertView dismissAnimated:YES];
}

- (void)add2Contacts{
    [contactAlertView dismissAnimated:YES];
    
    //如果没有授权则退出
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"此应用没有权限访问你的通讯录,请在“隐私设置”中启用访问" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView show];
        return ;
    }
    NSDictionary *tradeuser = [task objectForKey:@"tradeuser"];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    if (&ABAddressBookRequestAccessWithCompletion != NULL) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    ABRecordRef person = ABPersonCreate();
    NSString *firstName = [tradeuser objectForKey:@"username"];
    NSArray *phones = [NSArray arrayWithObjects:[tradeuser objectForKey:@"phone"],nil];
    NSArray *labels = [NSArray arrayWithObjects:@"iphone",nil];
    // 设置firstName属性
    ABRecordSetValue(person, kABPersonFirstNameProperty,(__bridge CFStringRef)firstName, NULL);
    // ABMultiValueRef类似是Objective-C中的NSMutableDictionary
    ABMultiValueRef mv =ABMultiValueCreateMutable(kABMultiStringPropertyType);
    // 添加电话号码与其对应的名称内容
    for (NSUInteger i = 0; i < [phones count]; i ++) {
        ABMultiValueIdentifier mi = ABMultiValueAddValueAndLabel(mv,(__bridge CFStringRef)[phones objectAtIndex:i], (__bridge CFStringRef)[labels objectAtIndex:i], &mi);
    }
    // 设置phone属性
    ABRecordSetValue(person, kABPersonPhoneProperty, mv, NULL);
   
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    picker.displayedPerson = person;
    picker.newPersonViewDelegate = self;
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)contactAfterFinish:(UIButton *)sender {
    NSDictionary *tradeuser = [task objectForKey:@"tradeuser"];
    NSDictionary *owner = [task objectForKey:@"owner"];
    if ([[tradeuser objectForKey:@"uid"] isEqualToString:[ghunterRequester getUserInfo:@"uid"]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[owner objectForKey:@"phone"]]]];
    } else {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[tradeuser objectForKey:@"phone"]]]];
    }
}

- (void)withdrawPay:(UIButton *)sender {
    self.withdraw = [[UIActionSheet alloc] initWithTitle:@"申请退款需要征得所选猎人的同意,并且双方都会被惩罚扣除能力值,待双方同意后,赏金会转回您的账户,该任务也将失效,确认继续?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [self.withdraw showInView:self.view];
}

- (IBAction)saveBounty:(id)sender {
    NSDictionary *owner = [task objectForKey:@"owner"];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    if (ABAddressBookRequestAccessWithCompletion != NULL) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    ABRecordRef person = ABPersonCreate();
    NSString *firstName = [owner objectForKey:@"username"];
    NSArray *phones = [NSArray arrayWithObjects:[owner objectForKey:@"phone"],nil];
    NSArray *labels = [NSArray arrayWithObjects:@"iphone",nil];
    // 设置firstName属性
    ABRecordSetValue(person, kABPersonFirstNameProperty,(__bridge CFStringRef)firstName, NULL);
    // ABMultiValueRef类似是Objective-C中的NSMutableDictionary
    ABMultiValueRef mv =ABMultiValueCreateMutable(kABMultiStringPropertyType);
    // 添加电话号码与其对应的名称内容
    for (NSUInteger i = 0; i < [phones count]; i ++) {
        ABMultiValueIdentifier mi = ABMultiValueAddValueAndLabel(mv,(__bridge CFStringRef)[phones objectAtIndex:i], (__bridge CFStringRef)[labels objectAtIndex:i], &mi);
    }
    // 设置phone属性
    ABRecordSetValue(person, kABPersonPhoneProperty, mv, NULL);
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    picker.displayedPerson = person;
    picker.newPersonViewDelegate = self;
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (IBAction)phoneBounty:(id)sender {
    NSDictionary *owner = [task objectForKey:@"owner"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[owner objectForKey:@"phone"]]]];
}

- (IBAction)SMSBounty:(id)sender {
    NSDictionary *owner = [task objectForKey:@"owner"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",[owner objectForKey:@"phone"]]]];
}

- (void)back_doing:(id)sender{
    page = 1;
    
    [self didGetTaskDetailIsloading:YES isWithCommets:NO];
}

- (IBAction)modifyWithdraw:(id)sender {
    self.modifyWithdraw = [[UIActionSheet alloc] initWithTitle:@"再次修改会覆盖上次的退款申请信息,确定申请退款?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [self.modifyWithdraw showInView:self.view];
}

- (IBAction)handleWithDraw:(id)sender {
    NSDictionary *withdraw = [task objectForKey:@"withdraw"];
    NSDictionary *info = [task objectForKey:@"info"];
    ghunterHandleWithDrawViewController *handle = [[ghunterHandleWithDrawViewController alloc] init];
    if([[withdraw objectForKey:@"dealresult"] isEqualToString:@"0"]){
        handle.stage = @"no_handled";
    }else if ([[withdraw objectForKey:@"dealresult"] isEqualToString:@"1"]){
        [ghunterRequester showTip:@"任务已退款"];
        return;
    }else{
        handle.stage = @"disagree";
    }
    handle.tid = self.tid;
    handle.dic = withdraw;
    handle.bounty = [info objectForKey:@"bounty"];
    [self.textView resignFirstResponder];
    
    toolBar.hidden = YES;
    [dataimgarr removeAllObjects];
    [self.navigationController pushViewController:handle animated:YES];
}

- (void)handle_withdraw:(NSNotification *)sender{
    [self didGetTaskDetailIsloading:YES isWithCommets:NO];
}

- (void)commentTask:(UIButton *)sender {
    ghunterEvaluationViewController *evaluation = [[ghunterEvaluationViewController alloc] init];
    evaluation.type = 1;
    evaluation.dic = [task objectForKey:@"info"];
    evaluation.tid = self.tid;
    evaluation.user_avatar = [[task objectForKey:@"tradeuser"] objectForKey:MIDDLE_AVATAR];
    [self.textView resignFirstResponder];
    [self.navigationController pushViewController:evaluation animated:YES];
}

// 查看评价
- (void)showComment:(UIButton *)sender {
    ghunterCheckEvaluationViewController *evaView = [[ghunterCheckEvaluationViewController alloc] init];
    evaView.tid = self.tid;
    [self.textView resignFirstResponder];
    [self.navigationController pushViewController:evaView animated:YES];
}


// 修改任务
- (void)modifyTask:(id)sender {
    [moreAlertView dismissAnimated:YES];
    [self.textView resignFirstResponder];
    
    ghunterModifyTaskViewController *modify = [[ghunterModifyTaskViewController alloc] init];
    modify.tid = self.tid;
    modify.titleStr = [[task objectForKey:@"info"] objectForKey:@"title"];
    modify.descriptionStr = [[task objectForKey:@"info"] objectForKey:@"description"];
    modify.goldNum = [[task objectForKey:@"info"] objectForKey:@"bounty"];
    modify.dateline = [[task objectForKey:@"info"] objectForKey:@"trade_dateline"];
    [self.navigationController pushViewController:modify animated:YES];
}

- (void)applyRefund:(id)sender {
    [moreAlertView dismissAnimated:YES];
    self.actionBack = [[UIActionSheet alloc] initWithTitle:@"申请退款将被惩罚降低能力值,可能会影响您的等级和体力值,任务也将失效,是否继续退款" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [self.actionBack showInView:self.view];
}

- (IBAction)applyTimeoutRefund:(id)sender {
    self.actionBack = [[UIActionSheet alloc] initWithTitle:@"申请退款将被惩罚降低能力值,可能会影响您的等级和体力值,任务也将失效,是否继续退款" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [self.actionBack showInView:self.view];
}

// 点击查看大图
- (void)pic_taped:(UITapGestureRecognizer *)sender {
    CGSize scrollSize = myScrollView.contentSize;
    scrollSize.width = mainScreenWidth * [imgArray count];
    myScrollView.contentSize = scrollSize;
    [self tappedWithObject:sender.view];
}

// 长按保存图片
-(void)saveImage:(UIGestureRecognizer *)sender{
    NSInteger row = [sender.view tag];
    if(UIGestureRecognizerStateBegan == sender.state) {
        saveAction = [[UIActionSheet alloc] initWithTitle:@"保存图片到相册?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        saveAction.tag = row;
        [saveAction showInView:sender.view];
    }
}

#pragma mark --- 长按删除评论 ---
- (void)comment_longpressed:(UILongPressGestureRecognizer *)sender {
    if(UIGestureRecognizerStateBegan == sender.state) {
        self.deleteComment = [[UIActionSheet alloc] initWithTitle:@"删除评论?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        self.deleteComment.tag = sender.view.tag;
        [self.deleteComment showInView:self.view];
    }
}

#pragma mark --- 长按打赏 ---
-(void)rewardLongPress:(UILongPressGestureRecognizer *) sender {
    
    is4Comment = YES;
    is4Show = NO;
    NSString * tid = [[task objectForKey:@"info"] objectForKey:@"tid"];
    NSString * uid = [[taskcommentArray objectAtIndex:sender.view.tag - 1] objectForKey:@"uid"];
    
    if(UIGestureRecognizerStateBegan == sender.state) {
        [self didGetGoldNumDataIsloading:NO];
//        UIView * view = (UIView *)[btn2 superview];
//        view.alpha = 0.0f;
        [self didTaskDetailRewardIsLoading:NO withTid:tid andWithUid:uid andWith:sender.view.tag];
    }
    
}


#pragma mark --- 长按打赏请求数据 ---
- (void) didTaskDetailRewardIsLoading:(BOOL) isLoading withTid:(NSString *) tid andWithUid:(NSString *)uid andWith:(NSInteger) tagNum{
    if (isLoading) {
        [self startLoad];
    }
    _isfee.tag = 4000+tagNum;
    _iscoinfee.tag = 5000+tagNum;
    _iscodeid.tag = 6000+tagNum;
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:tid forKey:@"tid"];
    [dict setObject:uid forKey:@"uid"];
    
    [AFNetworkTool httpRequestWithUrl:URL_TASKDETAIL_WITH_HUNTER params:dict success:^(NSData *data) {
        if (isLoading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSDictionary * rwDict = [result objectForKey:@"usertask"];
        if ([[result objectForKey:@"error"]integerValue] == 0 && [[rwDict objectForKey:@"isjoin"] isEqualToString:@"1"]) {
            

            if ([[rwDict objectForKey:@"fee"] doubleValue] > 0) {
                _isfee.text = [rwDict objectForKey:@"fee"];
            }else
            {
                _isfee.text = @"0";
            }
            if ([[rwDict objectForKey:@"coinfee"] integerValue] > 0) {
                _iscoinfee.text = [rwDict objectForKey:@"coinfee"];
            }else
            {
                _iscoinfee.text = @"0";
            }
            if ([[rwDict objectForKey:@"codeid"] integerValue] > 0) {
                _iscodeid.text = [rwDict objectForKey:@"codeid"];
            }else
            {
                _iscodeid.text = @"0";
            }

            [self longreward:tagNum];
        }else{
            [ProgressHUD show:@"猎人未参与任务!"];
        }
    } fail:^{
        
    }];
    
}



#pragma mark - Action
- (void)tip_hunter:(UIGestureRecognizer *)sender {
    NSArray *joiners = [task objectForKey:@"joiners"];
    NSDictionary *joiner = [joiners objectAtIndex:sender.view.tag];
    if (sender.state == UIGestureRecognizerStateBegan) {
        if([[joiner objectForKey:@"fee"] doubleValue] > 0) {
            [ProgressHUD show:[NSString stringWithFormat:@"已赏%.2f元",[[joiner objectForKey:@"fee"] doubleValue]]];
        }else if ([[joiner objectForKey:@"coinfee"] integerValue]>0)
        {
            [ProgressHUD show:[NSString stringWithFormat:@"已赏%ld金币",[[joiner objectForKey:@"coinfee"] integerValue]]];
            
        }else if ([[joiner objectForKey:@"codeid"] integerValue]>0)
        {
            [ProgressHUD show:[NSString stringWithFormat:@"已赏%ld优惠券",[[joiner objectForKey:@"codeid"] integerValue]]];
            
        }else {
            NSInteger A = sender.view.tag;
            [self iconreward:sender.view.tag+1];
            
        }
    }
}

- (void)recharge:(id)sender {
    [_textView resignFirstResponder];
    [tipAlertView dismissAnimated:YES];
    ghunterRechargeViewController *recharge = [[ghunterRechargeViewController alloc] init];
    [self.navigationController pushViewController:recharge animated:YES];
}

#pragma mark --- 竞标长按打赏确定 ---
- (void)tipconfirm:(UIButton *)sender {
    NSDictionary *info = [task objectForKey:@"info"];
    UITextField *reward = (UITextField *)[tipAlertView.showView viewWithTag:106];
    if([reward.text length] == 0){
        return;
    }
    NSString *regex = @"^\\d+(.\\d{1,2})?$";
    if (![reward.text isMatchedByRegex:regex]) {
        [tipAlertView endEditing:YES];
        [ghunterRequester showTip:@"打赏最多保留两位小数"];
        return;
    }
    
    double rewardInt = [reward.text doubleValue];
    double balanceInt = [[account objectForKey:@"balance"] doubleValue];
    double bountyInt = [[info objectForKey:@"bounty"] doubleValue];
    
    if(rewardInt > balanceInt){
        [tipAlertView endEditing:YES];
        [ghunterRequester showTip:@"金库余额不足，请先充值"];
        return;
    }
    if (rewardInt < 0.1) {
        [tipAlertView endEditing:YES];
        [ghunterRequester showTip:@"打赏最低额度为0.1元"];
        return;
    }
    if (rewardInt > bountyInt) {
        [tipAlertView endEditing:YES];
        [ghunterRequester showTip:@"打赏金额不能超过任务赏金"];
        return;
    } else {
        [self startLoad];
        NSArray *joiners = [task objectForKey:@"joiners"];
        NSDictionary *joiner = [joiners objectAtIndex:sender.tag];
        
        //GET method
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:self.tid forKey:@"tid"];
        [parameters setObject:[joiner objectForKey:@"uid"] forKey:@"uid"];
        [parameters setObject:[NSString stringWithFormat:@"%lf", rewardInt] forKey:@"fee"];
        
        [AFNetworkTool httpRequestWithUrl:URL_LEAVE_FEE params:parameters success:^(NSData *data) {
            [self endLoad];
            
            NSError *error;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            [ProgressHUD show:[result objectForKey:@"msg"]];
            if([[result objectForKey:@"error"]integerValue] == 0)
            {
                [self didGetTaskDetailIsloading:NO isWithCommets:NO];
            }else{
                [self endLoad];
            }
        } fail:^{
            [self endLoad];
            [ProgressHUD show:HTTPREQUEST_ERROR];
        }];
    }
    [tipAlertView endEditing:YES];
}

- (void)tipcancel:(id)sender {
    _faceView.hidden=YES;
    toolBar.hidden=YES;
    // 弹框消失
    [tipAlertView dismissAnimated:YES];
}

- (void)imageClicked:(UIGestureRecognizer *)sender{
    ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
    NSArray *joiners = [task objectForKey:@"joiners"];
    NSDictionary *joiner = [joiners objectAtIndex:sender.view.tag];
    userCenter.uid = [joiner objectForKey:UID];
    
    [self.textView resignFirstResponder];
    
    [self.navigationController pushViewController:userCenter animated:YES];
}

- (void)iconTaped{
    ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
        NSDictionary *owner = [task objectForKey:@"owner"];
        userCenter.uid = [owner objectForKey:UID];
    [_textView resignFirstResponder];
    [self.navigationController pushViewController:userCenter animated:YES];
}


// 点击评论/评价按钮
- (void)commentHunter:(UITapGestureRecognizer *)sender{
    NSUInteger tag = sender.view.tag;
    
    ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
    NSDictionary *comment;
   
        comment = [taskcommentArray objectAtIndex:tag];
         userCenter.uid = [comment objectForKey:UID];
    [_textView resignFirstResponder];
    [self.navigationController pushViewController:userCenter animated:YES];
}

// 参与竞标任务
-(void)didJoinTaskIsloading:(BOOL )isloading{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?tid=%@", URL_JOIN_TASK, self.tid] params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [ProgressHUD show:[result objectForKey:@"msg"]];
        if ([[result objectForKey:@"error"] integerValue] == 0) {
            _isjoin = @"1";
            [self setBidButtonStatus:_isjoin];
            
            NSMutableArray *joiners = [task objectForKey:@"joiners"];
            joiners = [joiners mutableCopy];
            NSMutableDictionary *joiner = [[NSMutableDictionary alloc] init];
            [joiner setObject:[ghunterRequester getUserInfo:UID] forKey:UID];
            [joiner setObject:[ghunterRequester getUserInfo:USERNAME] forKey:USERNAME];
            [joiner setObject:[ghunterRequester getUserInfo:TINY_AVATAR] forKey:TINY_AVATAR];
            [joiners insertObject:joiner atIndex:0];
            task = [task mutableCopy];
            [task setObject:joiners forKey:@"joiners"];
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [taskTable reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}

#pragma mark --- 取消竞标任务 ---
// 取消竞标任务
-(void)didUnjoinTaskIsloading:(BOOL )isloading{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?tid=%@", URL_UNJOIN_TASK, self.tid] params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [ProgressHUD show:[result objectForKey:@"msg"]];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            _isjoin = @"2";
            [self setBidButtonStatus:_isjoin];
            [self didGetTaskDetailIsloading:NO isWithCommets:NO];
        }else{
            
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSDictionary *info = [task objectForKey:@"info"];
    if (buttonIndex == 0) {
        if(actionSheet == self.actionJoin){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:self.tid forKey:@"tid"];
            // 参与竞标
            [self didJoinTaskIsloading:YES];
            // 中意猎人
//            NSDictionary * dict = [taskShowArray objectAtIndex:self.actionJoin.tag];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//            [dic setObject:self.tid forKey:@"tid"];
//            [dic setObject:[dict objectForKey:@"uid"] forKey:@"uid"];
//            [self didSelectHunterIsloading:NO withParameters:dic];

        }else if (actionSheet == self.rejectTaskShow){
            
            NSDictionary * showDict = [taskShowArray objectAtIndex:self.actionJoin.tag];
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[showDict objectForKey:@"tsid"] forKey:@"tsid"];
            
            // 驳回任务秀
            [self didRejectTaskShowIsLoading:NO withParameters:dict];
        }
        else if (actionSheet == self.actionBack){
            // 竞标中的任务，申请退款
            [self startLoad];
            [ghunterRequester getwithDelegate:self withUrl:URL_BACK_BIDDING withUserInfo:REQUEST_FOR_BACK_BIDDING withString:[NSString stringWithFormat:@"?%@=%@",@"tid",self.tid]];
        }
        else if(actionSheet == self.withdraw){
            ghunterWithdrawReasonViewController *reason = [[ghunterWithdrawReasonViewController alloc] init];
            reason.tid = self.tid;
            reason.bounty = [info objectForKey:@"bounty"];
            reason.entranceType = @"normal";
            [_textView resignFirstResponder];
            [self.navigationController pushViewController:reason animated:YES];
        }
        else if (actionSheet == self.modifyWithdraw){
            ghunterWithdrawReasonViewController *reason = [[ghunterWithdrawReasonViewController alloc] init];
            reason.tid = self.tid;
            reason.bounty = [info objectForKey:@"bounty"];
            reason.entranceType = @"modify";
            reason.dic = [task objectForKey:@"withdraw"];
            [_textView resignFirstResponder];
            [self.navigationController pushViewController:reason animated:YES];
        }
        else if (actionSheet == self.deleteComment) {
            NSDictionary *dic = [taskcommentArray objectAtIndex:(self.deleteComment.tag - 1)];
            [self didDeleteCommentIsloading:YES withID:[dic objectForKey:@"cid"]];
        }
//        else if(actionSheet == self.actionCancel)
//        {
//            self.biddingLabel.textColor = RGBCOLOR(234, 85, 20);
//            self.joinin.enabled = YES;
//            self.participateBidding.backgroundColor = [UIColor clearColor];
//            self.joinin.userInteractionEnabled=NO;
//            
//            [self didUnjoinTaskIsloading:YES];
//        }
        else if (actionSheet == self.joinskillShow){
            
            // 取消竞标
            [self didUnjoinTaskIsloading:YES];
        }
        else if(actionSheet == self.acceptPrivateTaskSheet){
            // 猎人接受任务
            [self startLoad];
            //刷新或获取任务评论
            NSString *string = [NSString stringWithFormat:@"?tid=%@&a [self startLoad];ccept=1", self.tid];
            [ghunterRequester getwithDelegate:self withUrl:URL_FOR_DEAl_PRIVAE_TASK withUserInfo:REQUEST_FOR_DEAL_PRIVAE_TASK withString:string];
        }
        else if(actionSheet == self.refusePrivateTaskSheet){
            // 猎人拒绝任务
            [self startLoad];
            NSString *string = [NSString stringWithFormat:@"?tid=%@&accept=0", self.tid];
            [ghunterRequester getwithDelegate:self withUrl:URL_FOR_DEAl_PRIVAE_TASK withUserInfo:REQUEST_FOR_DEAL_PRIVAE_TASK withString:string];
        }else if(actionSheet == saveAction){
            // 确定保存大图
            NSInteger row = [actionSheet tag];
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell *cell = [taskTable cellForRowAtIndexPath:path];
            UIView *taskBg = (UIView *)[cell viewWithTag:16];
            UIImageView *photoImageView = (UIImageView *)[taskBg viewWithTag:row];
            // UIImageWriteToSavedPhotosAlbum(photoImageView.image, nil, nil, nil);
            UIImageWriteToSavedPhotosAlbum(photoImageView.image, self,
                                           @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else if (buttonIndex == 1){
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

// 写到文件的完成时执行
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if ( error ) {
        [ProgressHUD show:@"保存失败"];
        [saveAction endEditing:YES];
    }else{
        [ProgressHUD show:@"已保存到相册"];
        [saveAction endEditing:YES];
    }
}

#pragma mark - 删除评论
-(void)didDeleteCommentIsloading:(BOOL)isloading withID:(NSString *)cid{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?cid=%@", URL_DELETE_COMMENT, cid] params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        [ProgressHUD show:[result objectForKey:@"msg"]];
        
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            // 删除评论
            [self didGetTaskDetailIsloading:NO isWithCommets:YES];
        }else{
            
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}

#pragma mark - addressbook
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - custom method
- (void) addSubImgView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    for (NSUInteger i = 0; i < [imgArray count]; i++)
    {
        if (i == currentIndex)
        {
            continue;
        }
        UIImageView *tmpView = (UIImageView *)[self.view viewWithTag:(100 + i)];
        
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i * myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
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
    [self.view bringSubviewToFront:scrollPanel];
    [UIView animateWithDuration:0.5 animations:^{
        scrollPanel.alpha = 1.0;
    }];
    UIImageView *tmpView = sender;
    currentIndex = (tmpView.tag - 100);
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex*mainScreenWidth;
    myScrollView.contentOffset = contentOffset;
//    myScrollView.frame = CGRectMake(0, 0, mainScreenWidth, mainScreenheight);
    //添加
    [self addSubImgView];
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}

#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

-(void)selectedFacialView:(NSString*)str
{
    NSString *path=[[NSBundle mainBundle]pathForResource:@"face.plist" ofType:nil];
    NSDictionary *dic=[[NSDictionary alloc]initWithContentsOfFile:path];
    NSArray* allKeys=[dic allKeys];
    NSString* imageStr;
    for(NSString* key in allKeys)
    {
        if([str isEqualToString:[dic objectForKey:key]])
        {
            imageStr=[NSString stringWithFormat:@"%@",key];
        }
    }
    if(imageStr==nil)
    {
        _textView.text=_textView.text;
    }
    else
    {
        _textView.text=[_textView.text stringByAppendingString:imageStr];
    }
}

-(void)didSendComment:(NSMutableDictionary *)dic isloading:(BOOL)isloading{
    // 这条评论，加载本地的数组里面，然后reload tableview
    NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] init];
    if (skdic.count == 0) {
        [commentDic setObject:[dic objectForKey:@"content"] forKey:@"content"];
    }else {
        [commentDic setObject:[skdic objectForKey:@"content"] forKey:@"content"];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [commentDic setObject:[formatter stringFromDate:[NSDate date]] forKey:@"dateline"];
    [commentDic setObject:[ghunterRequester getUserInfo:@"username"] forKey:@"username"];
    [commentDic setObject:[ghunterRequester getUserInfo:@"tiny_avatar"] forKey:@"tiny_avatar"];
    [commentDic setObject:[ghunterRequester getUserInfo:@"uid"] forKey:@"uid"];
    
    // 如果有图片，应该把图片加载在这条评论下面
    if ( [dataimgarr count] > 0 ) {
        NSArray *picArr = [dataimgarr copy];
        [commentDic setObject:picArr forKey:@"cmt_added_pics"];
    }
    
    [taskcommentArray insertObject:commentDic atIndex:0];
    [taskTable reloadData];
    // 滚动到最新评论的一行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [taskTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    // 添加验证参数
    [dic setObject:API_TOKEN_NUM forKey:API_TOKEN];
    [AFNetworkTool uploadImage:dataimgarr forKey:@"images[]" andParameters:dic toApiUrl:URL_COMMENT_TASK success:^(NSData *data) {
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [ProgressHUD show:[result objectForKey:@"msg"]];
        
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            [commentDic setObject:[result objectForKey:@"cid"] forKey:@"cid"];
            
            self.textView.text = @"";
            self.reply_uid = @"";
            self.reply_cid = @"";
            textViewTip.text = @"";
            replyStr = @"";
            
            if ( [dataimgarr count] > 0 ) {
                [dataimgarr removeAllObjects];
            }
        }else{
            
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
    }];
}

-(void)skillBtn:(UIButton*)sender
{
    NSDictionary* skillInfo=[task objectForKey:@"skillshow"];
    ghunterSkillViewController* skillView=[[ghunterSkillViewController alloc] init];
    skillView.skillid=[skillInfo objectForKey:@"showid"];
    [skillView setCallBackBlock:^{}];
    [_textView resignFirstResponder];
    [self.navigationController pushViewController:skillView animated:YES];
}
-(void)skillTaped
{
    ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
    
    NSDictionary* skillInfo=[task objectForKey:@"skillshow"];
    userCenter.uid=[skillInfo objectForKey:@"owner_uid"];
    [_textView resignFirstResponder];
    [self.navigationController pushViewController:userCenter animated:YES];
}

// 发布表情评论，选择某个表情
-(void)selected:(UIButton*)btn
{
    NSMutableString *str = [[NSMutableString alloc] init];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"face.plist" ofType:nil];
    NSDictionary *dic=[[NSDictionary alloc]initWithContentsOfFile:path];
    NSArray* allKeys=[dic allKeys];
    NSString* imageStr;
    str = [NSMutableString stringWithFormat:@"emoji_%zd.png",btn.tag];
    if(btn.tag==21||btn.tag==42||btn.tag==63)
    {
        if(_textView.text.length>0)
        {
            NSMutableString* oldStr1=[[NSMutableString alloc] initWithString:_textView.text];
            NSArray* strArr1=[oldStr1 componentsSeparatedByString:@"["];
            NSMutableArray* strArr2=[[NSMutableArray alloc] init];
            for(NSString* str in strArr1)
            {
                NSArray* arr=[str componentsSeparatedByString:@"]"];
                [strArr2 addObjectsFromArray:arr];
                for(NSString* str1 in strArr2)
                {
                    if(str1==nil||[str1 isEqual:@""])
                    {
                        [strArr2 removeObject:str1];
                    }
                }
            }
            NSString* appendStr=[NSString stringWithFormat:@"[%@]",[strArr2 lastObject]];
            NSInteger keySum=0;
            for(NSString* key in allKeys)
            {
                if([appendStr isEqualToString:key])
                {
                    keySum++;
                }
            }
            if(keySum!=0&&[_textView.text hasSuffix:@"]"])
            {
                NSString* newString=[_textView.text substringWithRange:NSMakeRange(0, _textView.text.length-appendStr.length)];
                _textView.text=newString;
            }
            else
            {
                NSString * newString = [_textView.text substringWithRange:NSMakeRange(0, [_textView.text length] - 1)];
                _textView.text=newString;
            }
        }

    }
    for(NSString* key in allKeys)
    {
        if([str isEqualToString:[dic objectForKey:key]])
        {
            imageStr=[NSString stringWithFormat:@"%@",key];
        }
    }
    if(imageStr==nil)
    {
        _textView.text=_textView.text;
    }
    else
    {
        _textView.text=[_textView.text stringByAppendingString:imageStr];
    }
    
}

// 猎人接受私密任务
- (IBAction)hunterAcceptBuySkill:(id)sender {
    self.acceptPrivateTaskSheet = [[UIActionSheet alloc] initWithTitle:@"确定接受此任务吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [self.acceptPrivateTaskSheet showInView:self.view];
}

// 猎人拒绝私密任务
- (IBAction)hunterRefuseBuySkill:(id)sender {
    self.refusePrivateTaskSheet = [[UIActionSheet alloc] initWithTitle:@"确定拒绝此任务吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [self.refusePrivateTaskSheet showInView:self.view];
}

-(void)updatePage{
    [self refreshTable];
}

// 修改定向发布的任务
- (IBAction)ownerModifyOrientTask:(id)sender {
    // 传参，修改后返回任务详情页，并刷新页面
    ghunterSkillReleaseViewController *skillRelease = [[ghunterSkillReleaseViewController alloc] init];
    skillRelease.task = [task objectForKey:@"info"];
    skillRelease.skillDic = [task objectForKey:@"skillshow"];
    [_textView resignFirstResponder];
    [self.navigationController pushViewController:skillRelease animated:YES];
}

// 被拒绝的任务，申请退款
- (IBAction)refusedTaskWithdrawPay:(id)sender {
    self.actionBack = [[UIActionSheet alloc] initWithTitle:@"申请退款将被惩罚降低能力值,可能会影响您的等级和体力值，任务也将失效，是否继续退款？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [self.actionBack showInView:self.view];
}

#pragma mark --- 根据竞标状态,设置按钮样式 ---
// 根据竞标状态，设置我要竞标的按钮样式
-(void)setBidButtonStatus:(NSString *)is_join{
    if ([is_join isEqualToString:@"1"]) {
       /*
        self.biddingLabel.hidden = NO;
        
        CGRect biddingFrane = self.biddingLabel.frame;
        biddingFrane.origin.x = mainScreenWidth / 2 - 18;
        self.biddingLabel.frame = biddingFrane;
        
        [self.biddingLabel setText:@"取消竞标"];
        self.biddingLabel.textColor = RGBCOLOR(234, 85, 20);
        self.participateBidding.backgroundColor = [UIColor clearColor];
        [self.participateBiddingAvatar setImage:[UIImage imageNamed:@"取消竞标"]];
        */
        
        CGRect biddingFrane = self.biddingLabel.frame;
        biddingFrane.origin.x = self.participateBiddingAvatar.frame.origin.x + 30;
        self.biddingLabel.frame = biddingFrane;
        
        [self.biddingLabel setText:@"任务秀"];
        self.biddingLabel.textColor = [UIColor whiteColor];
        self.participateBidding.backgroundColor = RGBCOLOR(250, 80, 18);
        [self.participateBiddingAvatar setImage:[UIImage imageNamed:@"任务秀"]];
    }else if([is_join isEqualToString:@"2"]){
//        CGRect biddingLabelFrame = self.biddingLabel.frame;
//        
//        biddingLabelFrame.origin.x = mainScreenWidth / 2 - 20;
//        
//        self.biddingLabel.frame = biddingLabelFrame;
//        self.biddingLabel.font = [UIFont systemFontOfSize:14];
//        self.biddingLabel.text = @"已取消";
//        self.biddingLabel.textColor = RGBCOLOR(234, 85, 20);
//        self.joinin.enabled = YES;
//        self.participateBidding.backgroundColor = [UIColor clearColor];
//        // 取消竞标不能再参与竞标
//        self.joinin.userInteractionEnabled=NO;
//        self.participateBiddingAvatar.hidden = YES;
    }else{
//        self.biddingLabel.hidden = NO;
//        [self.biddingLabel setText:@"参与竞标"];
//        CGRect frame = self.biddingLabel.frame;
//        frame.origin.x = self.participateBidding.frame.size.width / 2 + 10;
//        self.biddingLabel.frame =  frame;
        
//        self.joinin.userInteractionEnabled = YES;
//        [self.participateBidding setBackgroundColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0f]];
//        [self.participateBiddingAvatar setImage:[UIImage imageNamed:@"立即竞标"]];
    }
}


#pragma mark --- 收藏 ---
// 收藏功能
- (IBAction)collectBtn:(id)sender {
    if (!imgondar_islogin) {
        [ProgressHUD show:UNLOGIN_ERROR];
        return;
    }
    NSString* str=[NSString stringWithFormat:@"?type=0&oid=%@",self.tid];
    if(collected)
    {
        [ghunterRequester getwithDelegate:self withUrl:URL_DELETE_COLLECTION withUserInfo:REQUEST_FOR_NEW_DELETE_COLLECTION withString:str];
    }
    else
    {
        [ghunterRequester getwithDelegate:self withUrl:URL_ADD_COLLECTION withUserInfo:REQUEST_FOR_NEW_ADD_COLLECTION withString:str];
    }
    
}

#pragma mark ---私信---
- (void)privateMessage:(UIButton *)sender {
    
    if (!imgondar_islogin) {
        
        [self click2Login];
        return;
    }
    NSDictionary * ownerInfo = [task objectForKey:@"owner"];
    
    ghunterChatViewController *chat = [[ghunterChatViewController alloc] init];
    chat.sender_uid = [ownerInfo objectForKey:@"uid"];
    chat.sender_username = [ownerInfo objectForKey:@"username"];
    
    [chat setCallBackBlock:^{}];
    [self.navigationController pushViewController:chat animated:YES];
}

#pragma mark ---点击文本中的链接响应时间---- littlebear  2015-12-10
-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo{
    // [linkInfo URL];
    if ( [linkInfo URL] ) {
        ghunterWebViewController *webView = [[ghunterWebViewController alloc] init];
        webView.webTitle = [NSMutableString stringWithString:APP_NAME];
        webView.urlPassed = [NSMutableString stringWithString:[[linkInfo URL] absoluteString]];
        [self.navigationController pushViewController:webView animated:YES];
        return  NO;
    }
    return YES;
}

#pragma mark --- 未登录跳转
// 未登录，需要点击去登陆
-(void)click2Login{
    ghunterLoginViewController *login = [[ghunterLoginViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
    [login setCallBackBlock:^{
        
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
    }];
}

// 评论发送表情
- (IBAction)faceBtn:(UIButton *)sender {
    _isSender = !_isSender;
    
    // 隐藏添加图片的弹框
    _addImgView.hidden = YES;
    _isSendimg = NO;
    if(_isSender)
    {
        [self.textView resignFirstResponder];  // 撤销第一响应者
        _faceView.hidden = NO;
        CGRect r = toolBar.frame;
        r.origin.y = mainScreenheight-170-r.size.height;
        toolBar.frame = r;
        [_faceView setFrame:CGRectMake(0, mainScreenheight-170,mainScreenWidth, 170)];
        return;
    }
    else
    {
        _faceView.hidden = YES;
        [self.textView becomeFirstResponder];
    }
}

// 评论添加图片
- (IBAction)cmtAddImg:(UIButton *)sender {
    _isSendimg = !_isSendimg;
    _faceView.hidden = YES;
    _isSender = NO;
    
    if( _isSendimg )
    {
        [self.textView resignFirstResponder];
        _addImgView.hidden = NO;
        CGRect r = toolBar.frame;
        r.origin.y = mainScreenheight - 170 - r.size.height;
        toolBar.frame = r;
        [_addImgView setFrame:CGRectMake(0, mainScreenheight-170,mainScreenWidth, 170)];
        return;
    }
    else
    {
        _addImgView.hidden = YES;
        [self.textView becomeFirstResponder];
    }
}

// 发送私信，表情下面的那一栏
-(void)sendBtnClick:(UIButton*)sender
{
    // 发送评论
    [skdic setObject:@"2" forKey:@"type"];
    [skdic setObject:self.tid forKey:@"oid"];
    // 如果是回复某个猎人的评论
    if ( [self.reply_uid length] > 0 ) {
        [skdic setObject:self.reply_uid forKey:@"reply_uid"];
        [skdic setObject:[NSString stringWithFormat:@"%@%@", replyStr, self.textView.text] forKey:@"content"];
    }else{
        [skdic setObject:[self.textView text] forKey:@"content"];
    }
    if ( [self.reply_cid length] > 0 ) {
        [skdic setObject:self.reply_cid forKey:@"reply_cid"];
    }
    [self didSendComment:skdic isloading:YES];
}

// 从相册选择
-(void)getChatImgFromAlbum{
    if ( [dataimgarr count] >= 4 ) {
        [ProgressHUD show:@"最多只能添加4张照片"];
        return;
    }
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 4 - [dataimgarr count];
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
}

// 拍照上传
-(void)getChatImgFromCamera{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setAllowsEditing:YES];
    [imgPicker setDelegate:self];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}

// 使键盘下降的按钮
- (IBAction)down_keyboard:(id)sender {
    CGRect frame = toolBar.frame;
    frame.origin.y = mainScreenheight - toolBar.frame.size.height;
    toolBar.frame = frame;
    
    _faceView.hidden=YES;
    _addImgView.hidden = YES;
    [self.textView resignFirstResponder];
    
    [toolBar removeFromSuperview];
    [addedImageLayout removeFromSuperview];
}

#pragma mark - HPGrowingTextView delegate
// 按下键盘的完成按钮，发送评论
- (BOOL)growingTextView:(HPGrowingTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length != 0) {
        textViewTip.text = @"";
    }else {
        textViewTip.text = tmpString;
    }
    
    if (textView == self.reportText) {
        if (text!=nil) {
            self.textTip.hidden = YES;
        }else{
            self.textTip.hidden = NO;
        }
    }else{
        // 评论输入框
        if (text!=nil) {
            textViewTip.hidden = YES;
        }else{
            textViewTip.hidden = NO;
        }
    }
    
    if (textView == self.textView && [text isEqualToString:@"\n"]) {
        if( [self.textView.text length] == 0 )
        {
            [ProgressHUD show:@"评论内容不能为空"];
            return NO;
        }
        [textView resignFirstResponder];
        [self sendBtnClick:nil];
        return NO;
    }
    return YES;
}

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)textView
{
    return YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)heightR
{
    float diff = (growingTextView.frame.size.height - heightR);
    
    CGRect r = toolBar.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    toolBar.frame = r;
    
    // chatTool
    CGRect frame = textViewTip.frame;
    frame.size.height = r.size.height - 10;
    textViewTip.frame = frame;
    
    CGRect imgFrame = self.backImage.frame;
    imgFrame.size.height = frame.size.height;
    self.backImage.frame = imgFrame;
    
    self.faceBtn.frame = CGRectMake(6, toolBar.frame.size.height - self.faceBtn.frame.size.height - 5, 26, 26);
    self.addBtn.frame = CGRectMake(38, toolBar.frame.size.height - self.addBtn.frame.size.height - 5, 26, 26);
    self.downBtn.frame = CGRectMake(274, toolBar.frame.size.height - self.downBtn.frame.size.height, 45, 40);
}

#pragma mark - ZYQAssetPickerController Delegate
// 从相册选择返回
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (NSUInteger i = 0; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        [dataimgarr addObject:tempImg];
        // 开始处理图片显示
        [self addImage2Show:tempImg];
    }
    
    if ( [dataimgarr count] > 0 ) {
        addedImageLayout.hidden = NO;
    }else{
        addedImageLayout.hidden = YES;
    }
}

#pragma mark - UIImagePickerDelegate
// 拍照成功获得相片的回调 UIImagePickerController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *cameraImg = [info objectForKey:UIImagePickerControllerEditedImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(cameraImg, nil, nil, nil);
        [dataimgarr addObject:cameraImg];
        // 开始处理图片显示
        [self addImage2Show:cameraImg];
        
        if ( [dataimgarr count] > 0 ) {
            addedImageLayout.hidden = NO;
        }else{
            addedImageLayout.hidden = YES;
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
}

-(void)addImage2Show:(UIImage *)img{
    // 开始处理图片显示
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + 15 * (dataimgarr.count - 1) + ([dataimgarr count]-1)* 30, 12, 30, 30)];
    
    imgView.tag = dataimgarr.count + 1;
    [imgView setImage:img];
    imgView.userInteractionEnabled = YES;
    addedImageLayout.userInteractionEnabled = YES;
    [addedImageLayout addSubview:imgView];
    
    // 为了防止事件不穿透
    UIView * deleteView = [[UIView alloc] initWithFrame:CGRectMake(imgView.frame.size.width - 30, - 30, 60, 60)];
    UIButton * deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 55, 55)];
    [deleteBtn setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    deleteBtn.tag = dataimgarr.count + 1;
    deleteBtn.layer.cornerRadius = deleteBtn.frame.size.width / 2;
    deleteBtn.clipsToBounds = YES;
    
    deleteView.userInteractionEnabled = YES;
    deleteView.layer.cornerRadius = deleteView.frame.size.width / 2;
    deleteView.clipsToBounds = YES;
    [deleteBtn addTarget:self action:@selector(deleteImg:) forControlEvents:UIControlEventTouchUpInside];
    
    [imgView addSubview:deleteView];
    [deleteView addSubview:deleteBtn];
}

// 删除图片
- (void)deleteImg:(UIButton *) btn {
    NSUInteger tag = btn.tag;
    
    UIImageView *deleteImgView = (UIImageView *)[addedImageLayout viewWithTag:tag];
    [dataimgarr removeObjectAtIndex:tag - 2];
    
    [deleteImgView removeFromSuperview];
    
    for (NSUInteger i = tag + 1; i < 6; i++) {
        UIImageView *temp = (UIImageView *)[addedImageLayout viewWithTag:i];
        if (temp) {
            CGRect frame1 = temp.frame;
            frame1.origin.x = frame1.origin.x - 30 -15;
            temp.frame = frame1;
            temp.tag = i - 1;
            
            UIButton *deleteBtn = (UIButton *)[temp viewWithTag:i];
            deleteBtn.tag = i - 1;
        }
    }
    
    if (dataimgarr.count == 0) {
        addedImageLayout.hidden = YES;
    }else {
        addedImageLayout.hidden = NO;
    }
}

#pragma mark --- 跳转到分享统计页面
- (void) btnClicked:(UIButton *) button {
    
    NSDictionary * info = [task objectForKey:@"info"];
    
    ghunterShareCountViewController * shareCountVC = [[ghunterShareCountViewController alloc] init];
    shareCountVC.oidStr = [NSString stringWithFormat:@"%@", [info objectForKey:@"tid"]];
    [self.navigationController pushViewController:shareCountVC animated:YES];
}

#pragma mark --- 显示任务秀 ---
-(void)Evaluation:(UIButton *)btn{
    
    flagClick = YES;
    self.valuePage = 1;
    [self didGetTaskShow4TaskIsloading:NO WithTaskTid:self.tid andWithPages:taskPage];
    
    Monitor *monitor = [Monitor sharedInstance];
    monitor.Identify = @"PJ";
    
    [Coment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Evaluation setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    redlin1.backgroundColor = RGBCOLOR(229, 229, 229);
    redlin2.backgroundColor = RGBCOLOR(234, 85, 20);
    CGRect heightone = redlin1.frame;
    heightone.size.height = 0.5;
    redlin1.frame = heightone;
    CGRect heighttwo = redlin2.frame;
    heighttwo.size.height = 1.5;
    redlin2.frame = heighttwo;
}


#pragma mark --- 显示评论 ---
-(void)coment:(UIButton *)btn{
    
    flagClick = NO;
    self.currentPage = 1;
    [self didGetComments4TaskIsloading:NO page:page];
    
    Monitor *monitor = [Monitor sharedInstance];
    monitor.Identify = @"PL";
    
    [Coment setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [Evaluation setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    redlin1.backgroundColor = RGBCOLOR(234, 85, 20);
    
    redlin2.backgroundColor = RGBCOLOR(229, 229, 229);
    CGRect heightone = redlin1.frame;
    heightone.size.height = 1.5;
    redlin1.frame = heightone;
    CGRect heighttwo = redlin2.frame;
    heighttwo.size.height = 0.5;
    redlin2.frame = heighttwo;
}

#pragma mark --- 查看竞标人数 ---
- (void)clickMoreBid:(UIButton *) btn {
    
    NSLog(@"123");
}

#pragma mark --- 任务秀操作 --- 

- (void) cellBtn:(UIButton *) btn {
    
    cellShow = (PullTableView *)[btn superview];
    self.choseView = (UIView *)[cellShow viewWithTag:100];
    CGRect frame =  self.choseView.frame;
    frame.origin.x = mainScreenWidth - frame.size.width-40;
    frame.origin.y = btn.center.y - 5;
    self.choseView.frame = frame;
    
    if (btn.selected == YES) {
        btn.selected = NO;
        self.choseView.alpha = 0;
    }else {
        btn.selected = YES;
        self.choseView.alpha = 1.0;
        
        UIButton * joinBtn = (UIButton *)[self.choseView viewWithTag:101];
        UIButton * rewardBtn = (UIButton *)[self.choseView viewWithTag:102];
        UIButton * rejectBtn = (UIButton *)[self.choseView viewWithTag:103];
        
        // 中意
        joinBtn.tag = btn.tag;
        [joinBtn addTarget:self action:@selector(join:) forControlEvents:UIControlEventTouchUpInside];
        // 打赏
        rewardBtn.tag = btn.tag;
        [rewardBtn addTarget:self action:@selector(reward:) forControlEvents:UIControlEventTouchUpInside];
        // 驳回
        rejectBtn.tag = btn.tag;
        [rejectBtn addTarget:self action:@selector(reject:) forControlEvents:UIControlEventTouchUpInside];
    }
}


// 中意
- (void)join:(UIButton *)btn1 {
    
    UIView * view = (UIView *)[btn1 superview];
    view.alpha = 0.0f;
    
    self.actionJoin = [[UIActionSheet alloc] initWithTitle:@"选取猎人后,系统将通过短信和推送即时告知双方的联系方式,确定选择猎人?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    self.actionJoin.tag = btn1.tag;
    [self.actionJoin showInView:self.view];
}
#pragma mark --- 头像来自任务秀打赏 ---
- (void)iconreward:(NSInteger)btn2 {
    
    [self didGetGoldNumDataIsloading:NO];
    
    rewardView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"rewardView" owner:self options:nil];
    rewardFilter = [[UIView alloc] init];
    rewardFilter.backgroundColor = [UIColor yellowColor];
    rewardFilter = [nibs objectAtIndex:0];
    NSInteger B = btn2;
    // 来自任务秀的调用
    [self iconcreateRewardView:btn2];
    is4Show = YES;
    is4Comment = NO;
    CGRect rewardFilterFrame = rewardFilter.frame;
    rewardFilterFrame.size.width = mainScreenWidth;
    rewardFilter.frame = rewardFilterFrame;
    
    rewardView.containerFrame = CGRectMake((mainScreenWidth - rewardFilterFrame.size.width) / 2.0, (mainScreenheight - rewardFilterFrame.size.height), rewardFilterFrame.size.width, rewardFilterFrame.size.height);
    rewardView.showView = rewardFilter;
    rewardView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    [rewardView show];
}
#pragma mark --- 评论打赏来自任务秀打赏 ---
- (void)longreward:(NSInteger)btn2 {
    
    rewardView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"rewardView" owner:self options:nil];
    rewardFilter = [[UIView alloc] init];
    rewardFilter.backgroundColor = [UIColor yellowColor];
    rewardFilter = [nibs objectAtIndex:0];
    // 来自任务秀的调用
    [self LongcreateRewardView:btn2];
    is4Show = NO;
    is4Comment = YES;
    CGRect rewardFilterFrame = rewardFilter.frame;
    rewardFilterFrame.size.width = mainScreenWidth;
    rewardFilter.frame = rewardFilterFrame;
    
    rewardView.containerFrame = CGRectMake((mainScreenWidth - rewardFilterFrame.size.width) / 2.0, (mainScreenheight - rewardFilterFrame.size.height), rewardFilterFrame.size.width, rewardFilterFrame.size.height);
    rewardView.showView = rewardFilter;
    rewardView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    [rewardView show];
}
#pragma mark --- 来自任务秀打赏 ---
- (void)reward:(UIButton *)btn2 {

    [self didGetGoldNumDataIsloading:NO];

    UIView * view = (UIView *)[btn2 superview];
    view.alpha = 0.0f;
    rewardView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"rewardView" owner:self options:nil];
    rewardFilter = [[UIView alloc] init];
    rewardFilter.backgroundColor = [UIColor yellowColor];
    rewardFilter = [nibs objectAtIndex:0];
    
    // 来自任务秀的调用
    [self createRewardView:btn2];
    is4Show = YES;
    is4Comment = NO;
    UILabel * bountyLb = (UILabel *)[cellShow viewWithTag:btn2.tag + 60];
    if (bountyLb.text.doubleValue > 0) {
        
        NSLog(@"123");
    }
    
    CGRect rewardFilterFrame = rewardFilter.frame;
    rewardFilterFrame.size.width = mainScreenWidth;
    rewardFilter.frame = rewardFilterFrame;
    
    rewardView.containerFrame = CGRectMake((mainScreenWidth - rewardFilterFrame.size.width) / 2.0, (mainScreenheight - rewardFilterFrame.size.height), rewardFilterFrame.size.width, rewardFilterFrame.size.height);
    rewardView.showView = rewardFilter;
    rewardView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    [rewardView show];
}
#pragma mark --- 头像打赏界面 ---
-(void) iconcreateRewardView:(NSInteger) sender {
    NSInteger C = sender;
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, rewardFilter.frame.size.height)];
    btn.backgroundColor = [UIColor whiteColor];
    [rewardFilter addSubview:btn];
    
    self.rewardBountyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (mainScreenWidth - 2) / 3, 44)];
    self.rewardBountyBtn.selected = YES;
    [self.rewardBountyBtn setTitle:@"打赏赏金" forState:UIControlStateNormal];
    [self.rewardBountyBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    self.rewardBountyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rewardBountyBtn addTarget:self action:@selector(bountyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rewardCoinFeeBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3 + 1, 0, (mainScreenWidth - 2) / 3, 44)];
    self.rewardCouponBtn.selected = NO;
    [self.rewardCoinFeeBtn setTitle:@"打赏金币" forState:UIControlStateNormal];
    [self.rewardCoinFeeBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
    self.rewardCoinFeeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.rewardCoinFeeBtn.tag = sender;
    [self.rewardCoinFeeBtn addTarget:self action:@selector(iconcoinFeeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rewardCouponBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3 * 2, 0, (mainScreenWidth - 2) / 3, 44)];
    self.rewardCouponBtn.selected = NO;
    [self.rewardCouponBtn setTitle:@"打赏优惠券" forState:UIControlStateNormal];
    [self.rewardCouponBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
    self.rewardCouponBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.rewardCouponBtn.tag = sender;
    [self.rewardCouponBtn addTarget:self action:@selector(iconcouponBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 标识线
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, self.rewardBountyBtn.frame.size.height, (mainScreenWidth - 2) / 3, 1.5)];
    self.redView.backgroundColor = RGBCOLOR(234, 85, 20);
    
    //
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.redView.frame.origin.y + 1.5, mainScreenWidth, 0.5)];
    view.backgroundColor = RGBCOLOR(235, 235, 235);
    [rewardFilter addSubview:view];
    
    // 头像
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(100, 64, 120, 50)];
    backView.center = CGPointMake(mainScreenWidth / 2, 79);
    backView.backgroundColor = [UIColor clearColor];
    [rewardFilter addSubview:backView];
    
    self.ownerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.ownerIcon.clipsToBounds = YES;
    self.ownerIcon.layer.cornerRadius = self.ownerIcon.frame.size.width / 2;
    NSMutableDictionary * owner = [[NSMutableDictionary alloc] init];
    owner = [task objectForKey:@"owner"];
    [self.ownerIcon sd_setImageWithURL:[owner objectForKey:TINY_AVATAR] placeholderImage:[UIImage imageNamed:@"avatar"]];
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(50, 20, 20, 7)];
    [backView addSubview:img];
    img.image = [UIImage imageNamed:@"打赏箭头"];
    img.center = CGPointMake(backView.frame.size.width / 2, backView.frame.size.height / 2);
    
    self.hunterIcon = [[UIImageView alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    self.hunterIcon.clipsToBounds = YES;
    self.hunterIcon.layer.cornerRadius = self.hunterIcon.frame.size.width / 2;
    NSMutableDictionary * youDic = [[NSMutableDictionary alloc] init];
    youDic = [taskcommentArray objectAtIndex:sender - 1];
    [self.hunterIcon sd_setImageWithURL:[youDic objectForKey:TINY_AVATAR] placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    // 名字
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, backView.frame.origin.y + backView.frame.size.height + 10, mainScreenWidth, 20)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = RGBCOLOR(137, 137, 137);
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    NSString * nameSelf = [youDic objectForKey:@"username"];
    NSString * nameString = [NSString stringWithFormat:@"打赏给：%@ 的小费", nameSelf];
    self.nameLabel.text = nameString;
    
    // 描述
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.nameLabel.frame.size.height + self.nameLabel.frame.origin.y, mainScreenWidth - 100, 20)];
    self.descLabel.font = [UIFont systemFontOfSize:12];
    self.descLabel.textColor = RGBCOLOR(153, 153, 153);
    
    // 充值
    self.gotoRechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenWidth - 50, self.nameLabel.frame.origin.y, 50, 30)];
    self.gotoRechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.gotoRechargeBtn setTitle:@"充值>" forState:UIControlStateNormal];
    [self.gotoRechargeBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    [self.gotoRechargeBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0, 0, 0)];
    [self.gotoRechargeBtn addTarget:self action:@selector(gotoRecharge:) forControlEvents:UIControlEventTouchUpInside];
    
    // 输入框
    self.bountyTF = [[UITextField alloc] initWithFrame:CGRectMake(10, self.descLabel.frame.origin.y + self.descLabel.frame.size.height + 8, mainScreenWidth - 20, 30)];
        [self.bountyTF setEnabled:YES];
        self.bountyTF.placeholder = @"小费金额不多于任务赏金";
    self.bountyTF.keyboardType = UIKeyboardTypeNumberPad;
    self.bountyTF.textAlignment = NSTextAlignmentCenter;
    self.bountyTF.backgroundColor = RGBCOLOR(235, 235, 235);
    self.bountyTF.tag = 19;
    
    // 提示
    self.informLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bountyTF.frame.size.height + self.bountyTF.frame.origin.y + 5, mainScreenWidth, 20)];
    self.informLabel.text = @"温馨提示:打赏金额单位“元”";
    self.informLabel.font = [UIFont systemFontOfSize:13];
    self.informLabel.textColor = RGBCOLOR(137, 137, 137);
    self.informLabel.textAlignment = NSTextAlignmentCenter;
    
    //
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.informLabel.frame.size.height + self.informLabel.frame.origin.y + 5, mainScreenWidth, 0.5)];
    view2.backgroundColor = RGBCOLOR(235, 235, 235);
    [rewardFilter addSubview:view2];
    
    // 确定取消
    self.cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, view2.frame.origin.y + 0.5, (mainScreenWidth - 1) / 2, 44)];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    [self.cancleBtn addTarget:self action:@selector(missAlert:) forControlEvents:UIControlEventTouchUpInside];
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake((mainScreenWidth - 1) / 2 - 0.5, view2.frame.origin.y + 10, 1, 20)];
    view3.backgroundColor = RGBCOLOR(235, 235, 235);
    [rewardFilter addSubview:view3];
    self.determineBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 1) / 2 + 0.5, view2.frame.origin.y + 0.5, (mainScreenWidth - 1) / 2, 44)];
    [self.determineBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.determineBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    [self.determineBtn addTarget:self action:@selector(okAlert:) forControlEvents:UIControlEventTouchUpInside];
    self.determineBtn.tag = sender;
    
    
    [rewardFilter addSubview:self.rewardBountyBtn];
    [rewardFilter addSubview:self.leftBtn];
    [rewardFilter addSubview:self.rewardCoinFeeBtn];
    [rewardFilter addSubview:self.rightBtn];
    [rewardFilter addSubview:self.rewardCouponBtn];
    [rewardFilter addSubview:self.redView];
    [backView addSubview:self.ownerIcon];
    [backView addSubview:self.hunterIcon];
    [rewardFilter addSubview:self.nameLabel];
    [rewardFilter addSubview:self.descLabel];
    [rewardFilter addSubview:self.gotoRechargeBtn];
    [rewardFilter addSubview:self.bountyTF];
    [rewardFilter addSubview:self.informLabel];
    [rewardFilter addSubview:self.cancleBtn];
    [rewardFilter addSubview:self.determineBtn];
}
#pragma mark --- 评论长按打赏界面 ---
-(void) LongcreateRewardView:(NSInteger) sender {
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, rewardFilter.frame.size.height)];
    btn.backgroundColor = [UIColor whiteColor];
    [rewardFilter addSubview:btn];
    
    self.rewardBountyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (mainScreenWidth - 2) / 3, 44)];
    self.rewardBountyBtn.selected = YES;
    [self.rewardBountyBtn setTitle:@"打赏赏金" forState:UIControlStateNormal];
    [self.rewardBountyBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    self.rewardBountyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rewardBountyBtn addTarget:self action:@selector(bountyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rewardCoinFeeBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3 + 1, 0, (mainScreenWidth - 2) / 3, 44)];
    self.rewardCouponBtn.selected = NO;
    [self.rewardCoinFeeBtn setTitle:@"打赏金币" forState:UIControlStateNormal];
    [self.rewardCoinFeeBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
    self.rewardCoinFeeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.rewardCoinFeeBtn.tag = sender;
    [self.rewardCoinFeeBtn addTarget:self action:@selector(LongcoinFeeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rewardCouponBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3 * 2, 0, (mainScreenWidth - 2) / 3, 44)];
    self.rewardCouponBtn.selected = NO;
    [self.rewardCouponBtn setTitle:@"打赏优惠券" forState:UIControlStateNormal];
    [self.rewardCouponBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
    self.rewardCouponBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.rewardCouponBtn.tag = sender;
    [self.rewardCouponBtn addTarget:self action:@selector(longcouponBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 标识线
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, self.rewardBountyBtn.frame.size.height, (mainScreenWidth - 2) / 3, 1.5)];
    self.redView.backgroundColor = RGBCOLOR(234, 85, 20);
    
    //
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.redView.frame.origin.y + 1.5, mainScreenWidth, 0.5)];
    view.backgroundColor = RGBCOLOR(235, 235, 235);
    [rewardFilter addSubview:view];
    
    // 头像
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(100, 64, 120, 50)];
    backView.center = CGPointMake(mainScreenWidth / 2, 79);
    backView.backgroundColor = [UIColor clearColor];
    [rewardFilter addSubview:backView];
    
    self.ownerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.ownerIcon.clipsToBounds = YES;
    self.ownerIcon.layer.cornerRadius = self.ownerIcon.frame.size.width / 2;
    NSMutableDictionary * owner = [[NSMutableDictionary alloc] init];
    owner = [task objectForKey:@"owner"];
    [self.ownerIcon sd_setImageWithURL:[owner objectForKey:TINY_AVATAR] placeholderImage:[UIImage imageNamed:@"avatar"]];
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(50, 20, 20, 7)];
    [backView addSubview:img];
    img.image = [UIImage imageNamed:@"打赏箭头"];
    img.center = CGPointMake(backView.frame.size.width / 2, backView.frame.size.height / 2);
    
    self.hunterIcon = [[UIImageView alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    self.hunterIcon.clipsToBounds = YES;
    self.hunterIcon.layer.cornerRadius = self.hunterIcon.frame.size.width / 2;
    NSMutableDictionary * youDic = [[NSMutableDictionary alloc] init];
    youDic = [taskcommentArray objectAtIndex:sender - 1];
    [self.hunterIcon sd_setImageWithURL:[youDic objectForKey:TINY_AVATAR] placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    // 名字
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, backView.frame.origin.y + backView.frame.size.height + 10, mainScreenWidth, 20)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = RGBCOLOR(137, 137, 137);
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    NSString * nameSelf = [youDic objectForKey:@"username"];
    NSString * nameString = [NSString stringWithFormat:@"打赏给：%@ 的小费", nameSelf];
    self.nameLabel.text = nameString;
    
    // 描述
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.nameLabel.frame.size.height + self.nameLabel.frame.origin.y, mainScreenWidth - 100, 20)];
    self.descLabel.font = [UIFont systemFontOfSize:12];
    self.descLabel.textColor = RGBCOLOR(153, 153, 153);
    
    // 充值
    self.gotoRechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenWidth - 50, self.nameLabel.frame.origin.y, 50, 30)];
    self.gotoRechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.gotoRechargeBtn setTitle:@"充值>" forState:UIControlStateNormal];
    [self.gotoRechargeBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    [self.gotoRechargeBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0, 0, 0)];
    [self.gotoRechargeBtn addTarget:self action:@selector(gotoRecharge:) forControlEvents:UIControlEventTouchUpInside];
    
    // 输入框
    self.bountyTF = [[UITextField alloc] initWithFrame:CGRectMake(10, self.descLabel.frame.origin.y + self.descLabel.frame.size.height + 8, mainScreenWidth - 20, 30)];
    if ([_isfee.text isEqualToString:@"0"]||_isfee.text == nil) {
        [self.bountyTF setEnabled:YES];
        self.bountyTF.placeholder = @"小费金额不多于任务赏金";
        
    }else{
        [self.bountyTF setEnabled:NO];
        self.bountyTF.text = [NSString stringWithFormat:@"已打赏%@赏金",_isfee.text];
        self.bountyTF.textColor = RGBCOLOR(234, 85, 20);
        self.bountyTF.enabled = NO;
    }
    self.bountyTF.keyboardType = UIKeyboardTypeNumberPad;
    self.bountyTF.textAlignment = NSTextAlignmentCenter;
    self.bountyTF.backgroundColor = RGBCOLOR(235, 235, 235);
    self.bountyTF.tag = 19;
    
    // 提示
    self.informLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bountyTF.frame.size.height + self.bountyTF.frame.origin.y + 5, mainScreenWidth, 20)];
    self.informLabel.text = @"温馨提示:打赏金额单位“元”";
    self.informLabel.font = [UIFont systemFontOfSize:13];
    self.informLabel.textColor = RGBCOLOR(137, 137, 137);
    self.informLabel.textAlignment = NSTextAlignmentCenter;
    
    //
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.informLabel.frame.size.height + self.informLabel.frame.origin.y + 5, mainScreenWidth, 0.5)];
    view2.backgroundColor = RGBCOLOR(235, 235, 235);
    [rewardFilter addSubview:view2];
    
    // 确定取消
    self.cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, view2.frame.origin.y + 0.5, (mainScreenWidth - 1) / 2, 44)];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    [self.cancleBtn addTarget:self action:@selector(missAlert:) forControlEvents:UIControlEventTouchUpInside];
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake((mainScreenWidth - 1) / 2 - 0.5, view2.frame.origin.y + 10, 1, 20)];
    view3.backgroundColor = RGBCOLOR(235, 235, 235);
    [rewardFilter addSubview:view3];
    self.determineBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 1) / 2 + 0.5, view2.frame.origin.y + 0.5, (mainScreenWidth - 1) / 2, 44)];
    [self.determineBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.determineBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    [self.determineBtn addTarget:self action:@selector(okAlert:) forControlEvents:UIControlEventTouchUpInside];
    self.determineBtn.tag = sender;
    
    
    [rewardFilter addSubview:self.rewardBountyBtn];
    [rewardFilter addSubview:self.leftBtn];
    [rewardFilter addSubview:self.rewardCoinFeeBtn];
    [rewardFilter addSubview:self.rightBtn];
    [rewardFilter addSubview:self.rewardCouponBtn];
    [rewardFilter addSubview:self.redView];
    [backView addSubview:self.ownerIcon];
    [backView addSubview:self.hunterIcon];
    [rewardFilter addSubview:self.nameLabel];
    [rewardFilter addSubview:self.descLabel];
    [rewardFilter addSubview:self.gotoRechargeBtn];
    [rewardFilter addSubview:self.bountyTF];
    [rewardFilter addSubview:self.informLabel];
    [rewardFilter addSubview:self.cancleBtn];
    [rewardFilter addSubview:self.determineBtn];
}

#pragma mark --- 打赏界面 --- 
-(void) createRewardView:(UIButton *) sender {
    UILabel * feeLbel= (UILabel *)[self.view viewWithTag:sender.tag+1000];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, rewardFilter.frame.size.height)];
    btn.backgroundColor = [UIColor whiteColor];
    [rewardFilter addSubview:btn];
    
    self.rewardBountyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (mainScreenWidth - 2) / 3, 44)];
    self.rewardBountyBtn.selected = YES;
    [self.rewardBountyBtn setTitle:@"打赏赏金" forState:UIControlStateNormal];
    [self.rewardBountyBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    self.rewardBountyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rewardBountyBtn addTarget:self action:@selector(bountyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rewardCoinFeeBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3 + 1, 0, (mainScreenWidth - 2) / 3, 44)];
    self.rewardCouponBtn.selected = NO;
    [self.rewardCoinFeeBtn setTitle:@"打赏金币" forState:UIControlStateNormal];
    [self.rewardCoinFeeBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
    self.rewardCoinFeeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.rewardCoinFeeBtn.tag = sender.tag;
    [self.rewardCoinFeeBtn addTarget:self action:@selector(coinFeeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rewardCouponBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 2) / 3 * 2, 0, (mainScreenWidth - 2) / 3, 44)];
    self.rewardCouponBtn.selected = NO;
    [self.rewardCouponBtn setTitle:@"打赏优惠券" forState:UIControlStateNormal];
    [self.rewardCouponBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
    self.rewardCouponBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.rewardCouponBtn.tag = sender.tag;
    [self.rewardCouponBtn addTarget:self action:@selector(couponBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 标识线
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, self.rewardBountyBtn.frame.size.height, (mainScreenWidth - 2) / 3, 1.5)];
    self.redView.backgroundColor = RGBCOLOR(234, 85, 20);
    
    //
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.redView.frame.origin.y + 1.5, mainScreenWidth, 0.5)];
    view.backgroundColor = RGBCOLOR(235, 235, 235);
    [rewardFilter addSubview:view];
    
    // 头像
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(100, 64, 120, 50)];
    backView.center = CGPointMake(mainScreenWidth / 2, 79);
    backView.backgroundColor = [UIColor clearColor];
    [rewardFilter addSubview:backView];
    
    self.ownerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.ownerIcon.clipsToBounds = YES;
    self.ownerIcon.layer.cornerRadius = self.ownerIcon.frame.size.width / 2;
    NSMutableDictionary * owner = [[NSMutableDictionary alloc] init];
    owner = [task objectForKey:@"owner"];
    [self.ownerIcon sd_setImageWithURL:[owner objectForKey:TINY_AVATAR] placeholderImage:[UIImage imageNamed:@"avatar"]];
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(50, 20, 20, 7)];
    [backView addSubview:img];
    img.image = [UIImage imageNamed:@"打赏箭头"];
    img.center = CGPointMake(backView.frame.size.width / 2, backView.frame.size.height / 2);
    
    self.hunterIcon = [[UIImageView alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    self.hunterIcon.clipsToBounds = YES;
    self.hunterIcon.layer.cornerRadius = self.hunterIcon.frame.size.width / 2;
    NSMutableDictionary * youDic = [[NSMutableDictionary alloc] init];
    youDic = [taskShowArray objectAtIndex:sender.tag - 1];
    [self.hunterIcon sd_setImageWithURL:[youDic objectForKey:TINY_AVATAR] placeholderImage:[UIImage imageNamed:@"avatar"]];

    // 名字
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, backView.frame.origin.y + backView.frame.size.height + 10, mainScreenWidth, 20)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = RGBCOLOR(137, 137, 137);
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    NSString * nameSelf = [youDic objectForKey:@"username"];
    NSString * nameString = [NSString stringWithFormat:@"打赏给：%@ 的小费", nameSelf];
    self.nameLabel.text = nameString;
    
    // 描述
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.nameLabel.frame.size.height + self.nameLabel.frame.origin.y, mainScreenWidth - 100, 20)];
    self.descLabel.font = [UIFont systemFontOfSize:12];
    self.descLabel.textColor = RGBCOLOR(153, 153, 153);
    
    // 充值
    self.gotoRechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenWidth - 50, self.nameLabel.frame.origin.y, 50, 30)];
    self.gotoRechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.gotoRechargeBtn setTitle:@"充值>" forState:UIControlStateNormal];
    [self.gotoRechargeBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    [self.gotoRechargeBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0, 0, 0)];
    [self.gotoRechargeBtn addTarget:self action:@selector(gotoRecharge:) forControlEvents:UIControlEventTouchUpInside];
    
    // 输入框
    self.bountyTF = [[UITextField alloc] initWithFrame:CGRectMake(10, self.descLabel.frame.origin.y + self.descLabel.frame.size.height + 8, mainScreenWidth - 20, 30)];
    if ([feeLbel.text isEqualToString:@"x0"]) {
        [self.bountyTF setEnabled:YES];
        self.bountyTF.placeholder = @"小费金额不多于任务赏金";

    }else{
        [self.bountyTF setEnabled:NO];
        NSString *boutystr = [feeLbel.text substringFromIndex:1];
        self.bountyTF.text = [NSString stringWithFormat:@"已打赏%@赏金",boutystr];
        self.bountyTF.textColor = RGBCOLOR(234, 85, 20);
        self.bountyTF.enabled = NO;
    }
    self.bountyTF.keyboardType = UIKeyboardTypeNumberPad;
    self.bountyTF.textAlignment = NSTextAlignmentCenter;
    self.bountyTF.backgroundColor = RGBCOLOR(235, 235, 235);
    self.bountyTF.tag = 19;
    
    // 提示
    self.informLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bountyTF.frame.size.height + self.bountyTF.frame.origin.y + 5, mainScreenWidth, 20)];
    self.informLabel.text = @"温馨提示:打赏金额单位“元”";
    self.informLabel.font = [UIFont systemFontOfSize:13];
    self.informLabel.textColor = RGBCOLOR(137, 137, 137);
    self.informLabel.textAlignment = NSTextAlignmentCenter;
    
    //
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.informLabel.frame.size.height + self.informLabel.frame.origin.y + 5, mainScreenWidth, 0.5)];
    view2.backgroundColor = RGBCOLOR(235, 235, 235);
    [rewardFilter addSubview:view2];
    
    // 确定取消
    self.cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, view2.frame.origin.y + 0.5, (mainScreenWidth - 1) / 2, 44)];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    [self.cancleBtn addTarget:self action:@selector(missAlert:) forControlEvents:UIControlEventTouchUpInside];
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake((mainScreenWidth - 1) / 2 - 0.5, view2.frame.origin.y + 10, 1, 20)];
    view3.backgroundColor = RGBCOLOR(235, 235, 235);
    [rewardFilter addSubview:view3];
    self.determineBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 1) / 2 + 0.5, view2.frame.origin.y + 0.5, (mainScreenWidth - 1) / 2, 44)];
    [self.determineBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.determineBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    [self.determineBtn addTarget:self action:@selector(okAlert:) forControlEvents:UIControlEventTouchUpInside];
    self.determineBtn.tag = sender.tag;
    
    
    [rewardFilter addSubview:self.rewardBountyBtn];
    [rewardFilter addSubview:self.leftBtn];
    [rewardFilter addSubview:self.rewardCoinFeeBtn];
    [rewardFilter addSubview:self.rightBtn];
    [rewardFilter addSubview:self.rewardCouponBtn];
    [rewardFilter addSubview:self.redView];
    [backView addSubview:self.ownerIcon];
    [backView addSubview:self.hunterIcon];
    [rewardFilter addSubview:self.nameLabel];
    [rewardFilter addSubview:self.descLabel];
    [rewardFilter addSubview:self.gotoRechargeBtn];
    [rewardFilter addSubview:self.bountyTF];
    [rewardFilter addSubview:self.informLabel];
    [rewardFilter addSubview:self.cancleBtn];
    [rewardFilter addSubview:self.determineBtn];
}


// 驳回
- (void)reject:(UIButton *)btn3 {
    
    UIView * view = (UIView *)[btn3 superview];
    view.alpha = 0.0f;
    self.rejectTaskShow = [[UIActionSheet alloc] initWithTitle:@"是否驳回该任务秀?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    self.rejectTaskShow.tag = btn3.tag;
    [self.rejectTaskShow showInView:self.view];
}

#pragma mark --- 底部弹框 ---
// 打赏赏金
- (void)bountyBtnClick:(UIButton *) btn {
    [self.coinFeeTF resignFirstResponder];

    self.rewardBountyBtn.selected = YES;
    self.rewardCoinFeeBtn.selected = NO;
    self.rewardCouponBtn.selected = NO;
    
    [self.rewardBountyBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    [self.rewardCoinFeeBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    [self.rewardCouponBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];

    self.redView.frame = CGRectMake(0, self.redView.frame.origin.y, self.redView.frame.size.width, self.redView.frame.size.height);
    
    self.gotoRechargeBtn.hidden = NO;
    self.bountyTF.hidden = NO;
    self.coinFeeTF.hidden = YES;
    self.coupon.hidden = YES;
    
    self.descLabel.text = [NSString stringWithFormat:@"金库余额：%@", self.accountNum];
    self.informLabel.text = @"温馨提示:打赏金额单位“元”";
}
// 去充值
- (void)gotoRecharge:(UIButton *) btn {
    [rewardView dismissAnimated:YES];
    ghunterRechargeViewController * rechargeVc = [[ghunterRechargeViewController alloc] init];
    [self.navigationController pushViewController:rechargeVc animated:YES];
}
// 头像打赏金币
- (void)iconcoinFeeBtnClick:(UIButton *) btn {
    [self.bountyTF resignFirstResponder];
    self.rewardBountyBtn.selected = YES;
    self.rewardCoinFeeBtn.selected = NO;
    self.rewardCouponBtn.selected = NO;
    
    [self.rewardBountyBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    [self.rewardCoinFeeBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    [self.rewardCouponBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    
    self.redView.frame = CGRectMake(self.rewardCoinFeeBtn.frame.origin.x, self.redView.frame.origin.y, self.redView.frame.size.width, self.redView.frame.size.height);
    self.rewardBountyBtn.selected = NO;
    self.rewardCoinFeeBtn.selected = YES;
    self.rewardCouponBtn.selected = NO;
    
    self.gotoRechargeBtn.hidden = YES;
    self.bountyTF.hidden = YES;
    self.coupon.hidden = YES;
    
    self.descLabel.text = [NSString stringWithFormat:@"金币余额：%@", self.bountyGoldNum];
    self.coinFeeTF = [[UITextField alloc] init];
    self.coinFeeTF.delegate = self;
    self.coinFeeTF.tag = 20;
    [self.coinFeeTF setFrame:self.bountyTF.frame];
        [self.coinFeeTF setEnabled:YES];
        self.coinFeeTF.placeholder = @"每次打赏不低于1金币";
    self.coinFeeTF.textAlignment = NSTextAlignmentCenter;
    self.coinFeeTF.keyboardType = UIKeyboardTypePhonePad;
    self.coinFeeTF.backgroundColor = RGBCOLOR(235, 235, 235);
    
    self.informLabel.text = @"温馨提示:打赏金额单位“个”";
    
    [rewardFilter addSubview:self.coinFeeTF];
    
    if (is4Show == YES) {
        
    }
    if (is4Comment == YES) {
        
    }
    
    
    
    
}
// 评论打赏金币
- (void)LongcoinFeeBtnClick:(UIButton *) btn {
    [self.bountyTF resignFirstResponder];
    self.rewardBountyBtn.selected = YES;
    self.rewardCoinFeeBtn.selected = NO;
    self.rewardCouponBtn.selected = NO;
    
    [self.rewardBountyBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    [self.rewardCoinFeeBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    [self.rewardCouponBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    
    self.redView.frame = CGRectMake(self.rewardCoinFeeBtn.frame.origin.x, self.redView.frame.origin.y, self.redView.frame.size.width, self.redView.frame.size.height);
    self.rewardBountyBtn.selected = NO;
    self.rewardCoinFeeBtn.selected = YES;
    self.rewardCouponBtn.selected = NO;
    
    self.gotoRechargeBtn.hidden = YES;
    self.bountyTF.hidden = YES;
    self.coupon.hidden = YES;
    
    self.descLabel.text = [NSString stringWithFormat:@"金币余额：%@", self.bountyGoldNum];
    self.coinFeeTF = [[UITextField alloc] init];
    self.coinFeeTF.delegate = self;
    self.coinFeeTF.tag = 20;
    [self.coinFeeTF setFrame:self.bountyTF.frame];
    
    if ([_iscoinfee.text isEqualToString:@"0"]||_iscoinfee.text == nil) {
        [self.coinFeeTF setEnabled:YES];
        self.coinFeeTF.placeholder = @"每次打赏不低于1金币";
        
    }else{
        [self.coinFeeTF setEnabled:NO];
        
        self.coinFeeTF.text = [NSString stringWithFormat:@"已打赏%@金币",_iscoinfee.text];
        self.coinFeeTF.textColor = RGBCOLOR(234, 85, 20);
    }
    self.coinFeeTF.textAlignment = NSTextAlignmentCenter;
    self.coinFeeTF.keyboardType = UIKeyboardTypePhonePad;
    self.coinFeeTF.backgroundColor = RGBCOLOR(235, 235, 235);
    
    self.informLabel.text = @"温馨提示:打赏金额单位“个”";
    
    [rewardFilter addSubview:self.coinFeeTF];
    
    if (is4Show == YES) {
        //        if (isRewardCoin.integerValue > 0) {
        //            UIButton * btn = [[UIButton alloc] init];
        //            [btn setFrame:self.coinFeeTF.frame];
        //            [self.coinFeeTF addSubview:btn];
        //            [btn setTitle:isRewardCoin forState:UIControlStateNormal];
        //            [btn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
        //            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        //        }
    }
    if (is4Comment == YES) {
        
    }
    
    
    
    
}
// 打赏金币
- (void)coinFeeBtnClick:(UIButton *) btn {
    [self.bountyTF resignFirstResponder];
    UILabel *coinFeelbel =(UILabel *)[self.view viewWithTag:btn.tag+2000];
    
    self.rewardBountyBtn.selected = YES;
    self.rewardCoinFeeBtn.selected = NO;
    self.rewardCouponBtn.selected = NO;

    [self.rewardBountyBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    [self.rewardCoinFeeBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    [self.rewardCouponBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    
    self.redView.frame = CGRectMake(self.rewardCoinFeeBtn.frame.origin.x, self.redView.frame.origin.y, self.redView.frame.size.width, self.redView.frame.size.height);
    self.rewardBountyBtn.selected = NO;
    self.rewardCoinFeeBtn.selected = YES;
    self.rewardCouponBtn.selected = NO;
    
    self.gotoRechargeBtn.hidden = YES;
    self.bountyTF.hidden = YES;
    self.coupon.hidden = YES;
    
    self.descLabel.text = [NSString stringWithFormat:@"金币余额：%@", self.bountyGoldNum];
    self.coinFeeTF = [[UITextField alloc] init];
    self.coinFeeTF.delegate = self;
    self.coinFeeTF.tag = 20;
    [self.coinFeeTF setFrame:self.bountyTF.frame];
    
    if ([coinFeelbel.text isEqualToString:@"x0"]) {
        [self.coinFeeTF setEnabled:YES];
        self.coinFeeTF.placeholder = @"每次打赏不低于1金币";
        
    }else{
        [self.coinFeeTF setEnabled:NO];

        NSString *boutystr = [coinFeelbel.text substringFromIndex:1];
        self.coinFeeTF.text = [NSString stringWithFormat:@"已打赏%@金币",boutystr];
        self.coinFeeTF.textColor = RGBCOLOR(234, 85, 20);
    }
    self.coinFeeTF.textAlignment = NSTextAlignmentCenter;
    self.coinFeeTF.keyboardType = UIKeyboardTypePhonePad;
    self.coinFeeTF.backgroundColor = RGBCOLOR(235, 235, 235);
    
    self.informLabel.text = @"温馨提示:打赏金额单位“个”";
    
    [rewardFilter addSubview:self.coinFeeTF];
    
    if (is4Show == YES) {
//        if (isRewardCoin.integerValue > 0) {
//            UIButton * btn = [[UIButton alloc] init];
//            [btn setFrame:self.coinFeeTF.frame];
//            [self.coinFeeTF addSubview:btn];
//            [btn setTitle:isRewardCoin forState:UIControlStateNormal];
//            [btn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
//            btn.titleLabel.font = [UIFont systemFontOfSize:14];
//        }
    }
    if (is4Comment == YES) {
        
    }
    
    
    
    
}
// 头像打赏优惠券
- (void)iconcouponBtnClick:(UIButton *) btn {
    [self.coinFeeTF resignFirstResponder];
    [self.bountyTF resignFirstResponder];
    self.rewardBountyBtn.selected = YES;
    self.rewardCoinFeeBtn.selected = NO;
    self.rewardCouponBtn.selected = NO;
    
    [self.rewardBountyBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    [self.rewardCoinFeeBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    [self.rewardCouponBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    
    self.redView.frame = CGRectMake(self.rewardCouponBtn.frame.origin.x, self.redView.frame.origin.y, self.redView.frame.size.width, self.redView.frame.size.height);
    self.rewardBountyBtn.selected = NO;
    self.rewardCoinFeeBtn.selected = NO;
    self.rewardCouponBtn.selected = YES;
    
    self.descLabel.text = @"优惠券：";
    self.gotoRechargeBtn.hidden = YES;
    self.bountyTF.hidden = YES;
    self.coinFeeTF.hidden = YES;
    
    self.coupon = [[UIButton alloc] init];
    [self.coupon setFrame:self.bountyTF.frame];
    self.coupon.backgroundColor = RGBCOLOR(245, 245, 245);
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth - 120, 0, 100, 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = RGBCOLOR(137, 137, 137);
    label.font = [UIFont systemFontOfSize:12];
    
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [self.coupon addSubview:img];
        img.image = [UIImage imageNamed:@"优惠券已赏"];
        [self.coupon addTarget:self action:@selector(gotoMyCoupon:) forControlEvents:UIControlEventTouchUpInside];
        label.text = @"去选择>";
        [self.coupon addSubview:label];
    img.userInteractionEnabled = YES;
    
    self.informLabel.text = @"温馨提示:打赏金额单位“张”";
    
    [rewardFilter addSubview:self.coupon];
}
// 评论打赏优惠券
- (void)longcouponBtnClick:(UIButton *) btn {
    [self.coinFeeTF resignFirstResponder];
    [self.bountyTF resignFirstResponder];
    self.rewardBountyBtn.selected = YES;
    self.rewardCoinFeeBtn.selected = NO;
    self.rewardCouponBtn.selected = NO;
    
    [self.rewardBountyBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    [self.rewardCoinFeeBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    [self.rewardCouponBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
    
    self.redView.frame = CGRectMake(self.rewardCouponBtn.frame.origin.x, self.redView.frame.origin.y, self.redView.frame.size.width, self.redView.frame.size.height);
    self.rewardBountyBtn.selected = NO;
    self.rewardCoinFeeBtn.selected = NO;
    self.rewardCouponBtn.selected = YES;
    
    self.descLabel.text = @"优惠券：";
    self.gotoRechargeBtn.hidden = YES;
    self.bountyTF.hidden = YES;
    self.coinFeeTF.hidden = YES;
    
    self.coupon = [[UIButton alloc] init];
    [self.coupon setFrame:self.bountyTF.frame];
    self.coupon.backgroundColor = RGBCOLOR(245, 245, 245);
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth - 120, 0, 100, 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = RGBCOLOR(137, 137, 137);
    label.font = [UIFont systemFontOfSize:12];
    
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [self.coupon addSubview:img];
    if ([_iscodeid.text isEqualToString:@"0"]||_iscodeid.text ==nil) {
        
        img.image = [UIImage imageNamed:@"优惠券已赏"];
        [self.coupon addTarget:self action:@selector(gotoMyCoupon:) forControlEvents:UIControlEventTouchUpInside];
        label.text = @"去选择>";
        
        [self.coupon addSubview:label];
        
        
    }else{
        img.image = [UIImage imageNamed:@"赏you"];
        self.coupon.enabled = NO;
        label.text = [NSString stringWithFormat:@"已打赏%@张优惠劵",_iscodeid.text];
        [self.coupon addSubview:label];
        
    }
    img.userInteractionEnabled = YES;
    
    self.informLabel.text = @"温馨提示:打赏金额单位“张”";
    
    [rewardFilter addSubview:self.coupon];
}
// 打赏优惠券
- (void)couponBtnClick:(UIButton *) btn {
    [self.coinFeeTF resignFirstResponder];
    [self.bountyTF resignFirstResponder];
    UILabel *couponLbel = (UILabel *)[self.view viewWithTag:btn.tag + 3000];
    self.rewardBountyBtn.selected = YES;
    self.rewardCoinFeeBtn.selected = NO;
    self.rewardCouponBtn.selected = NO;

    [self.rewardBountyBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    [self.rewardCoinFeeBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
    [self.rewardCouponBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];

    self.redView.frame = CGRectMake(self.rewardCouponBtn.frame.origin.x, self.redView.frame.origin.y, self.redView.frame.size.width, self.redView.frame.size.height);
    self.rewardBountyBtn.selected = NO;
    self.rewardCoinFeeBtn.selected = NO;
    self.rewardCouponBtn.selected = YES;
    
    self.descLabel.text = @"优惠券：";
    self.gotoRechargeBtn.hidden = YES;
    self.bountyTF.hidden = YES;
    self.coinFeeTF.hidden = YES;
    
    self.coupon = [[UIButton alloc] init];
    [self.coupon setFrame:self.bountyTF.frame];
    self.coupon.backgroundColor = RGBCOLOR(245, 245, 245);
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth - 120, 0, 100, 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = RGBCOLOR(137, 137, 137);
    label.font = [UIFont systemFontOfSize:12];
    
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [self.coupon addSubview:img];
    if ([couponLbel.text isEqualToString:@"x0"]) {
        
        img.image = [UIImage imageNamed:@"优惠券已赏"];
        [self.coupon addTarget:self action:@selector(gotoMyCoupon:) forControlEvents:UIControlEventTouchUpInside];
        label.text = @"去选择>";

        [self.coupon addSubview:label];

        
    }else{
        NSString *boutystr = [couponLbel.text substringFromIndex:1];
        img.image = [UIImage imageNamed:@"赏you"];
        self.coupon.enabled = NO;
        label.text = [NSString stringWithFormat:@"已打赏%@张优惠劵",boutystr];
        [self.coupon addSubview:label];

    }
    img.userInteractionEnabled = YES;
    
    self.informLabel.text = @"温馨提示:打赏金额单位“张”";

    [rewardFilter addSubview:self.coupon];
}
// 去我的优惠券
- (void)gotoMyCoupon:(UIButton *) btn {
   /*
    [rewardView dismissAnimated:YES];
    ghunterMyNotUseDiscountViewController * couponVC = [[ghunterMyNotUseDiscountViewController alloc] init];
    [self.navigationController pushViewController:couponVC animated:YES];
    */
    
    ghunterMyNotUseDiscountViewController *mycoupon = [[ghunterMyNotUseDiscountViewController alloc]init];
    mycoupon.blockImmediately = ^(NSString *str){
        _immediatelyString = str;
    };
    
    [rewardView dismissAnimated:YES];
    [self.navigationController pushViewController:mycoupon animated:YES];
}

// 取消
- (void)missAlert:(UIButton *)btn {
    
    [rewardView dismissAnimated:YES];
}

// 确定
- (void)okAlert:(UIButton *)btn {
    
    UILabel * descLb = (UILabel *)[rewardView viewWithTag:21];

    NSDictionary * dict = [[NSMutableDictionary alloc] init];
    NSDictionary *info = [task objectForKey:@"info"];
    if (is4Show == YES && is4Comment == NO) {
        dict = [taskShowArray objectAtIndex:btn.tag - 1];
        if (self.rewardBountyBtn.selected == YES) {
            
            NSString *regex = @"^\\d+(.\\d{1,2})?$";
            if (![self.bountyTF.text isMatchedByRegex:regex]) {
                [ProgressHUD show:@"打赏最多保留两位小数"];
                [rewardView dismissAnimated:YES];
                return;
            }
            
            double rewardInt = [self.bountyTF.text doubleValue];
            double bountyInt = [[info objectForKey:@"bounty"] doubleValue];
            
            if(rewardInt > self.accountNum.doubleValue){
                [tipAlertView endEditing:YES];
                [ProgressHUD show:@"金库余额不足，请先充值"];
                [rewardView dismissAnimated:YES];
                return;
            }
            if (rewardInt > bountyInt) {
                [tipAlertView endEditing:YES];
                [ProgressHUD show:@"打赏金额不能超过任务赏金"];
                [rewardView dismissAnimated:YES];
                return;
            }
            [self didRewardHunterIsLoading:YES withTsid:[dict objectForKey:@"tsid"] andWithType:@"bounty" andWithData:self.bountyTF.text andWithFlag:@"1"];
        }
        if (self.rewardCoinFeeBtn.selected == YES) {
            [self didRewardHunterIsLoading:YES withTsid:[dict objectForKey:@"tsid"] andWithType:@"coin" andWithData:self.coinFeeTF.text andWithFlag:@"2"];
        }
        if (self.rewardCouponBtn.selected == YES) {
            [self didRewardHunterIsLoading:YES withTsid:[dict objectForKey:@"tsid"] andWithType:@"coupon" andWithData:_immediatelyString andWithFlag:@"3"];
        }
    }
    if (is4Comment == YES && is4Show == NO) {
//        dict = [taskcommentArray objectAtIndex:btn.tag - 1];
//        if (self.rewardBountyBtn.selected == YES) {
//            
//            NSString *regex = @"^\\d+(.\\d{1,2})?$";
//            if (![self.bountyTF.text isMatchedByRegex:regex]) {
//                [ProgressHUD show:@"打赏最多保留两位小数"];
//                [rewardView dismissAnimated:YES];
//                return;
//            }
//            
//            double rewardInt = [self.bountyTF.text doubleValue];
//            double bountyInt = [[info objectForKey:@"bounty"] doubleValue];
//            
//            if(rewardInt > self.accountNum.doubleValue){
//                [tipAlertView endEditing:YES];
//                [ProgressHUD show:@"金库余额不足，请先充值"];
//                [rewardView dismissAnimated:YES];
//                return;
//            }
//            if (rewardInt > bountyInt) {
//                [tipAlertView endEditing:YES];
//                [ProgressHUD show:@"打赏金额不能超过任务赏金"];
//                [rewardView dismissAnimated:YES];
//                return;
//            }
//            [self didRewardHunterIsLoading:YES withTsid:[dict objectForKey:@"tsid"] andWithType:@"bounty" andWithData:self.bountyTF.text andWithFlag:@"1"];
//        }
//        if (self.rewardCoinFeeBtn.selected == YES) {
//            [self didRewardHunterIsLoading:YES withTsid:[dict objectForKey:@"tsid"] andWithType:@"coin" andWithData:self.coinFeeTF.text andWithFlag:@"2"];
//        }
//        if (self.rewardCouponBtn.selected == YES) {
//            [self didRewardHunterIsLoading:YES withTsid:[dict objectForKey:@"tsid"] andWithType:@"coupon" andWithData:_immediatelyString andWithFlag:@"3"];
//        }



    }
    
//    else  {
    
//        NSArray *joiners = [task objectForKey:@"joiners"];
//        NSDictionary *joiner = [joiners objectAtIndex:btn.tag];

//        [self didLongPressRewardFee:YES andWithTid:self.tid andWithUid:[[taskcommentArray objectAtIndex:btn.tag - 1] objectForKey:@"uid"] andWithFee:preString];
//    }
    is4Show = NO;
    is4Comment = NO;
    [rewardView dismissAnimated:YES];
}

// 获取金币数据
-(void)didGetGoldNumDataIsloading:(BOOL )isloading{
    
    [AFNetworkTool httpRequestWithUrl:URL_GET_MY_CENTER params:nil success:^(NSData *data) {
        
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            dict = [result objectForKey:@"user"];
            self.bountyGoldNum = [dict objectForKey:@"coin_balance"];
            self.accountNum = [dict objectForKey:@"balance"];
            if (self.rewardBountyBtn.selected == YES) {
                self.descLabel.text = [NSString stringWithFormat:@"金库余额：%@", self.accountNum];
            }else if (self.rewardCoinFeeBtn.selected == YES){
                self.descLabel.text = [NSString stringWithFormat:@"金币余额：%@", self.bountyGoldNum];
            }else {
                self.descLabel.text = [NSString stringWithFormat:@"优惠券："];
            }
        }
    } fail:^{
        
    }];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    

    if (textField.text.length == 0) {
        preString = @"";
    }
    
    if (textField.tag == 19) {
        
        preString = [preString stringByAppendingString:string];
        if ([preString integerValue] > [self.bountyGoldNum integerValue]) {
            preString = [preString substringToIndex:preString.length - 1];
            return NO;
        }
        return YES;

    }

    if (textField.tag == 20) {
        
        preString = [preString stringByAppendingString:string];
        if ([preString integerValue] > [self.bountyGoldNum integerValue]) {
            preString = [preString substringToIndex:preString.length - 1];
            return NO;
        }
        if (range.location < preString.length) {
            
        }
        if ([string isMatchedByRegex:@"^[0-9]$"]) {
            if (range.location == 0 && [string isEqualToString:@"0"]) {
                
                return YES;
            } else {
                NSString *regex = @"^[1-9][0-9]*$";
                if([textField.text isMatchedByRegex:regex]){
                    return YES;
                }
            }
        } else if ([string isEqualToString:@""]){
            
            return YES;
        } else {
            return NO;
        }
        return YES;
    }
    return YES;
    
    
}

#pragma mark --- 中意猎人 ---
-(void)didSelectHunterIsloading:(BOOL )isloading withParameters:(NSMutableDictionary *)parameters{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:URL_SELECT_HUNTER params:parameters success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [ProgressHUD show:[result objectForKey:@"msg"]];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            NSNotification *notification = [[NSNotification alloc] initWithName:GHUNTERSELECTHUNTER object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
//            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}


#pragma mark --- 任务秀驳回 --- 
- (void) didRejectTaskShowIsLoading:(BOOL) isLoading withParameters:(NSMutableDictionary *)parameters {
    if (isLoading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:URL_TASKSHOW_REJECT params:parameters success:^(NSData *data) {
        if (isLoading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [ProgressHUD show:[result objectForKey:@"msg"]];
        
    } fail:^{
        
    }];
}



#pragma mark --- 任务秀打赏 ---
- (void) didRewardHunterIsLoading:(BOOL) isLoading withTsid:(NSString *)tsid andWithType:(NSString *)type andWithData:(NSString *) dataStr andWithFlag:(NSString *) flag{
    if (isLoading) {
        [self startLoad];
    }
    
    NSString * url = [[NSString alloc] init];
    if ([flag isEqualToString:@"1"]) {
        double db = dataStr.doubleValue;
        url = [NSString stringWithFormat:@"%@?tsid=%@&type=%@&data=%f", URL_TASKSHOW_REWARD, tsid, type, db];
    }else if ([flag isEqualToString:@"2"]){
        int db = dataStr.intValue;
        url = [NSString stringWithFormat:@"%@?tsid=%@&type=%@&data=%ld", URL_TASKSHOW_REWARD, tsid, type, (long)db];
    }else {
        url = [NSString stringWithFormat:@"%@?tsid=%@&type=%@&data=%ld", URL_TASKSHOW_REWARD, tsid, type, dataStr.integerValue];
    }

    [AFNetworkTool httpRequestWithUrl:url params:nil success:^(NSData *data) {
        if (isLoading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([[result objectForKey:@"error"]integerValue] == 0) {

            [ProgressHUD show:[result objectForKey:@"msg"]];
            
            if ([flag isEqualToString:@"1"]) {
                isBounty = YES;
            }else if ([flag isEqualToString:@"2"]) {
                isGold = YES;
            }else if ([flag isEqualToString:@"3"]) {
                isCoupon = YES;
            }
            
//            [rewardView dismissAnimated:YES];
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
        }
        
        
    } fail:^{
        
    }];
}


#pragma mark --- 长按打赏赏金 --- 
-(void) didLongPressRewardFee:(BOOL)isLoading andWithTid:(NSString *)tid andWithUid:(NSString *)uid andWithFee:(NSString *)fee {
    if (isLoading) {
        [self startLoad];
    }
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:tid forKey:@"tid"];
    [dict setObject:uid forKey:@"uid"];
    [dict setObject:fee forKey:@"fee"];
    
    [AFNetworkTool httpRequestWithUrl:URL_LEAVE_FEE params:dict success:^(NSData *data) {
        if (isLoading) {
            [self endLoad];
        }
        [self endLoad];
        
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        [ProgressHUD show:[result objectForKey:@"msg"]];
        if([[result objectForKey:@"error"]integerValue] == 0)
        {
            [self didGetTaskDetailIsloading:NO isWithCommets:NO];
        }else{
            [self endLoad];
        }
    } fail:^{
        [self endLoad];
        [ProgressHUD show:HTTPREQUEST_ERROR];
    }];

}

#pragma mark --- 长按打赏金币 ---
-(void) didLongPressRewardCoin:(BOOL) isLoading andWithTid:(NSString *)tid andWithUid:(NSString *)uid andWithCoin:(NSString *) coin {
    
    if (isLoading) {
        [self startLoad];
    }
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:tid forKey:@"tid"];
//    [dict setObject:uid forKey:@"uid"];
    [dict setObject:coin forKey:@"coins"];
    
    [AFNetworkTool httpRequestWithUrl:URL_LEAVE_COIN params:dict success:^(NSData *data) {
        if (isLoading) {
            [self endLoad];
        }
        [self endLoad];
        
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        [ProgressHUD show:[result objectForKey:@"msg"]];
        if([[result objectForKey:@"error"]integerValue] == 0)
        {
            [self didGetTaskDetailIsloading:NO isWithCommets:NO];
        }else{
            [self endLoad];
        }
    } fail:^{
        [self endLoad];
        [ProgressHUD show:HTTPREQUEST_ERROR];
    }];

    
    
}

-(void)immediatelyAction
{
    ghunterMyNotUseDiscountViewController *mycoupon = [[ghunterMyNotUseDiscountViewController alloc]init];
    mycoupon.blockImmediately = ^(NSString *str){
        _immediatelyString = str;
    };
    
    [self.navigationController pushViewController:mycoupon animated:YES];
}



@end