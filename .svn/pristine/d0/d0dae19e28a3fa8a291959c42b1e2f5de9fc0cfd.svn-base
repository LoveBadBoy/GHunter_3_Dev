//
//  ghunterConvertGoldsViewController.m
//  ghunter
//
//  Created by ImGondar on 15/12/24.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import "ghunterConvertGoldsViewController.h"

@interface ghunterConvertGoldsViewController ()
{
    
    NSMutableDictionary * userInfoDic;
    NSMutableString * goldNumString;
}

- (IBAction)back:(id)sender;

// 充值
- (IBAction)payGold:(id)sender;

// 按钮
- (IBAction)oneGoldClick:(id)sender;
- (IBAction)twoGoldClick:(id)sender;
- (IBAction)threeGoldClick:(id)sender;


@end

@implementation ghunterConvertGoldsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    userInfoDic = [[NSMutableDictionary alloc] init];
    goldNumString = [[NSMutableString alloc] init];
    // Label
    self.balabnceNum.textColor = [UIColor orangeColor];
    self.accountNum.textColor = [UIColor orangeColor];
    self.balabnceNum.textAlignment = NSTextAlignmentLeft;
    self.accountNum.textAlignment = NSTextAlignmentLeft;
    
    // btn
    [self.OneGoldBtn.layer setBorderWidth:1.0f];
    [self.OneGoldBtn.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];
    self.OneGoldBtn.selected = NO;
    [self.TwoGoldBtn.layer setBorderWidth:1.0f];
    [self.TwoGoldBtn.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];
    self.TwoGoldBtn.selected = NO;
    [self.ThreeGoldBtn.layer setBorderWidth:1.0f];
    [self.ThreeGoldBtn.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];
    self.ThreeGoldBtn.selected = NO;
    
    self.goldNumTF.delegate = self;
    self.goldNumTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.goldNumTF.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];
    [self.goldNumTF.layer setBorderWidth:1.0f];
    
    self.rechargeBtn.layer.cornerRadius = 2.0f;
    self.rechargeBtn.clipsToBounds = YES;
    // 加载数据
    [self didGetGoldNumDataIsloading:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 加载网络数据
// 获取金币数据
-(void)didGetGoldNumDataIsloading:(BOOL )isloading{
    
    [AFNetworkTool httpRequestWithUrl:URL_GET_MY_CENTER params:nil success:^(NSData *data) {
       
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
         
            userInfoDic = [result objectForKey:@"user"];
            
            self.balabnceNum.text = [userInfoDic objectForKey:@"coin_balance"];
            self.accountNum.text = [userInfoDic objectForKey:@"balance"];
        }
    } fail:^{
        
    }];
}

- (void) didGetExchangeGoldIsloading:(BOOL) isloading withamount:(NSString *) amountStr{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%@", amountStr] forKey:@"amount"];

    if (amountStr.length == 0) {
        [ProgressHUD show:@"请输入金币"];
        return;
    }
    [AFNetworkTool httpRequestWithUrl:URL_EXCHANGE_GOLD params:parameters success:^(NSData *data) {
       
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([[result objectForKey:@"error"]integerValue] == 0){
            
            [ProgressHUD show:[result objectForKey:@"msg"]];
            
            [self.goldNumTF resignFirstResponder];
            
            [self didGetGoldNumDataIsloading:NO];
            
        }else {
            
            [ProgressHUD show:[result objectForKey:@"msg"]];
            [self.goldNumTF resignFirstResponder];
        }
        
    } fail:^{
        
//        [ProgressHUD show:[result objectForKey:@"msg"]];
    }];
    
}

