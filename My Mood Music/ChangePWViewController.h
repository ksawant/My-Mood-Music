//
//  ChangePWViewController.h
//  My Mood Music
//
//  Created by Kartik Sawant on 10/25/14.
//  Copyright (c) 2014 Kartik Sawant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePWViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldpw;
@property (weak, nonatomic) IBOutlet UITextField *newpw;
@property (weak, nonatomic) IBOutlet UITextField *confirmpw;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end
