//
//  ghunterReleaseSkillViewController.m
//  ghunter
//
//  Created by imGondar on 15/1/28.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import "ghunterReleaseSkillViewController.h"
#import "ghunterTabViewController.h"
#import "ghunterNearbyViewController.h"
#import "ghunterSkillViewController.h"
#import "ghunterAddSkillCatalogViewController.h"

@interface ghunterReleaseSkillViewController ()
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIButton *ServiceLocationButton;
@property (strong, nonatomic) IBOutlet UIView *ServiceLocationView;
@property (strong, nonatomic) IBOutlet UIButton *ServiceTimeButton;

@property (strong, nonatomic) IBOutlet UIView *ServiceTimeView;
@property (strong, nonatomic) IBOutlet UILabel *serviceButtonLabel;
@property (strong, nonatomic) IBOutlet UIView *ServiceBgView;
@property (strong, nonatomic) IBOutlet UIButton *Service;
- (IBAction)backBtn:(UIButton *)sender;
- (IBAction)releaseBtn:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *mySkillView;
@property (strong, nonatomic) IBOutlet UIView *skillContentView;
@property (strong, nonatomic) IBOutlet UIButton *unitBtn;
@property (strong, nonatomic) IBOutlet UILabel *skillTitle;
@property (strong, nonatomic) IBOutlet UILabel *priceUnitLabel;

@property (strong, nonatomic) IBOutlet UITextField *skillTF;
- (IBAction)chooseKindBtn:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *chooseTF;
@property (strong, nonatomic) IBOutlet UITextField *addGoldTF;
- (IBAction)priceUnitBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (strong, nonatomic) IBOutlet UIButton *btn4;
@property (strong, nonatomic) IBOutlet UIButton *btn5;
@property (strong, nonatomic) IBOutlet UIButton *btn6;
@property (strong, nonatomic) IBOutlet UIButton *btn7;
@property (strong, nonatomic) IBOutlet UIButton *btn8;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@property(strong,nonatomic)NSMutableArray* skills;
@property(strong,nonatomic)NSMutableArray *imgURLArray;

@property(strong,nonatomic)NSMutableArray *imgArray;
@property (strong, nonatomic) NSMutableArray *imgRemoveArray;
@property (strong,nonatomic) NSMutableArray *pidsRemoveArray;

@property (weak, nonatomic) UIScrollView *imgScrollView;
//@property (nonatomic, strong) NSMutableArray *selectedIndexes;
//@property (nonatomic, strong) NSMutableArray *checkmarkImageViews;
@property (strong, nonatomic) IBOutlet UIView *bg;

@property(nonatomic,strong)NSMutableDictionary* postDic;
@property(nonatomic,strong)UIPickerView* pickerView;
@property(nonatomic,strong)NSString* btnTitle;
@property(nonatomic,strong)NSArray* unitArr;

@property(nonatomic,assign)BOOL releaseNow;

@property (weak, nonatomic) IBOutlet UIButton *releaseSkill;
@property (strong, nonatomic)  NSMutableArray *timeButtonArray;


@end

@implementation ghunterReleaseSkillViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor redColor];
   
    _timeButtonArray = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.hidden = YES;
     _bg.backgroundColor = Nav_backgroud;
   
    self.skills = [[NSMutableArray alloc] init];
    self.postDic = [[NSMutableDictionary alloc] init];
    self.skillTF.delegate = self;
    self.chooseTF.delegate = self;
    self.addGoldTF.delegate = self;
    self.addGoldTF.tag = 101;
    self.contentTextView.delegate=self;
    imageOne = [[UIImageView alloc]init];
    imageTwo = [[UIImageView alloc]init];
    imageThree = [[UIImageView alloc]init];
    imageFour = [[UIImageView alloc]init];
//    self.skillContentView.layer.cornerRadius = 8.0;
    
    _imgArray = [NSMutableArray array];
    _imgURLArray = [NSMutableArray array];
    _imgRemoveArray = [NSMutableArray array];
    _pidsRemoveArray = [NSMutableArray array];
    
    
    skillScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64)];
    skillScrollView.delegate = self;
    skillScrollView.contentSize = CGSizeMake(0, mainScreenheight + 40);
    skillScrollView.showsHorizontalScrollIndicator = NO;
    skillScrollView.showsVerticalScrollIndicator = NO;
    
    NSURL *url = [NSURL URLWithString:URL_GET_USER_SKILL];
    //创建http请求
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:HTTP_METHOD_POST];
    [request setPostValue:API_TOKEN_NUM forKey:API_TOKEN];
    if([self getApi_session_id]) {
        [request setPostValue:[self getApi_session_id] forKey:@"api_session_id"];
    }
    [request setDelegate:self];
    request.userInfo = [NSDictionary dictionaryWithObject:REQUEST_FOR_USER_SKILL forKey:REQUEST_TYPE];
    [request startSynchronous];
    
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
    self.skills = [dic objectForKey:@"skills"];
    CGFloat oldX=0;
    CGFloat oldY=10;
    NSInteger y=23;
   
    for(NSUInteger i=0;i<self.skills.count;i++)
    {
        UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.skills[i] forState:UIControlStateNormal];
//        btn.tintColor=[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        btn.tag=10+i;
        [btn setTitleColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:11];
        [btn addTarget:self action:@selector(skillClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor clearColor]];
        CALayer *btnLayer = [btn layer];
        [btnLayer setMasksToBounds:YES];
        [btnLayer setCornerRadius:10.0];
        [btnLayer setBorderWidth:1.0];
        [btnLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
        [btnLayer setBorderColor:[[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1] CGColor]];
        
        btn.layer.cornerRadius=8.0;
        CGFloat width=btn.titleLabel.text.length*10+10;
        if(i==0)
        {
            btn.frame=CGRectMake(10, 10, width, 18);
        }
        else
        {
            if(2+oldX+width>300)
            {
                btn.frame=CGRectMake(10, oldY+y, width, 18);
            }
            else
            {
                btn.frame=CGRectMake(10+oldX,oldY, width, 18);
            }

        }
        oldX=btn.frame.origin.x+btn.frame.size.width;
        oldY=btn.frame.origin.y;
        CGRect frame1=self.mySkillView.frame;
        CGRect frame2=self.skillContentView.frame;
        if(btn.tag==9+self.skills.count)
        {
            frame1.size.height=btn.frame.origin.y+25;
            self.mySkillView.frame=frame1;
            frame2.origin.y=frame1.size.height+frame1.origin.y+7;
//            self.skillContentView.frame=frame2;
        }
        [self.mySkillView addSubview:btn];
    }
    
    [self showPicture];
    self.unitArr=[[NSArray alloc] init];
    self.unitArr=@[@"小时",@"天",@"次",@"场",@"晚"];
    
    if(self.skillDic.count)
    {
        // 技能详情传过来的，此时是修改技能的功能
        self.skillTitle.text = @"修改技能";
        self.priceUnitLabel.alpha=1.0;
        NSMutableDictionary* skillInfo=[[NSMutableDictionary alloc] init];
        NSMutableArray* imageArr=[[NSMutableArray alloc] init];
        skillInfo=[self.skillDic objectForKey:@"info"];
        
        imageArr = [self.skillDic objectForKey:@"images"];
        _skillTF.text=[skillInfo objectForKey:@"skill"];
        _chooseTF.text=[skillInfo objectForKey:@"skill"];
        [self.postDic setObject:[skillInfo objectForKey:@"cid"] forKey:@"cid"];
        
        NSString* priceStr=[NSString stringWithFormat:@"%@",[skillInfo objectForKey:@"price"]];
        _addGoldTF.text=priceStr;
       
        NSString* unitStr=[NSString stringWithFormat:@"%@",[skillInfo objectForKey:@"priceunit"]];
        [_unitBtn setTitle:unitStr forState:UIControlStateNormal];
        _contentTextView.text=[skillInfo objectForKey:@"description"];
        self.contentLabel.hidden = YES;
      
        for(NSDictionary* dic in imageArr)
        {
            NSString* imageURL = [dic objectForKey:@"tinyurl"];
            [_imgURLArray addObject:imageURL];
            
            NSURL *url = [NSURL URLWithString:imageURL];
            UIImage *image_1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            
            // [image_1 setValue:[dic objectForKey:@"pid"] forKey:@"name"];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:image_1 forKey:@"img"];
            [dict setObject:[dic objectForKey:@"pid"] forKey:@"pid"];
            
            [_imgArray addObject:dict];
        }
        if ( [_imgURLArray count] > 0 ) {
            [self showPicture];
        }
        
        _mySkillView.hidden = YES;
        CGRect frame1=_skillContentView.frame;
        frame1.origin.y=72;
//        _skillContentView.frame=frame1;
    }
    
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GHUNTERADDSKILLCAT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSkillCatOK:) name:GHUNTERADDSKILLCAT object:nil];
    
    self.releaseSkill.layer.cornerRadius = 3.0;
    self.releaseSkill.alpha = 0.5;
    
}


