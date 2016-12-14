//
//  SetPasswordViewController.h
//  SevenDay
//
//  Created by macbook for test on 16/12/12.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TLSSDK/TLSAccountHelper.h>
#import <TLSSDK/TLSPwdRegListener.h>
#import "RegExpUtil.h"
#import "CompleteBasicInfoViewController.h"

@interface SetPasswordViewController : UIViewController 

@property (strong, nonatomic) NSString* phoneNumber;

@property (weak, nonatomic) IBOutlet UITextField *inputPwd;
@property (weak, nonatomic) IBOutlet UITextField *inputPwdAgain;
- (IBAction)nextStep:(id)sender;

@end
