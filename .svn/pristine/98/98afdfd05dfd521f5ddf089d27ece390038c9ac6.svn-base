//
//  ghunterModifyUserInfoViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-20.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//昵称签名设置

#import "ghunterModifyUserInfoViewController.h"

@interface ghunterModifyUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UIView *editBG;
@property (weak, nonatomic) IBOutlet UITextField *text;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) IBOutlet UIView *bg;

@end

@implementation ghunterModifyUserInfoViewController

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
}

- (void)viewDidLoad
{ 
    [super viewDidLoad];
     _bg.backgroundColor = Nav_backgroud;
    // Do any additional setup after loading the view from its nib.
    if(self.type == 0){
        self.descriptionLabel.text = @"为自己设置专属的昵称吧!12字以内";
    }else if (self.type == 1){
        self.descriptionLabel.text = @"为自己设置专属的个性签名吧!20字以内";
    }
    self.editBG.clipsToBounds = YES;
//    self.editBG.layer.cornerRadius = Radius;
    self.text.text = self.content;
    self.text.delegate = self;
    [self.text becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirm:(id)sender {
    if(self.type == 0){
        NSRange range = [self.text.text rangeOfString:@" "];
        if(range.location != NSNotFound){
            [ghunterRequester showTip:@"昵称不可以包含空格~"];
            return;
        }
        if([self.text.text length] == 0){
            [ghunterRequester showTip:@"请填写昵称~"];
            return;
        } else {
            NSString *content = self.text.text;
            NSNotification *notification = [[NSNotification alloc] initWithName:@"modify_name" object:content userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (self.type == 1){
        if([self.text.text length] == 0){
            [ghunterRequester showTip:@"请填写个性签名~"];
            return;
        }else{
            NSString *content = self.text.text;
            NSNotification *notification = [[NSNotification alloc] initWithName:@"modify_signature" object:content userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UITextfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.text resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (self.type == 0 && range.location > 12)
        return NO; // return NO to not change text
    if (self.type == 1 && range.location > 20)
        return NO;
    return YES;
}

@end