-(void)tapClick:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self modifyTheSize];
}
-(void)modifyTheSize{
    if (_btn2.selected == NO&&_btn3.selected==YES) {
        self.skillContentView.frame = CGRectMake(0, 0, mainScreenWidth,350);
        
    }
    else if (_btn5.selected == NO&&_btn6.selected==YES) {
        self.skillContentView.frame = CGRectMake(0, 0, mainScreenWidth,430);
        
    }
    else if ((_btn1.selected == NO&&_btn2.selected==YES)||(_btn0.selected == NO&&_btn1.selected==YES)||(_btn0.selected == YES)) {
        self.skillContentView.frame = CGRectMake(0, 0, mainScreenWidth,270);
        
    }
    else if ((_btn4.selected == NO&&_btn5.selected==YES)||(_btn3.selected == NO&&_btn4.selected==YES)) {
        self.skillContentView.frame = CGRectMake(0, 0,mainScreenWidth,350);
        
    }else{
        self.skillContentView.frame = CGRectMake(0, 0, mainScreenWidth,430);
        
    }
    
    [skillScrollView addSubview:self.skillContentView];
    
    self.releaseSkill.frame = CGRectMake(10, self.skillContentView.frame.origin.y + self.skillContentView.frame.size.height + 10+90, mainScreenWidth - 20, self.releaseSkill.frame.size.height);
    [skillScrollView addSubview:self.releaseSkill];
    [self.view addSubview:skillScrollView];
    _ServiceBgView.frame = CGRectMake(0, self.skillContentView.frame.origin.y + self.skillContentView.frame.size.height + 10, mainScreenWidth, 40);
    _Service.frame = CGRectMake(_ServiceBgView.frame.size.width-80, 5, 60, 30);
    _ServiceTimeView.frame = CGRectMake(0, self.skillContentView.frame.origin.y + self.skillContentView.frame.size.height + self.ServiceBgView.frame.size.height+10, mainScreenWidth, 35);
    _ServiceTimeView.hidden = NO;
    
    _ServiceLocationView.frame = CGRectMake(0, self.skillContentView.frame.origin.y + self.skillContentView.frame.size.height + self.ServiceBgView.frame.size.height+self.ServiceTimeView.frame.size.height+10, mainScreenWidth, 35);
    _ServiceLocationView.hidden = YES;
    
    [_ServiceBgView addSubview:_Service];
    [skillScrollView addSubview:_ServiceTimeView];
    [skillScrollView addSubview:_ServiceLocationView];
    [skillScrollView addSubview:_ServiceBgView];
    
}
- (void)viewDidAppear:(BOOL)animated {
   
    
    if(!imgondar_islogin) {
        [_releaseSkill setUserInteractionEnabled:NO];
    }
    else {
        [_releaseSkill setUserInteractionEnabled:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    if (self.releaseNow) {
        [self callBackBlock]();
    }
    ghunterTabViewController *tbvc = (ghunterTabViewController *)self.tabBarController;
    tbvc.didSelectItemOfTabBar = YES;
}

- (NSString *)getApi_session_id{
    NSString *api_session_id = [[NSUserDefaults standardUserDefaults] objectForKey:API_SESSION_ID];
    if(!api_session_id) return @"";
    else return api_session_id;
}
-(void)skillClick:(UIButton*)sender
{
    self.skillTF.text=sender.titleLabel.text;
}
#pragma mark - textField& textView delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    if(range.location > 200)
        return NO;
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    if(/*textField==self.skillTF&&*/self.skillDic.count!=0)
    //    {
    //        return NO;
    //    }
    //    else
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if(range.location > 200) return NO;
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    if(self.contentTextView.text.length != 0){
        self.contentLabel.hidden = YES;
        if (textView.text.length >= 15) {
            
            self.releaseSkill.alpha = 1;
        }
    }else{
        self.contentLabel.hidden = NO;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.priceUnitLabel.alpha = 1.0;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    pictureAlert.frame = [[UIScreen mainScreen] bounds];
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    pictureAlert.frame = CGRectMake(0, -278, mainScreenWidth, ScreenHeightFull);
    [UIView commitAnimations];
}



#pragma mark - UITextview Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView == self.contentTextView) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             CGRect frame = self.mySkillView.frame;
                             frame.origin.y -= textView.frame.size.height;
                             self.mySkillView.frame = frame;
                             
                             CGRect frame2 = self.skillContentView.frame;
//                             frame2.origin.y = frame2.origin.y - textView.frame.size.height + 50;
//                             self.skillContentView.frame = frame2;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.contentTextView) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             CGRect frame = self.mySkillView.frame;
                             frame.origin.y += textView.frame.size.height;
                             self.mySkillView.frame = frame;
                             
                             CGRect frame2 = self.skillContentView.frame;
//                             frame2.origin.y = frame2.origin.y + textView.frame.size.height - 50;
//                             self.skillContentView.frame = frame2;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)addPicture:(NSInteger)sender {
    if(sender == 0) {
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = (9 - [_imgArray count]);
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
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
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setAllowsEditing:YES];
        [imgPicker setDelegate:self];
        [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
    }
}
#pragma mark - addImage
- (void)showPicture {
    
    switch (_imgArray.count) {
    case 0:
        [_btn0 setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
        [_btn0 setHidden:NO];
        [_btn0 setSelected:YES];
        [_btn1 setHidden:YES];
        [_btn1 setSelected:YES];
        [_btn2 setHidden:YES];
        [_btn2 setSelected:YES];
        [_btn3 setHidden:YES];
        [_btn3 setSelected:YES];
            [_btn4 setHidden:YES];
            [_btn4 setSelected:YES];
            [_btn5 setHidden:YES];
            [_btn5 setSelected:YES];
            [_btn6 setHidden:YES];
            [_btn6 setSelected:YES];
            [_btn7 setHidden:YES];
            [_btn7 setSelected:YES];
            [_btn8 setHidden:YES];
            [_btn8 setSelected:YES];
        break;
    case 1:
        [_btn0 setImage:[_imgArray[0] objectForKey:@"img"] forState:UIControlStateNormal];
        [_btn1 setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
        [_btn0 setHidden:NO];
        [_btn0 setSelected:NO];
        [_btn1 setHidden:NO];
        [_btn1 setSelected:YES];
        [_btn2 setHidden:YES];
        [_btn2 setSelected:YES];
        [_btn3 setHidden:YES];
        [_btn3 setSelected:YES];
            [_btn4 setHidden:YES];
            [_btn4 setSelected:YES];
            [_btn5 setHidden:YES];
            [_btn5 setSelected:YES];
            [_btn6 setHidden:YES];
            [_btn6 setSelected:YES];
            [_btn7 setHidden:YES];
            [_btn7 setSelected:YES];
            [_btn8 setHidden:YES];
            [_btn8 setSelected:YES];
        break;
    case 2:
        [_btn0 setImage:[_imgArray[1] objectForKey:@"img"] forState:UIControlStateNormal];
        [_btn1 setImage:[_imgArray[0] objectForKey:@"img"] forState:UIControlStateNormal];
        [_btn2 setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
        [_btn0 setHidden:NO];
        [_btn0 setSelected:NO];
        [_btn1 setHidden:NO];
        [_btn1 setSelected:NO];
        [_btn2 setHidden:NO];
        [_btn2 setSelected:YES];
        [_btn3 setHidden:YES];
        [_btn3 setSelected:YES];
            [_btn4 setHidden:YES];
            [_btn4 setSelected:YES];
            [_btn5 setHidden:YES];
            [_btn5 setSelected:YES];
            [_btn6 setHidden:YES];
            [_btn6 setSelected:YES];
            [_btn7 setHidden:YES];
            [_btn7 setSelected:YES];
            [_btn8 setHidden:YES];
            [_btn8 setSelected:YES];
        break;
    case 3:
        [_btn0 setImage:[_imgArray[2] objectForKey:@"img"] forState:UIControlStateNormal];
        [_btn1 setImage:[_imgArray[1] objectForKey:@"img"] forState:UIControlStateNormal];
        [_btn2 setImage:[_imgArray[0] objectForKey:@"img"] forState:UIControlStateNormal];
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
        [_btn0 setHidden:NO];
        [_btn0 setSelected:NO];
        [_btn1 setHidden:NO];
        [_btn1 setSelected:NO];
        [_btn2 setHidden:NO];
        [_btn2 setSelected:NO];
        [_btn3 setHidden:NO];
        [_btn3 setSelected:YES];
            [_btn4 setHidden:YES];
            [_btn4 setSelected:YES];
            [_btn5 setHidden:YES];
            [_btn5 setSelected:YES];
            [_btn6 setHidden:YES];
            [_btn6 setSelected:YES];
            [_btn7 setHidden:YES];
            [_btn7 setSelected:YES];
            [_btn8 setHidden:YES];
            [_btn8 setSelected:YES];
        break;
    case 4:
        [_btn0 setImage:[_imgArray[3] objectForKey:@"img"] forState:UIControlStateNormal];
        [_btn1 setImage:[_imgArray[2] objectForKey:@"img"] forState:UIControlStateNormal];
        [_btn2 setImage:[_imgArray[1] objectForKey:@"img"] forState:UIControlStateNormal];
        [_btn3 setImage:[_imgArray[0] objectForKey:@"img"] forState:UIControlStateNormal];
        [_btn4 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_btn4 setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
        [_btn0 setHidden:NO];
        [_btn0 setSelected:NO];
        [_btn1 setHidden:NO];
        [_btn1 setSelected:NO];
        [_btn2 setHidden:NO];
        [_btn2 setSelected:NO];
        [_btn3 setHidden:NO];
        [_btn3 setSelected:NO];
            [_btn4 setHidden:NO];
            [_btn4 setSelected:YES];
            [_btn5 setHidden:YES];
            [_btn5 setSelected:YES];
            [_btn6 setHidden:YES];
            [_btn6 setSelected:YES];
            [_btn7 setHidden:YES];
            [_btn7 setSelected:YES];
            [_btn8 setHidden:YES];
            [_btn8 setSelected:YES];
        break;
        case 5:
            [_btn0 setImage:[_imgArray[4] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn1 setImage:[_imgArray[3] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn2 setImage:[_imgArray[2] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn3 setImage:[_imgArray[1] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn4 setImage:[_imgArray[0] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn5 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_btn5 setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
            [_btn0 setHidden:NO];
            [_btn0 setSelected:NO];
            [_btn1 setHidden:NO];
            [_btn1 setSelected:NO];
            [_btn2 setHidden:NO];
            [_btn2 setSelected:NO];
            [_btn3 setHidden:NO];
            [_btn3 setSelected:NO];
            [_btn4 setHidden:NO];
            [_btn4 setSelected:NO];
            [_btn5 setHidden:NO];
            [_btn5 setSelected:YES];
            [_btn6 setHidden:YES];
            [_btn6 setSelected:YES];
            [_btn7 setHidden:YES];
            [_btn7 setSelected:YES];
            [_btn8 setHidden:YES];
            [_btn8 setSelected:YES];
            break;
        case 6:
            [_btn0 setImage:[_imgArray[5] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn1 setImage:[_imgArray[4] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn2 setImage:[_imgArray[3] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn3 setImage:[_imgArray[2] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn4 setImage:[_imgArray[1] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn5 setImage:[_imgArray[0] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn6 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_btn6 setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
            [_btn0 setHidden:NO];
            [_btn0 setSelected:NO];
            [_btn1 setHidden:NO];
            [_btn1 setSelected:NO];
            [_btn2 setHidden:NO];
            [_btn2 setSelected:NO];
            [_btn3 setHidden:NO];
            [_btn3 setSelected:NO];
            [_btn4 setHidden:NO];
            [_btn4 setSelected:NO];
            [_btn5 setHidden:NO];
            [_btn5 setSelected:NO];
            [_btn6 setHidden:NO];
            [_btn6 setSelected:YES];
            [_btn7 setHidden:YES];
            [_btn7 setSelected:YES];
            [_btn8 setHidden:YES];
            [_btn8 setSelected:YES];
            break;
        case 7:
            [_btn0 setImage:[_imgArray[6] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn1 setImage:[_imgArray[5] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn2 setImage:[_imgArray[4] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn3 setImage:[_imgArray[3] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn4 setImage:[_imgArray[2] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn5 setImage:[_imgArray[1] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn6 setImage:[_imgArray[0] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn7 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_btn7 setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
            [_btn0 setHidden:NO];
            [_btn0 setSelected:NO];
            [_btn1 setHidden:NO];
            [_btn1 setSelected:NO];
            [_btn2 setHidden:NO];
            [_btn2 setSelected:NO];
            [_btn3 setHidden:NO];
            [_btn3 setSelected:NO];
            [_btn4 setHidden:NO];
            [_btn4 setSelected:NO];
            [_btn5 setHidden:NO];
            [_btn5 setSelected:NO];
            [_btn6 setHidden:NO];
            [_btn6 setSelected:NO];
            [_btn7 setHidden:NO];
            [_btn7 setSelected:YES];
            [_btn8 setHidden:YES];
            [_btn8 setSelected:YES];
            break;
        case 8:
            [_btn0 setImage:[_imgArray[7] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn1 setImage:[_imgArray[6] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn2 setImage:[_imgArray[5] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn3 setImage:[_imgArray[4] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn4 setImage:[_imgArray[3] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn5 setImage:[_imgArray[2] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn6 setImage:[_imgArray[1] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn7 setImage:[_imgArray[0] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn8 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_btn8 setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
            [_btn0 setHidden:NO];
            [_btn0 setSelected:NO];
            [_btn1 setHidden:NO];
            [_btn1 setSelected:NO];
            [_btn2 setHidden:NO];
            [_btn2 setSelected:NO];
            [_btn3 setHidden:NO];
            [_btn3 setSelected:NO];
            [_btn4 setHidden:NO];
            [_btn4 setSelected:NO];
            [_btn5 setHidden:NO];
            [_btn5 setSelected:NO];
            [_btn6 setHidden:NO];
            [_btn6 setSelected:NO];
            [_btn7 setHidden:NO];
            [_btn7 setSelected:NO];
            [_btn8 setHidden:NO];
            [_btn8 setSelected:YES];
            break;
        case 9:
            [_btn0 setImage:[_imgArray[8] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn1 setImage:[_imgArray[7] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn2 setImage:[_imgArray[6] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn3 setImage:[_imgArray[5] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn4 setImage:[_imgArray[4] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn5 setImage:[_imgArray[3] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn6 setImage:[_imgArray[2] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn7 setImage:[_imgArray[1] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn8 setImage:[_imgArray[0] objectForKey:@"img"] forState:UIControlStateNormal];
            [_btn0 setHidden:NO];
            [_btn0 setSelected:NO];
            [_btn1 setHidden:NO];
            [_btn1 setSelected:NO];
            [_btn2 setHidden:NO];
            [_btn2 setSelected:NO];
            [_btn3 setHidden:NO];
            [_btn3 setSelected:NO];
            [_btn4 setHidden:NO];
            [_btn4 setSelected:NO];
            [_btn5 setHidden:NO];
            [_btn5 setSelected:NO];
            [_btn6 setHidden:NO];
            [_btn6 setSelected:NO];
            [_btn7 setHidden:NO];
            [_btn7 setSelected:NO];
            [_btn8 setHidden:NO];
            [_btn8 setSelected:NO];
            break;
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (!sender.selected) { // 按钮图片不是加号，则预览图片
        NSInteger page = sender.tag - 10;
        if (_btn8.selected &&!_btn7.selected &&!_btn6.selected && !_btn5.selected &&!_btn4.selected &&!_btn3.selected && !_btn2.selected && !_btn1.selected && !_btn0.selected) {
            page -= 1;
        }else if (_btn7.selected &&!_btn6.selected && !_btn5.selected &&!_btn4.selected &&!_btn3.selected && !_btn2.selected && !_btn1.selected && !_btn0.selected) {
            page -= 2;
        }else if (_btn6.selected && !_btn5.selected &&!_btn4.selected &&!_btn3.selected  && !_btn2.selected && !_btn1.selected && !_btn0.selected) {
            page -= 3;
        }else if (_btn5.selected &&!_btn4.selected &&!_btn3.selected && !_btn2.selected && !_btn1.selected && !_btn0.selected) {
            page -= 4;
        }else if (_btn4.selected &&!_btn3.selected && !_btn2.selected && !_btn1.selected && !_btn0.selected) {
            page -= 5;
        }else if (_btn3.selected && !_btn2.selected && !_btn1.selected && !_btn0.selected) {
            page -= 6;
        }
        else if (_btn2.selected && !_btn1.selected && !_btn0.selected) {
            page -= 7;
        }
        else if (_btn1.selected && !_btn0.selected) {
            page -= 8;
        }
        if (_imgArray.count) {
            CGPoint orignPoint = [sender convertPoint:CGPointZero toView:self.view];
            UIScrollView *imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(orignPoint.x, orignPoint.y, 30, 30)];
            [imgScrollView setContentSize:CGSizeMake(_imgArray.count * self.view.bounds.size.width,self.view.bounds.size.height)];
            [imgScrollView setContentOffset:CGPointZero animated:NO];
            [imgScrollView setContentOffset:CGPointMake(page * mainScreenWidth, 0)];
            [imgScrollView setDelegate:self];
            [imgScrollView setPagingEnabled:YES];
            [imgScrollView setAlpha:0];
            for (NSInteger i = 0; i < _imgArray.count; i++) {
                UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(i * mainScreenWidth, 0, mainScreenWidth, mainScreenheight)];
                CGRect frame = bgView.bounds;
                frame.size.width = (page == i) ? 30 : mainScreenWidth;
                frame.size.height = (page == i) ? 30 : mainScreenheight;
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
                [imgView setBackgroundColor:(page == i) ? [UIColor clearColor] : [UIColor blackColor]];
//                [imgView setBackgroundColor:[UIColor blackColor]];
                [imgView setImage:[_imgArray[i] objectForKey:@"img"]];
                [imgView setContentMode:UIViewContentModeScaleAspectFit];
                [imgView setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapped:)];
                [imgView addGestureRecognizer:tapImg];
                UIPinchGestureRecognizer *pinchImage = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imgPinched:)];
                [imgView addGestureRecognizer:pinchImage];
                UIButton *selecterBtn = [[UIButton alloc] initWithFrame:CGRectMake(bgView.bounds.size.width - 50, 40, 40, 40)];
                [selecterBtn setHidden:(page == i) ? YES : NO];
                [selecterBtn setSelected:YES];
                [selecterBtn setImage:[UIImage imageNamed:@"radio_normal"] forState:UIControlStateNormal];
                [selecterBtn setImage:[UIImage imageNamed:@"define_tag"] forState:UIControlStateSelected];
                [selecterBtn addTarget:self action:@selector(selecterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [bgView addSubview:imgView];
                [bgView addSubview:selecterBtn];
                [imgScrollView addSubview:bgView];
            }
            _imgScrollView = imgScrollView;
            [self.view addSubview:_imgScrollView];
        }
        UIImageView *imgView = (UIImageView *)[((UIView *)_imgScrollView.subviews[page]).subviews firstObject];
        CGRect frame = imgView.frame;
        frame.size.width = mainScreenWidth;
        frame.size.height = mainScreenheight;
        [UIView animateWithDuration:0.5 animations:^{
            [_imgScrollView setFrame:[UIScreen mainScreen].bounds];
            [_imgScrollView setAlpha:1];
            [imgView setFrame:frame];
        } completion:^(BOOL finished) {
            [[imgView.superview.subviews lastObject] setHidden:NO];
            [imgView setBackgroundColor:[UIColor blackColor]];
            [_imgScrollView setBackgroundColor:[UIColor blackColor]];
        }];
    }
    else {
        [self showPictureSelection];
    }
}

// 图片右上角的单选按钮被点击
- (void)selecterBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    UIImage *img = ((UIImageView *)[sender.superview.subviews firstObject]).image;
    if (sender.selected) {
        // 需要保留此图片
        if ([_imgRemoveArray containsObject:img]) { // 此图片在需要删除的图片数组中则删除
            [_imgRemoveArray removeObject:img];
       }
    }
    else {
        // 需要删除此图片
        if (![_imgRemoveArray containsObject:img]) { // 如果不在需要删除图片数组中则添加
            [_imgRemoveArray addObject:img];

        }
    }
}


- (void)imgTapped:(UITapGestureRecognizer *)sender {

   UIImageView *tappedView = ((UIImageView *)sender.view);
    CGPoint orignForReduce;
    NSInteger currentImageIndex = tappedView.superview.frame.origin.x / mainScreenWidth;
    switch (currentImageIndex) {
        case 0:
            orignForReduce = [_btn8 convertPoint:CGPointZero toView:tappedView.superview];
            break;
        case 1:
            orignForReduce = [_btn7 convertPoint:CGPointZero toView:tappedView.superview];
            break;
        case 2:
            orignForReduce = [_btn6 convertPoint:CGPointZero toView:tappedView.superview];
            break;
        case 3:
            orignForReduce = [_btn5 convertPoint:CGPointZero toView:tappedView.superview];
            break;
        case 4:
            orignForReduce = [_btn4 convertPoint:CGPointZero toView:tappedView.superview];
            break;
        case 5:
            orignForReduce = [_btn3 convertPoint:CGPointZero toView:tappedView.superview];
            break;
        case 6:
            orignForReduce = [_btn2 convertPoint:CGPointZero toView:tappedView.superview];
            break;
        case 7:
            orignForReduce = [_btn1 convertPoint:CGPointZero toView:tappedView.superview];
            break;
        case 8:
            orignForReduce = [_btn0 convertPoint:CGPointZero toView:tappedView.superview];
            break;
    }
    [_imgScrollView setBackgroundColor:[UIColor clearColor]];
    [tappedView setBackgroundColor:[UIColor clearColor]];
    [UIView animateWithDuration:0.5 animations:^{
        [_imgScrollView setAlpha:0];
        [tappedView setFrame:CGRectMake(orignForReduce.x, orignForReduce.y, 30, 30)];
        [[tappedView.superview.subviews lastObject] setHidden:YES];
        
  
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in _imgArray) {
                [arr addObject:[dict objectForKey:@"img"]];
            }
            
            for (NSInteger i = 0; i < _imgRemoveArray.count; i++) {
                UIImage *img = _imgRemoveArray[i];
                
                if ([arr containsObject:img]) {
                    // 找到需要删除的图片则删除
                    for (int k = 0; k<_imgArray.count; k++) {
                        if ( [_imgArray[k] objectForKey:@"img"] == img ) {
                            // 记录呗删除的pid
                            if ( [_imgArray[k] objectForKey:@"pid"] ) {
                                [_pidsRemoveArray addObject:[_imgArray[k] objectForKey:@"pid"]];
                            }
                            [_imgArray removeObjectAtIndex:k];
                        }
                    }
                }
            }
            [_imgScrollView removeFromSuperview];
            [self showPicture];
            
            _imgRemoveArray = [NSMutableArray array];
        
        
        
        
    } completion:^(BOOL finished) {
        
//        NSMutableArray *arr = [[NSMutableArray alloc] init];
//        for (NSDictionary *dict in _imgArray) {
//            [arr addObject:[dict objectForKey:@"img"]];
//        }
//        
//        for (NSInteger i = 0; i < _imgRemoveArray.count; i++) {
//            UIImage *img = _imgRemoveArray[i];
//            
//            if ([arr containsObject:img]) {
//                // 找到需要删除的图片则删除
//                for (int k = 0; k<_imgArray.count; k++) {
//                    if ( [_imgArray[k] objectForKey:@"img"] == img ) {
//                        // 记录呗删除的pid
//                        if ( [_imgArray[k] objectForKey:@"pid"] ) {
//                            [_pidsRemoveArray addObject:[_imgArray[k] objectForKey:@"pid"]];
//                        }
//                        [_imgArray removeObjectAtIndex:k];
//                    }
//                }
//            }
//        }
//        [_imgScrollView removeFromSuperview];
//        [self showPicture];
//        
//        _imgRemoveArray = [NSMutableArray array];
    }];
    NSInteger i = _imgArray.count;
    [self showPicture];
    [self modifyTheSize];
}

- (void)imgPinched:(UIPinchGestureRecognizer *)sender {
    sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale);
    sender.scale = 1;


}
- (void)showPictureSelection {
    pictureAlert = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"pictureView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    [pictureAlert setCornerRadius:8.0];
    
    CGRect width = taskFilter.frame;
    width.size.width = mainScreenWidth - 20;
    taskFilter.frame = width;
    
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

#pragma mark - scroll delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewPageSetter];
}

- (void)scrollViewPageSetter {
    CGFloat offset = _imgScrollView.contentOffset.x;
    CGFloat page = 0;
    if (offset <= 0 && _imgArray.count >= 1) {
        page = 0;
    }
    else if (offset >= mainScreenWidth && offset < mainScreenWidth * 2 && _imgArray.count >= 2) {
        page = 1;
    }
    else if (offset >= mainScreenWidth * 2 && offset < mainScreenWidth * 3 && _imgArray.count >= 3) {
        page = 2;
    }
    else if (offset >= mainScreenWidth * 3 && offset < mainScreenWidth * 4 && _imgArray.count >= 3) {
        page = 3;
    }
    else if (offset >= mainScreenWidth * 4 && offset < mainScreenWidth * 5 && _imgArray.count >= 3) {
        page = 4;
    }
    else if (offset >= mainScreenWidth * 5 && offset < mainScreenWidth * 6 && _imgArray.count >= 3) {
        page = 5;
    }
    else if (offset >= mainScreenWidth * 6 && offset < mainScreenWidth * 7 && _imgArray.count >= 3) {
        page = 6;
    }
    else if (offset >= mainScreenWidth * 7 && offset < mainScreenWidth * 8 && _imgArray.count >= 3) {
        page = 7;
    }
    
    else if (offset >= mainScreenWidth * 8 && _imgArray.count == 9) {
        page = 8;
    }
    [_imgScrollView setContentOffset:CGPointMake(page * mainScreenWidth, 0) animated:YES];
}

#pragma mark - UIImagePicker delegate
// 从相册或者相机得到图片后的回调方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:image forKey:@"img"];
    
    [_imgArray insertObject:dict atIndex:0];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self showPicture];
//    if([imgArray count] > 0) {
//        self.addPicLabel.hidden = YES;
//    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (NSUInteger i = 0; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:tempImg forKey:@"img"];
        
        [_imgArray insertObject:dict atIndex:0];
    }
    [self showPicture];
//    if([_imgArray count] > 0) {
//        self.addPicLabel.hidden = YES;
//    }
}
#pragma mark - ASIRequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_USER_SKILL]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            self.skills = [dic objectForKey:@"skills"];
        }else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_CREATE_SKILL]){
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            // 发布技能成功
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            [self.postDic removeAllObjects];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            // 发送通知，去任务详情页
            NSString *sid = [dic objectForKey:@"sid"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"skillPublishSucceed" object:sid];
        }
        else {
            [ghunterRequester noMsg];
        }
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_CHANGE_SKILL]){
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            [self.postDic removeAllObjects];
            ghunterSkillViewController *task = [[ghunterSkillViewController alloc] init];
            NSDictionary* infoDic = [self.skillDic objectForKey:@"info"];
            task.skillid=[infoDic objectForKey:@"sid"];
            task.callBackBlock = ^{
                if (!self.releasingSkill) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else if (self.releasingSkill) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            };
            [MobClick event:UMEVENT_CHANGE_SKILL];
            [self.navigationController pushViewController:task animated:YES];
        }
        else {
            [ghunterRequester noMsg];
        }
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self endLoad];
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络异常" waitUntilDone:false];
}
#pragma mark - Custom Methods

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
    self.loadingView = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - catalogNotification
- (void)addSkillCatOK:(NSNotification *)notification{
    NSDictionary *dic = (NSDictionary *)[notification object];
    
    self.chooseTF.text = [dic objectForKey:@"skillName"];
    self.skillTF.text = [dic objectForKey:@"skillName"];
    [self.postDic setObject:[dic objectForKey:@"sid"] forKey:@"cid"];
}

- (IBAction)backBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    if ((self.skillTF.text.length != 0) || (self.chooseTF.text.length != 0) || (self.addGoldTF.text.length != 0) || (self.contentTextView.text.length != 0)) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        
        NSString *title = @"确定要取消发布技能吗?";
        if (self.skillDic.count) {
            title = @"确定要取消修改技能吗?";
        }
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [actionSheet showInView:self.view];
    }else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        if(self.skillDic.count)
        {
            // 取消修改技能
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            // 取消发布技能
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }else if (buttonIndex == 1){
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}


#pragma mark --- 发布技能 ---
- (IBAction)releaseBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    if (_imgArray.count <=0 ) {
        [ghunterRequester showTip:@"至少上传一张技能图片"];
        return;
    }
//    if([self.skillTF.text length]==0)
//    {
//        [ghunterRequester showTip:@"请输入技能标题"];
//        return;
//    }
    if([self.contentTextView.text length] <= 15){
        [ghunterRequester showTip:@"技能详情至少15字"];
        return;
    }
    if ([self.addGoldTF.text floatValue] < 1) {
        [ghunterRequester showTip:@"请输入正确的技能标价"];
        return;
    }
    if(self.addGoldTF.text.length==0) {
        [ghunterRequester showTip:@"请输入正确的技能标价"];
        return;
    }
    // 选择分类
    if(self.chooseTF.text.length)
    {
        // 代表已经设置了发布的技能类型
        // NSLog(@"skillcid =====  %@", [self.postDic objectForKey:@"cid"]);
    }
    else
    {
        [ghunterRequester showTip:@"请选择技能类型"];
        return;
    }
    
    [self startLoad];
    self.releaseNow = YES;
    if(self.btnTitle.length!=0)
    {
        [self.postDic setObject:self.btnTitle forKey:@"priceunit"];
    }
    else
    {
         [self.postDic setObject:@"/次" forKey:@"priceunit"];
    }
    [self.postDic setObject:self.skillTF.text forKey:@"skill"];
    [self.postDic setObject:self.addGoldTF.text forKey:@"price"];
    [self.postDic setObject:self.contentTextView.text forKey:@"description"];
    
    [self.postDic setObject:self.serviceButtonLabel.text forKey:@"sev_mode"];
    [self.postDic setObject:self.timeLabel.text forKey:@"sev_time"];
    if (_locationLabel.text.length!=0) {
        [self.postDic setObject:self.locationLabel.text forKey:@"sev_location"];

    }else
    {
        [self.postDic setObject:@"无限制"forKey:@"sev_location"];

    }

    [self.postDic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
    [_postDic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
    
    if(self.skillDic.count!=0)
    {
        // 修改技能
        NSDictionary* infoDic = [self.skillDic objectForKey:@"info"];
        
        NSString *lastStr = [@"?sid=" stringByAppendingString:[infoDic objectForKey:@"sid"]];
        NSString *urlStr = [URL_CHANGE_SKILL stringByAppendingString:lastStr];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        //创建http请求
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
        [request setRequestMethod:HTTP_METHOD_POST];
        [request setPostValue:API_TOKEN_NUM forKey:API_TOKEN];
        
        if ( ![[self.postDic objectForKey:@"cid"] isEqualToString:[infoDic objectForKey:@"cid"]] ) {
            [request setPostValue:[self.postDic objectForKey:@"cid"] forKey:@"cid"];
        }
        if ( ![[self.postDic objectForKey:@"skill"] isEqualToString:[infoDic objectForKey:@"skill"]] ) {
            [request setPostValue:[self.postDic objectForKey:@"skill"] forKey:@"skill"];
        }
        if ( ![[self.postDic objectForKey:@"price"] isEqualToString:[infoDic objectForKey:@"price"]] ) {
            [request setPostValue:[self.postDic objectForKey:@"price"] forKey:@"price"];
        }
        if ( ![[self.postDic objectForKey:@"description"] isEqualToString:[infoDic objectForKey:@"description"]] ) {
            [request setPostValue:[self.postDic objectForKey:@"description"] forKey:@"description"];
        }
        if ( ![[self.postDic objectForKey:@"priceunit"] isEqualToString:[infoDic objectForKey:@"priceunit"]] ) {
            [request setPostValue:[self.postDic objectForKey:@"priceunit"] forKey:@"priceunit"];
        }
        
        
        if ( ![[self.postDic objectForKey:@"sev_mode"] isEqualToString:[infoDic objectForKey:@"sev_mode"]] ) {
            [request setPostValue:[self.postDic objectForKey:@"sev_mode"] forKey:@"sev_mode"];
        }
        if ( ![[self.postDic objectForKey:@"sev_time"] isEqualToString:[infoDic objectForKey:@"sev_time"]] ) {
            [request setPostValue:[self.postDic objectForKey:@"sev_time"] forKey:@"sev_time"];
        }
        if ( ![[self.postDic objectForKey:@"sev_location"] isEqualToString:[infoDic objectForKey:@"sev_location"]] ) {
            [request setPostValue:[self.postDic objectForKey:@"sev_location"] forKey:@"sev_location"];
        }
        [request setPostValue:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
        [request setPostValue:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        // 如果有删除图片的情况
        // 如果有删除图片，则需要提交 delete
        if ( [_pidsRemoveArray count] > 0 ) {
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_pidsRemoveArray
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
            [request setPostValue:jsonString forKey:@"delete"];
        }
        //  如果有添加图片，则需要提交  addImages[]
        for (NSUInteger i = 0; i < [_imgArray count]; i++) {
            if ( [_imgArray[i] valueForKey:@"pid"] == nil ) {
                // 没有pid的图片，是需要添加提交给服务器的
                NSData* imageData = UIImageJPEGRepresentation([[_imgArray objectAtIndex:i] objectForKey:@"img"], 0.5);
                [request addData:imageData withFileName:[NSString stringWithFormat:@"photo%zd.jpg", i] andContentType:@"image/jpg" forKey:@"addImages[]"];
            }
        }
        if([ghunterRequester getApi_session_id]) {
            [request setPostValue:[ghunterRequester getApi_session_id] forKey:@"api_session_id"];
        }
        // 上传进度委托
        request.uploadProgressDelegate = self;
        request.showAccurateProgress = YES;
        [request setDelegate:self];
        // 提交给修改技能的接口
        request.userInfo = [NSDictionary dictionaryWithObject:REQUEST_FOR_CHANGE_SKILL forKey:REQUEST_TYPE];
        [request startAsynchronous];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:URL_CREATE_SKILL];
        //创建http请求
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
        [request setRequestMethod:HTTP_METHOD_POST];
        [request setPostValue:API_TOKEN_NUM forKey:API_TOKEN];
        
        [request setPostValue:[self.postDic objectForKey:@"cid"] forKey:@"cid"];
        [request setPostValue:self.skillTF.text forKey:@"skill"];
        [request setPostValue:self.addGoldTF.text forKey:@"price"];
        [request setPostValue:self.contentTextView.text forKey:@"description"];
        
        
        
        [request setPostValue: ServiceNum forKey:@"sev_mode"];
        [request setPostValue: ServiceTimeNum forKey:@"sev_time"];
        [request setPostValue:self.locationLabel.text forKey:@"sev_location"];

        
        [request setPostValue:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
        [request setPostValue:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        [request setPostValue:[self.postDic objectForKey:@"priceunit"] forKey:@"priceunit"];
        
        for (NSUInteger i = 0; i < [_imgArray count]; i++) {
            // NSData* imageData = UIImagePNGRepresentation([imgArray objectAtIndex:i]);
            NSData* imageData=UIImageJPEGRepresentation([[_imgArray objectAtIndex:i] objectForKey:@"img"], 0.5);
            [request addData:imageData withFileName:[NSString stringWithFormat:@"photo%zd.jpg", i] andContentType:@"image/jpg" forKey:@"images[]"];
        }
//          [request setPostValue:jsonString forKey:@"skill"];
        if([ghunterRequester getApi_session_id]) {
            [request setPostValue:[ghunterRequester getApi_session_id] forKey:@"api_session_id"];
        }
        // 上传进度委托
        request.uploadProgressDelegate = self;
        request.showAccurateProgress = YES;
        [request setDelegate:self];
        request.userInfo = [NSDictionary dictionaryWithObject:REQUEST_FOR_CREATE_SKILL forKey:REQUEST_TYPE];
        [request startAsynchronous];
    }
}
- (IBAction)chooseKindBtn:(UIButton *)sender {
    ghunterAddSkillCatalogViewController *skillKind = [[ghunterAddSkillCatalogViewController alloc] init];
    [self.navigationController pushViewController:skillKind animated:YES];
}

// 选择单位的点击事件
- (IBAction)priceUnitBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    unitAlert = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth - 20, 150)];
    CGRect bgFrame = bg.frame;
    UIView *bgImg = [[UIView alloc] initWithFrame:bgFrame];
    bgImg.backgroundColor = [UIColor whiteColor];
    bgImg.alpha = 0.7;
    bgImg.clipsToBounds = YES;
    bgImg.layer.cornerRadius = Radius;
    _pickerView= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, mainScreenWidth - 20, 110)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    [_pickerView selectRow:2 inComponent:0 animated:YES];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0] forState:UIControlStateNormal];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(bg.frame.size.width - 50,0 ,50 ,40)];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0] forState:UIControlStateNormal];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, bg.frame.size.width, 0.5)];
    [line setBackgroundColor:[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0]];
    [bg addSubview:bgImg];
    [bg addSubview:leftButton];
    [bg addSubview:rightButton];
    [bg addSubview:line];
    [bg addSubview:_pickerView];
    unitAlert.containerFrame = CGRectMake((mainScreenWidth - bgFrame.size.width) / 2.0, mainScreenheight - bgFrame.size.height - 10, bgFrame.size.width, bgFrame.size.height);
    unitAlert.showView = bg;
    unitAlert.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    unitAlert.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [unitAlert show];
}
- (void)cancel{
    [unitAlert dismissAnimated:YES];
}

- (void)confirm
{
    NSUInteger unitSelected = [self.pickerView selectedRowInComponent:0];
    self.btnTitle=[self.unitArr objectAtIndex:unitSelected];
    NSString* str=[NSString stringWithFormat:@"%@",self.btnTitle];;
    [self.unitBtn setTitle:str forState:UIControlStateNormal];
    [unitAlert dismissAnimated:YES];
}
#pragma mark - pickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.unitArr.count;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.unitArr objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.btnTitle=[self.unitArr objectAtIndex:row];
}

// 继承的方法
-(void)tapImageViewTappedWithObject:(id)sender{
    
    
}
- (IBAction)PriceAction:(id)sender {
    if (PriceView) {
        [PriceView removeFromSuperview];
        [self priceView];
        
    }else
    {
        [self  priceView];
    }
    PriceBackView.hidden = !PriceBackView.hidden;
}
- (IBAction)ServiceAction:(UIButton *)sender {
    if (ServiceView) {
        [ServiceView removeFromSuperview];
        [self serviceView];
        
    }else
    {
        [self  serviceView];
    }
    backView.hidden = !backView.hidden;
}
-(void)priceView
{
    PriceBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
    UIView *imageAngle = [[UIView alloc]initWithFrame:CGRectMake(_Service.frame.origin.x+63,_unitBtn.frame.origin.y+65-skillScrollView.contentOffset.y, 14, 14)];
    UIImageView *timeAngle = [[UIImageView alloc]initWithFrame:CGRectMake(2,4,10, 6)];
    [timeAngle setImage:[UIImage imageNamed:@"back上@3x.png"]];
    imageAngle.backgroundColor = [UIColor whiteColor];
    PriceView = [[UIView alloc]initWithFrame:CGRectMake(_Service.frame.origin.x-5,_unitBtn.frame.origin.y+86-skillScrollView.contentOffset.y, 78, 125)];
    CALayer *layer = [PriceView layer];
    layer.shadowOffset = CGSizeMake(0, 2);
    layer.shadowRadius = 6.0;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.8;
    
    PriceView.layer.borderColor = [[UIColor colorWithRed:235 green:235 blue:235 alpha:0.5]CGColor] ;
    [PriceView.layer setBorderWidth:0.8];
    
    PriceView.backgroundColor = [UIColor whiteColor];
    NSArray *serviceArray = @[@"/小时",@"/天",@"/次",@"/场",@"/晚"];
    PriceView.hidden = NO;
    PriceBackView.hidden = YES;
    int i = 0;
    for (NSString *serviceStr in serviceArray) {
        if (i==0) {
            
        }else
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 25*i, PriceView.frame.size.width, 0.5)];
            label.backgroundColor = RGBCOLOR(235, 235, 235);
            
            [PriceView addSubview:label];
        }
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 25*i,PriceView.frame.size.width, 25)];
        [button setTitle:serviceStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor]forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(pictureViewAction:) forControlEvents:UIControlEventTouchUpInside];
        i++;
        [PriceView addSubview:button];
    }
    [imageAngle addSubview:timeAngle];
    [PriceBackView addSubview:imageAngle];
    [PriceBackView addSubview:PriceView];
    [self.view addSubview:PriceBackView];
}
-(void)serviceView
{
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
    UIView *modelAngleBg = [[UIView alloc]initWithFrame:CGRectMake(_Service.frame.origin.x+63,_ServiceBgView.frame.origin.y+75-skillScrollView.contentOffset.y, 14, 14)];
    UIImageView *modelAngle = [[UIImageView alloc]initWithFrame:CGRectMake(2,4,10, 6)];
    [modelAngle setImage:[UIImage imageNamed:@"back上@3x.png"]];
    modelAngleBg.backgroundColor = [UIColor whiteColor];
    ServiceView = [[UIView alloc]initWithFrame:CGRectMake(_Service.frame.origin.x-5,_ServiceBgView.frame.origin.y+96-skillScrollView.contentOffset.y, 78, 100)];
    CALayer *layer = [ServiceView layer];
    layer.shadowOffset = CGSizeMake(0, 2);
    layer.shadowRadius = 6.0;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.8;
    ServiceView.backgroundColor = [UIColor whiteColor];
    NSArray *serviceArray = @[@"线上服务",@"线下服务",@"邮寄给你",@"找我自取"];
    ServiceView.hidden = NO;
    backView.hidden = YES;
    int i = 0;
    for (NSString *serviceStr in serviceArray) {
        if (i==0) {
            
        }else
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 25*i, ServiceView.frame.size.width, 0.5)];
            label.backgroundColor =RGBCOLOR(235, 235, 235);
            
            [ServiceView addSubview:label];
        }
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 25*i,ServiceView.frame.size.width, 25)];
        [button setTitle:serviceStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor]forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(serviceViewAction:) forControlEvents:UIControlEventTouchUpInside];
        i++;
        [ServiceView addSubview:button];
    }
    [modelAngleBg addSubview:modelAngle];
    [backView addSubview:modelAngleBg];
    [backView addSubview:ServiceView];
    [self.view addSubview:backView];
}
-(void)pictureViewAction:(UIButton *)pictureButton
{
    self.btnTitle=[self.unitArr objectAtIndex:pictureButton.tag];

    if (pictureButton.tag == 0) {
        
        [_unitBtn setTitle:pictureButton.titleLabel.text forState:UIControlStateNormal];
        ServiceNum = @"1";
        PriceBackView.hidden = YES;
        
    }else if (pictureButton.tag == 1)
    {
        [_unitBtn setTitle:pictureButton.titleLabel.text forState:UIControlStateNormal];
        ServiceNum = @"2";
        PriceBackView.hidden = YES;

        
    }else if (pictureButton.tag == 2)
    {
        [_unitBtn setTitle:pictureButton.titleLabel.text forState:UIControlStateNormal];
        ServiceNum = @"3";
        PriceBackView.hidden = YES;

     }else
    {
        [_unitBtn setTitle:pictureButton.titleLabel.text forState:UIControlStateNormal];
        ServiceNum = @"4";
        PriceBackView.hidden = YES;

    }
    NSString *str = _serviceButtonLabel.text;
}
-(void)serviceViewAction:(UIButton *)serviceButton
{
    if (serviceButton.tag == 0) {
        _serviceButtonLabel.text = serviceButton.titleLabel.text;
        ServiceNum = @"1";
        _ServiceTimeView.hidden = NO;
        _ServiceLocationView.hidden = YES;
        backView.hidden = YES;
        self.releaseSkill.frame = CGRectMake(10, self.skillContentView.frame.origin.y + self.skillContentView.frame.size.height + 10+90, mainScreenWidth - 20, self.releaseSkill.frame.size.height);

    }else if (serviceButton.tag == 1)
    {
        _serviceButtonLabel.text = serviceButton.titleLabel.text;
        ServiceNum = @"2";

        _ServiceLocationView.hidden = NO;
        _ServiceTimeView.hidden = NO;
        backView.hidden = YES;
        self.releaseSkill.frame = CGRectMake(10, self.skillContentView.frame.origin.y + self.skillContentView.frame.size.height +self.ServiceTimeView.frame.size.height+ 10+90, mainScreenWidth - 20, self.releaseSkill.frame.size.height);

    }else if (serviceButton.tag == 2)
    {
        _serviceButtonLabel.text = serviceButton.titleLabel.text;
        ServiceNum = @"3";

        _ServiceLocationView.hidden = YES;
        _ServiceTimeView.hidden = YES;
        backView.hidden = YES;
self.releaseSkill.frame = CGRectMake(10, self.skillContentView.frame.origin.y + self.skillContentView.frame.size.height + 10+55, mainScreenWidth - 20, self.releaseSkill.frame.size.height);
    }else
    {
        _serviceButtonLabel.text = serviceButton.titleLabel.text;
        ServiceNum = @"4";

        _ServiceLocationView.hidden = NO;
        _ServiceTimeView.hidden = NO;
        backView.hidden = YES;
self.releaseSkill.frame = CGRectMake(10, self.skillContentView.frame.origin.y + self.skillContentView.frame.size.height +self.ServiceTimeView.frame.size.height+ 10+90, mainScreenWidth - 20, self.releaseSkill.frame.size.height);
    }
    NSString *str = _serviceButtonLabel.text;
}

- (IBAction)ServiceLocationAction:(id)sender {
    [self popSeviceLocationView];
}

- (IBAction)ServiceTimeAction:(id)sender {
    [self popSeviceTimeView];

}
//地区底部弹框
-(void)popSeviceLocationView
{
    pictureAlert = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SeviceLocationView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter.backgroundColor = [UIColor yellowColor];
    taskFilter = [nibs objectAtIndex:0];
    
    CGRect width = taskFilter.frame;
    width.size.width = mainScreenWidth - 20;
    taskFilter.frame = width;
    
    CGRect taskfilterFrame = taskFilter.frame;
    pictureAlert.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height), taskfilterFrame.size.width, taskfilterFrame.size.height);
    pictureAlert.showView = taskFilter;
    UIView  *cellviewbg = (UIView *)[taskFilter viewWithTag:33];
    UIButton *cancelGold = (UIButton *)[taskFilter viewWithTag:2];
    UIButton *determine = (UIButton *)[taskFilter viewWithTag:3];
    goldTF = (UITextField *)[taskFilter viewWithTag:7];
    UILabel *otherLocation = (UILabel *)[taskFilter viewWithTag:10];
    
    CGRect cellviewbgwidth = cellviewbg.frame;
    cellviewbgwidth.size.width = mainScreenWidth - 20;
    cellviewbg.frame = cellviewbgwidth;
    
    goldTF.text = [Monitor sharedInstance].addres;
    goldTF.returnKeyType = UIReturnKeyDone;
    goldTF.delegate = self;
    goldTF.tag = 101;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(otherLocation)];
    [otherLocation setUserInteractionEnabled:YES];
    [otherLocation addGestureRecognizer:tap];
    [cancelGold addTarget:self action:@selector(cancelGold_pic) forControlEvents:UIControlEventTouchUpInside];
    [determine addTarget:self action:@selector(determine_pic) forControlEvents:UIControlEventTouchUpInside];
    
    pictureAlert.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    [pictureAlert show];
}
-(void)otherLocation
{
    goldTF.text = @"";
}
//时间底部弹框
-(void)popSeviceTimeView
{
    pictureAlert = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SeviceTime" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter.backgroundColor = [UIColor yellowColor];
    taskFilter = [nibs objectAtIndex:0];
    
    CGRect width = taskFilter.frame;
    width.size.width = mainScreenWidth - 20;
    taskFilter.frame = width;
    
    CGRect taskfilterFrame = taskFilter.frame;
    pictureAlert.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height), taskfilterFrame.size.width, taskfilterFrame.size.height);
    pictureAlert.showView = taskFilter;
    
  
    UIButton *cancelGold = (UIButton *)[taskFilter viewWithTag:2];
    UIButton *determine = (UIButton *)[taskFilter viewWithTag:3];
   

    for (int i=0; i<4; i++) {
        UIButton *button = (UIButton *)[taskFilter viewWithTag:i+4];
        [button addTarget:self action:@selector(timeSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    imageOne = (UIImageView *)[taskFilter viewWithTag:14];
    imageOne.hidden = YES;
    imageTwo = (UIImageView *)[taskFilter viewWithTag:15];
    imageTwo.hidden = YES;
    imageThree = (UIImageView *)[taskFilter viewWithTag:16];
    imageThree.hidden = YES;
    imageFour = (UIImageView *)[taskFilter viewWithTag:17];
    imageFour.hidden = YES;
    [cancelGold addTarget:self action:@selector(cancelGold_pic) forControlEvents:UIControlEventTouchUpInside];
    [determine addTarget:self action:@selector(determine_time:) forControlEvents:UIControlEventTouchUpInside];
    
    pictureAlert.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    [pictureAlert show];
}
//时间段选择
-(void)timeSelectAction:(UIButton *)timeButton
{
    
    
    
    if (_timeButtonArray.count == 0) {

        [_timeButtonArray addObject:timeButton];

    }else if (_timeButtonArray.count == 2)
    {
        if (_timeButtonArray[0]!=timeButton&&_timeButtonArray[1]!=timeButton) {
            [_timeButtonArray addObject:timeButton];

        }else{
            [_timeButtonArray removeObject:timeButton];
        }
    }else if (_timeButtonArray.count == 3)
    {

        if (_timeButtonArray[0]!=timeButton&&_timeButtonArray[1]!=timeButton&&_timeButtonArray[2]!=timeButton) {
            [_timeButtonArray removeAllObjects];
            
        }else{
            [_timeButtonArray removeObject:timeButton];
        }
    }else if (_timeButtonArray.count == 1){
        for (UIButton *button in _timeButtonArray) {
            if (button == timeButton) {
                [_timeButtonArray removeObject:button];
            }else{
                [_timeButtonArray addObject:timeButton];

            }
        }
        
    }
    if (timeButton.tag==4) {
        imageOne.hidden =!imageOne.hidden;
        imageFour.hidden = YES;
        
    }
    if (timeButton.tag==5) {

        imageTwo.hidden =!imageTwo.hidden;
        imageFour.hidden = YES;
        
    }
    if (timeButton.tag==6) {

        imageThree.hidden =!imageThree.hidden;
        imageFour.hidden = YES;
        
    }
    if (timeButton.tag==7) {

        imageOne.hidden=YES;
        imageTwo.hidden=YES;
        imageThree.hidden=YES;
        imageFour.hidden =!imageFour.hidden;
        [_timeButtonArray removeAllObjects];

    }

}
//时间确定键 调用事件
-(void)determine_time:(UIButton *)timeButton
{
    NSMutableString *string = [[NSMutableString alloc]init];
    if (_timeButtonArray.count == 3||_timeButtonArray.count == 0) {
        ServiceTimeNum = @"1";
        _timeLabel.text = @"无限制";
    }else if (_timeButtonArray.count == 1)
    {
        
   
        for (UIButton *button in _timeButtonArray) {
            _timeLabel.text = button.titleLabel.text;

            
            if (button.tag==4) {
                ServiceTimeNum = @"2";
            }
            if (button.tag==5) {
                ServiceTimeNum = @"3";
                
            }
            if (button.tag==6) {
                ServiceTimeNum = @"4";
                
            }
            if (button.tag==7) {
                ServiceTimeNum = @"1";
                
            }
            
        }
    }
    else if (_timeButtonArray.count == 2)
    {
        UIButton *buttonOne = _timeButtonArray[0];
        UIButton *buttonTwo = _timeButtonArray[1];
        if (buttonOne.tag<buttonTwo.tag) {
            [string appendString:buttonOne.titleLabel.text];
            [string appendString:buttonTwo.titleLabel.text];
            ServiceTimeNum = [NSString stringWithFormat:@"%ld%ld",buttonOne.tag-2,buttonTwo.tag-2];
            _timeLabel.text = string;
        }else
        {
            [string appendString:buttonTwo.titleLabel.text];
            [string appendString:buttonOne.titleLabel.text];
            _timeLabel.text = string;
            ServiceTimeNum = [NSString stringWithFormat:@"%ld%ld",buttonTwo.tag-2,buttonOne.tag-2];

        }
    }else
    {
        
    }
    [_timeButtonArray removeAllObjects];
        [pictureAlert dismissAnimated:YES];
}
//取消按钮调用事件
-(void)cancelGold_pic
{
    ServiceTimeNum = @"1";
    [_timeButtonArray removeAllObjects];
    
    [pictureAlert dismissAnimated:YES];
    
}
//确定按钮调用事件
-(void)determine_pic
{
    UITextField * goldTF = (UITextField *)[pictureAlert viewWithTag:101];
    _locationLabel.text = goldTF.text;
    
    [pictureAlert dismissAnimated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    backView.hidden = YES;
    PriceBackView.hidden = YES;

}

//服务方式选择
-(void)ServicePopView:(UIButton *)Service
{
    
}
@end
