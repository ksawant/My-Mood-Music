//
//  MusicViewController.m
//  My Mood Music
//
//  Created by Kartik Sawant on 10/26/14.
//  Copyright (c) 2014 Kartik Sawant. All rights reserved.
//

#import "MusicViewController.h"
@interface MusicViewController ()

@end

@implementation MusicViewController
NSString *tempC;
NSString *tempK;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.location = [[CLLocation alloc] init];
    weatherManager = [[JFWeatherManager alloc]init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction:)];
    [self.temp addGestureRecognizer:tap];
    self.temp.userInteractionEnabled = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestAlwaysAuth{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status==kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString*title;
        title=(status == kCLAuthorizationStatusDenied) ? @"Location Services Are Off" : @"Background use is not enabled";
        NSString *message = @"Go to settings";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
        [alert show];
    }else if (status==kCLAuthorizationStatusNotDetermined)
    {[self.locationManager requestAlwaysAuthorization];}
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingsURL];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = locations.lastObject;
    float x;
    x = self.location.speed*2.23693629;
    if(x<0) {
        x=0.000000;
    }
    self.speed.text = [NSString stringWithFormat:@"Speed: %f MPH", x];
    [weatherManager fetchWeatherDataForLatitude:self.location.coordinate.latitude andLongitude:self.location.coordinate.longitude withAPIKeyOrNil:@"a4c33519650013f187bcdc2a48df7ead" :^(JFWeatherData *returnedWeatherData) {
        self.temp.text = [NSString stringWithFormat:@"Temperature: %f F",[returnedWeatherData temperatureInUnitFormat:kTemperatureFarenheit]];
        self.condition.text = [NSString stringWithFormat:@"Condition: %@",[returnedWeatherData currentConditionsTextualDescription]];
        tempC = [NSString stringWithFormat:@"Temperature: %f C",[returnedWeatherData temperatureInUnitFormat:kTemperatureCelcius]];
        tempK = [NSString stringWithFormat:@"Temperature: %f K",[returnedWeatherData temperatureInUnitFormat:kTemperatureKelvin]];
    }];
}

- (void)pushAction:(id)sender {
    self.temp.text = tempC;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction2:)];
    [self.temp addGestureRecognizer:tap];
    self.temp.userInteractionEnabled = YES;
}

- (void)pushAction2:(id)sender {
    self.temp.text = tempK;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction:)];
    [self.temp addGestureRecognizer:tap];
    self.temp.userInteractionEnabled = YES;
}



@end
