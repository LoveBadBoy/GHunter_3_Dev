//
//  ghunterAboutViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-26.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//关于赏金猎人

#import "ghunterAboutViewController.h"

@interface ghunterAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@end

@implementation ghunterAboutViewController

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
    [_versionLabel setText:[NSString stringWithFormat:@"赏金猎人 %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    [_copyrightLabel setText:[NSString stringWithFormat:@"Copyright@%zd",[dateComponent year]]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)go2Official{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:OFFICIAL]];
}

- (IBAction)go2Weibo:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:OFFICIAL]];
}
- (IBAction)go2RenRen:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WEIBO]];
}

@end
