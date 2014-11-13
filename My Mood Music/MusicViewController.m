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
NSString *c;
float speed;
float temp;
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
    float speed;
    speed = self.location.speed*2.23693629;
    if(speed<0) {
        speed=0;
    }
    float temp;
    temp = 0;
    [weatherManager fetchWeatherDataForLatitude:self.location.coordinate.latitude andLongitude:self.location.coordinate.longitude withAPIKeyOrNil:@"a4c33519650013f187bcdc2a48df7ead" :^(JFWeatherData *returnedWeatherData) {
        float temp;
        temp = [returnedWeatherData temperatureInUnitFormat:kTemperatureFarenheit];
        c = [returnedWeatherData currentConditionsTextualDescription];
        NSLog(@"%@",c);
        [self musicManager:self.locationManager];
            }];
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

- (void)musicManager:(CLLocationManager *)manager {
    if(speed == 0) {
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                //punk
                NSLog(@"thunderstorm");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                //soul
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                //soul
                NSLog(@"rain");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                //reggae
                NSLog(@"snow");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                //country
                NSLog(@"atmosphere");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"])) {
                //classical
                NSLog(@"clouds");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                //metal
                NSLog(@"extreme");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                //classical
                NSLog(@"additional");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                //metal
                NSLog(@"thunderstorm");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                //soul
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                //rock
                NSLog(@"rain");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                //hip-hop
                NSLog(@"snow");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                //classical
                NSLog(@"atmosphere");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"])) {
                //country
                NSLog(@"clouds");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                //reggae
                NSLog(@"extreme");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                //rock
                NSLog(@"additional");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                //dubstep
                NSLog(@"thunderstorm");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173058369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                //metal
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                //rap
                NSLog(@"rain");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                //hip-hop
                NSLog(@"snow");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                //country
                NSLog(@"atmosphere");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"])) {
                //pop
                NSLog(@"clouds");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                //punk
                NSLog(@"extreme");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                //pop
                NSLog(@"additional");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 0 && speed <= 3) {
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                //metal
                NSLog(@"thunderstorm");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                //dubstep
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173058369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                //rock
                NSLog(@"rain");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                //soul
                NSLog(@"snow");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                //classical
                NSLog(@"atmosphere");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"])) {
                //punk
                NSLog(@"clouds");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                //reggae
                NSLog(@"extreme");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                //pop
                NSLog(@"additional");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                //punk
                NSLog(@"thunderstorm");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                //r&b
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                //hip-hop
                NSLog(@"rain");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                //classical
                NSLog(@"snow");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                //country
                NSLog(@"atmosphere");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"])) {
                //country
                NSLog(@"clouds");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                //punk
                NSLog(@"extreme");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                //dubstep
                NSLog(@"additional");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173058369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                //pop
                NSLog(@"thunderstorm");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                //rap
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                //rock
                NSLog(@"rain");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                //pop
                NSLog(@"snow");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                //hip-hop
                NSLog(@"atmosphere");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"])) {
                //country
                NSLog(@"clouds");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                //metal
                NSLog(@"extreme");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                //r&b
                NSLog(@"additional");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 3 && speed <= 6.5) {
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                //reggae
                NSLog(@"thunderstorm");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                //metal
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                //rap
                NSLog(@"rain");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                //rock
                NSLog(@"snow");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                //soul
                NSLog(@"atmosphere");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"])) {
                //country
                NSLog(@"clouds");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                //pop
                NSLog(@"extreme");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                //pop
                NSLog(@"additional");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                //rap
                NSLog(@"thunderstorm");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                //dupstep
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173058369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                //country
                NSLog(@"rain");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                //hip-hop
                NSLog(@"snow");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                //pop
                NSLog(@"atmosphere");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"])) {
                //pop
                NSLog(@"clouds");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/15996669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                //metal
                NSLog(@"extreme");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                //punk
                NSLog(@"additional");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                //rap
                NSLog(@"thunderstorm");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                //hip-hop
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                //metal
                NSLog(@"rain");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                //punk
                NSLog(@"snow");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                //pop
                NSLog(@"atmosphere");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/15996669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"])) {
                //r&b
                NSLog(@"clouds");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                //reggae
                NSLog(@"extreme");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                //soul
                NSLog(@"additional");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [self.player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = locations.lastObject;
    float x;
    x = self.location.speed*2.23693629;
    if(x<0) {
        x=0.000000;
    }
    self.speed.text = [NSString stringWithFormat:@"Speed: %.2f MPH", x];
    [weatherManager fetchWeatherDataForLatitude:self.location.coordinate.latitude andLongitude:self.location.coordinate.longitude withAPIKeyOrNil:@"a4c33519650013f187bcdc2a48df7ead" :^(JFWeatherData *returnedWeatherData) {
        self.temp.text = [NSString stringWithFormat:@"Temperature: %.2f F",[returnedWeatherData temperatureInUnitFormat:kTemperatureFarenheit]];
        self.condition.text = [NSString stringWithFormat:@"Condition: %@",[returnedWeatherData currentConditionsTextualDescription]];
        tempC = [NSString stringWithFormat:@"Temperature: %.2f C",[returnedWeatherData temperatureInUnitFormat:kTemperatureCelcius]];
        tempK = [NSString stringWithFormat:@"Temperature: %.2f K",[returnedWeatherData temperatureInUnitFormat:kTemperatureKelvin]];
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
