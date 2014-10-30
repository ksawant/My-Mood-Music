//
//  ChangePWViewController.m
//  My Mood Music
//
//  Created by Kartik Sawant on 10/25/14.
//  Copyright (c) 2014 Kartik Sawant. All rights reserved.
//

#import "ChangePWViewController.h"

@interface ChangePWViewController ()

@end

@implementation ChangePWViewController
@synthesize newpw, oldpw, confirmpw;
@synthesize scrollview;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper2.png"]];
    
    UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

-(void) dismissKeyboard {
    [oldpw resignFirstResponder];
    [newpw resignFirstResponder];
    [confirmpw resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y);
    [scrollview setContentOffset:scrollPoint animated:YES];
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    [scrollview setContentOffset:CGPointZero animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkpasswords:(id)sender {
    if (![newpw.text isEqualToString:@""]) {
        if([newpw.text isEqualToString:confirmpw.text]) {
            NSLog(@"MATCH");
            [self performSegueWithIdentifier:@"tologin" sender:sender];
        }
    }
    else {
        NSLog(@"DIFFERENT");
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
