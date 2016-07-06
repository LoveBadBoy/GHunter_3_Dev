//
//  ghunterWithdrawReasonViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-14.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//退款理由

#import "ghunterWithdrawReasonViewController.h"

@interface ghunterWithdrawReasonViewController ()
@property (weak, nonatomic) IBOutlet RadioButton *notFinish;
@property (weak, nonatomic) IBOutlet RadioButton *consultation;
@property (weak, nonatomic) IBOutlet RadioButton *otherReason;
@property (nonatomic) NSInteger selected;
@property (weak, nonatomic) IBOutlet UILabel *lastWithDrawInfoTitle;
@property (weak, nonatomic) IBOutlet UIView *withdrawReason;
@property (weak, nonatomic) IBOutlet UIView *lastWithDrawContent;
@property (weak, nonatomic) IBOutlet UILabel *lastWithdrawReason;
@property (weak, nonatomic) IBOutlet UILabel *lastwithDrawType;
@property (weak, nonatomic) IBOutlet UILabel *lastWithDraw_masterrate;
@property (weak, nonatomic) IBOutlet UILabel *lastWithDraw_hunterrate;

@property (strong, nonatomic) IBOutlet UIView *bg;
@end

@implementation ghunterWithdrawReasonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _bg.backgroundColor = Nav_backgroud;
    // Do any additional setup after loading the view from its nib.
    _withdrawReason.backgroundColor = [UIColor whiteColor];
    _withdrawReason.clipsToBounds = YES;
    _withdrawReason.layer.cornerRadius = 4.0;
    _lastWithDrawContent.clipsToBounds = YES;
    _lastWithDrawContent.layer.cornerRadius  =4.0;
    _lastWithDrawContent.backgroundColor = [UIColor whiteColor];
    self.selected = 1;
    
    self.notFinish.groupId = @"withdrawReason group";
    self.notFinish.index = 1;
    [self.notFinish defaultInitWithnormalImage:[UIImage imageNamed:@"radio_normal"] withClickedImage:[UIImage imageNamed:@"define_tag"] isLeft:YES size:CGSizeMake(self.notFinish.frame.size.width, self.notFinish.frame.size.height) padding:7.0];
    [self.notFinish setChecked:YES];
    self.notFinish.frame = CGRectMake(_withdrawReason.frame.origin.x, self.notFinish.frame.origin.y, self.notFinish.frame.size.width, self.notFinish.frame.size.height);
    self.consultation.groupId = @"withdrawReason group";
    
    self.consultation.index = 2;
    [self.consultation defaultInitWithnormalImage:[UIImage imageNamed:@"radio_normal"] withClickedImage:[UIImage imageNamed:@"define_tag"] isLeft:YES size:CGSizeMake(self.consultation.frame.size.width, self.consultation.frame.size.height)padding:7.0];
    self.otherReason.groupId = @"withdrawReason group";
    self.consultation.frame = CGRectMake(_withdrawReason.frame.origin.x, self.consultation.frame.origin.y, self.consultation.frame.size.width, self.consultation.frame.size.height);
                                         
    self.otherReason.index = 3;
    [self.otherReason defaultInitWithnormalImage:[UIImage imageNamed:@"radio_normal"] withClickedImage:[UIImage imageNamed:@"define_tag"] isLeft:YES size:CGSizeMake(self.otherReason.frame.size.width, self.otherReason.frame.size.height)padding:7.0];
    [RadioButton addObserverForGroupId:@"withdrawReason group" observer:self];
    self.otherReason.frame = CGRectMake(_withdrawReason.frame.origin.x, self.otherReason.frame.origin.y, self.otherReason.frame.size.width, self.otherReason.frame.size.height);
    
    if([self.entranceType isEqualToString:@"normal"]){
        self.lastWithDrawInfoTitle.hidden = YES;
        self.lastWithDrawContent.hidden = YES;
    }else if ([self.entranceType isEqualToString:@"modify"]){
        self.lastWithDrawInfoTitle.hidden = NO;
        self.lastWithDrawContent.hidden = NO;
    }
    NSString *reason,*type;
    if([[self.dic objectForKey:@"reason"] isEqualToString:@"1"]){
        reason = reason1;
    }else if ([[self.dic objectForKey:@"reason"] isEqualToString:@"2"]){
        reason = reason2;
    }else{
        reason = reason3;
    }
    if([[self.dic objectForKey:@"type"] isEqualToString:@"1"]){
        type = @"部分退款";
        [self.lastWithDraw_masterrate setText:[NSString stringWithFormat:@"%@%%",[self.dic objectForKey:@"owner_rate"]]];
        [self.lastWithDraw_hunterrate setText:[NSString stringWithFormat:@"%@%%",[self.dic objectForKey:@"hunter_rate"]]];
    }else{
        type =@"全部退款";
        [self.lastWithDraw_masterrate setText:@"100%"];
        [self.lastWithDraw_hunterrate setText:@"0%"];
    }
    [self.lastWithdrawReason setText:reason];
    [self.lastwithDrawType setText:type];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RadioButton method
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    _selected = index;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    ghunterWithdrawTypeViewController *type = [[ghunterWithdrawTypeViewController alloc] init];
    type.bounty = self.bounty;
    type.selectedReason = self.selected;
    type.tid = self.tid;
    [self.navigationController pushViewController:type animated:YES];
}
@end
