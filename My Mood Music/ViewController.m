//
//  ViewController.m
//  My Mood Music
//
//  Created by Kartik Sawant on 10/25/14.
//  Copyright (c) 2014 Kartik Sawant. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@import CoreLocation;

@interface ViewController ()
@end

@implementation ViewController
@synthesize username, password;
@synthesize scrollviewlogin;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).player pause];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingsURL];
    }
}

-(void) dismissKeyboard {
    [username resignFirstResponder];
    [password resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint= CGPointMake(0, textField.frame.origin.y);
    [scrollviewlogin setContentOffset:scrollPoint animated:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField { [scrollviewlogin setContentOffset:CGPointZero animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signin:(id)sender {
    [self dismissKeyboard];
    if(![username.text isEqualToString:@""]) {
        if(![password.text isEqualToString:@""]) {
            NSLog(@"NOTEMPTY");
            [self performSegueWithIdentifier:@"tomusic" sender:sender];
        }
    }
    else {
        NSLog(@"EMPTY");
    }
}

@end