#pragma mark --- UITExtFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.OneGoldBtn.selected = NO;
    self.TwoGoldBtn.selected = NO;
    self.ThreeGoldBtn.selected = NO;
    [self.ThreeGoldBtn.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];
    [self.OneGoldBtn.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];
    [self.TwoGoldBtn.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];
    self.payGoldLb.text = [NSString stringWithFormat:@"赏金支付：0元"];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.location > 5) {
        
        return NO;
    }
    if (range.location < goldNumString.length) {
        
        goldNumString = [goldNumString substringToIndex:goldNumString.length - 1];
    }
    goldNumString = [goldNumString stringByAppendingString:string];

    if ([string isMatchedByRegex:@"^[0-9]$"]) {
        if (range.location == 0 && [string isEqualToString:@"0"]) {
            self.payGoldLb.text = [NSString stringWithFormat:@"赏金支付：%.2f元", [goldNumString floatValue] / 100];
            return YES;
        } else {
            NSString *regex = @"^[1-9][0-9]*$";
            if([textField.text isMatchedByRegex:regex]){
                self.payGoldLb.text = [NSString stringWithFormat:@"赏金支付：%.2f元", [goldNumString floatValue] / 100];
            
                return YES;
            }
        }
    } else if ([string isEqualToString:@""]){
        self.payGoldLb.text = [NSString stringWithFormat:@"赏金支付：%.2f元", [goldNumString floatValue] / 100];
        return YES;
    } else {
        return NO;
    }
    
    self.payGoldLb.text = [NSString stringWithFormat:@"赏金支付：%.2f元", [goldNumString floatValue] / 100];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.goldNumTF.layer setBorderColor:[UIColor orangeColor].CGColor];

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.goldNumTF.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.goldNumTF resignFirstResponder];
}
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


// 充值
- (IBAction)payGold:(id)sender {
 
    NSString * tmpStr = [[NSString alloc] init];
    if (self.OneGoldBtn.selected == YES) {
        
        tmpStr = @"100";
    }
    else if (self.TwoGoldBtn.selected == YES) {
        
        tmpStr = @"500";
    }
    else if (self.ThreeGoldBtn.selected == YES) {
        
        tmpStr = @"1000";
    }else{
        tmpStr = self.goldNumTF.text;
    }
    [self didGetExchangeGoldIsloading:NO withamount:tmpStr];
}
- (IBAction)oneGoldClick:(id)sender {
    [self.goldNumTF resignFirstResponder];

    [self.OneGoldBtn.layer setBorderColor:RGBCOLOR(234, 85, 20).CGColor];
    [self.TwoGoldBtn.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];
    [self.ThreeGoldBtn.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];
    [self.goldNumTF.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];

    self.OneGoldBtn.selected = YES;
    self.TwoGoldBtn.selected = NO;
    self.ThreeGoldBtn.selected = NO;
    self.goldNumTF.text = @"";
    self.payGoldLb.text = [NSString stringWithFormat:@"赏金支付：1元"];
}

- (IBAction)twoGoldClick:(id)sender {
    [self.goldNumTF resignFirstResponder];
    [self.TwoGoldBtn.layer setBorderColor:RGBCOLOR(234, 85, 20).CGColor];
    [self.OneGoldBtn.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];
    [self.ThreeGoldBtn.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];
    [self.goldNumTF.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];

    self.TwoGoldBtn.selected = YES;
    self.OneGoldBtn.selected = NO;
    self.ThreeGoldBtn.selected = NO;
    self.goldNumTF.text = @"";
    self.payGoldLb.text = [NSString stringWithFormat:@"赏金支付：5元"];
}

- (IBAction)threeGoldClick:(id)sender {
    [self.goldNumTF resignFirstResponder];
    [self.ThreeGoldBtn.layer setBorderColor:RGBCOLOR(234, 85, 20).CGColor];
    [self.OneGoldBtn.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];
    [self.TwoGoldBtn.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];
    [self.goldNumTF.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];

    self.ThreeGoldBtn.selected = YES;
    self.OneGoldBtn.selected = NO;
    self.TwoGoldBtn.selected = NO;
    self.goldNumTF.text = @"";
    self.payGoldLb.text = [NSString stringWithFormat:@"赏金支付：10元"];
}

@end
