//
//  newaccountbg.h
//  My Mood Music
//
//  Created by Kartik Sawant on 10/25/14.
//  Copyright (c) 2014 Kartik Sawant. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol newaccountbgDelegate

@end

@interface newaccountbg : UIViewController 

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmpassword;
@property (weak, nonatomic) IBOutlet UITextField *year;
@property (nonatomic) int recordIDToEdit;


- (IBAction)saveInfo:(id)sender;
@end
