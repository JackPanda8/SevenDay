//
//  ResetPasswordViewController.h
//  SevenDay
//
//  Created by macbook for test on 16/12/14.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegExpUtil.h"

@interface ResetPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verCode;
- (IBAction)getVerCode:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;
- (IBAction)GetItBack:(id)sender;
- (IBAction)back:(id)sender;

@end
