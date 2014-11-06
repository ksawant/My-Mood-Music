//
//  SoundCloudViewController.m
//  My Mood Music
//
//  Created by Kartik Sawant on 11/6/14.
//  Copyright (c) 2014 Kartik Sawant. All rights reserved.
//

#import "SoundCloudViewController.h"

@interface SoundCloudViewController ()

@end

@implementation SoundCloudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://soundcloud.com/connect?state=SoundCloud_Dialog_e4c46&client_id=1ca7a448b3e22d42b5b650ba1c009e7d&redirect_uri=mymoodmusic//&response_type=code_and_token&scope=non-expiring&display=popup"]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
