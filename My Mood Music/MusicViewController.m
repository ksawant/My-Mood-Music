//
//  MusicViewController.m
//  My Mood Music
//
//  Created by Kartik Sawant on 10/26/14.
//  Copyright (c) 2014 Kartik Sawant. All rights reserved.
//

#import "MusicViewController.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface MusicViewController ()

@end

@implementation MusicViewController
@synthesize playButton;
@synthesize skipButton;
@synthesize audioPlayer;
NSString *tempC;
NSString *tempK;
NSString *c;
float speed;
float temp;
int num = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    [playButton setImage:[UIImage imageNamed:@"glyphicons-174-play.png"] forState:UIControlStateNormal];
    [skipButton setImage:[UIImage imageNamed:@"Forward.png"] forState:UIControlStateNormal];
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
    //[[AVAudioSession sharedInstance] setDelegate: self];
    NSError *myErr;
    
    // Initialize the AVAudioSession here.
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
        // Handle the error here.
        NSLog(@"Audio Session error %@, %@", myErr, [myErr userInfo]);
    }
    else{
        // Since there were no errors initializing the session, we'll allow begin receiving remote control events
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
    //initialize our audio player
    //audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://www.cocoanetics.com/files/Cocoanetics_031.mp3"]];
    
    //[audioPlayer setShouldAutoplay:NO];
    //[audioPlayer setControlStyle: MPMovieControlStyleEmbedded];
    //audioPlayer.view.hidden = YES;
    
    //[audioPlayer prepareToPlay];
    speed = self.location.speed*2.23693629;
    if(speed<0) {
        speed=0;
    }
    temp = 0;
    [weatherManager fetchWeatherDataForLatitude:40.431965 andLongitude:-86.918631 withAPIKeyOrNil:@"a4c33519650013f187bcdc2a48df7ead" :^(JFWeatherData *returnedWeatherData) {
        temp = [returnedWeatherData temperatureInUnitFormat:kTemperatureFarenheit];
        c = [returnedWeatherData currentConditionsTextualDescription];
        /*num =1;
        c = @"Strong Breeze";
        speed = 6.6;
        temp= 20.4;*/
        NSLog(@"%@",c);
        [self musicManager:self.locationManager];
            }];
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timeupdater) userInfo:nil repeats:YES];
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

/*- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [player pause];
}*/

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
    /*num =1;
    c = @"Strong Breeze";
    speed = 6.6;
    temp= 20.4;*/
    if(speed == 0 && num == 1) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Exit Only"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Mommy's Little Baby"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096692120-um55tq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Mommy's Little Baby"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096692120-um55tq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                ////[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Intro"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094782773-h99isx-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Slipknot"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Intro"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094782773-h99isx-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Slipknot"];
                NSLog(@"thunderstorm");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Mommy's Little Baby"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096692120-um55tq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"21+"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"No Type"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Intro"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094782773-h99isx-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"21+"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"What Goes Around...Comes Around"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094591628-mx16l1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173058369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Slipknot"];
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"6 God"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"No Type"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Exit Only"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
        
    }
    else if(speed > 0 && speed <= 3 && num == 1) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Slipknot"];
                NSLog(@"thunderstorm");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"What Goes Around...Comes Around"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094591628-mx16l1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173058369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"21+"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Mommy's Little Baby"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096692120-um55tq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Intro"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094782773-h99isx-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Exit Only"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Exit Only"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Often"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"No Type"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Intro"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094782773-h99isx-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Exit Only"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"What Goes Around...Comes Around"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094591628-mx16l1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173058369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"6 God"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"21+"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"No Type"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Slipknot"];
                NSLog(@"extreme");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Often"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 3 && speed <= 6.5 && num == 1) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Slipknot"];
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"6 God"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"21+"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Mommy's Little Baby"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096692120-um55tq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"6 God"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"What Goes Around...Comes Around"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094591628-mx16l1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173058369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"No Type"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"clouds");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/15996669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Slipknot"];
                NSLog(@"extreme");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Exit Only"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"6 God"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"No Type"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Slipknot"];
                NSLog(@"rain");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Exit Only"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"atmosphere");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/15996669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Often"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Mommy's Little Baby"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096692120-um55tq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 6.5 && num == 1) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"21+"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"No Type"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"No Type"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Often"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"6 God"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"All About That Bass"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Slipknot"];
                NSLog(@"additional");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"No Type"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Often"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"6 God"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"21+"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Often"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Often"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"6 God"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"6 God"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Fireball"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"No Type"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Slipknot"];
                NSLog(@"additional");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed == 0 && num == 2) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Out of Mind"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Her"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094363361-dnziu9-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172712345/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Mommy's Little Baby"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094363361-dnziu9-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172712345/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                ////[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"Jammin'"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000081310850-05efx8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/152589690/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Burnin It Down"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Precious Little"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086556965-8qo24q-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160808486/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"I Knew You Were Trouble"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Precious Little"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086556965-8qo24q-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160808486/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"I Knew You Were Trouble"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Mommy's Little Baby"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094363361-dnziu9-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172712345/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Left Hand Free"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Tuesday"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Precious Little"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086556965-8qo24q-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160808486/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Burnin It Down"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"Jammin'"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000081310850-05efx8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/152589690/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Left Hand Free"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"Lay Me Down"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000082913710-i1vx6h-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/155226929/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"I Knew You Were Trouble"];
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"How About Now"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Tuesday"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Burnin It Down"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Out of Mind"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
        
    }
    else if(speed > 0 && speed <= 3 && num == 2) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"I Knew You Were Trouble"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"Lay Me Down"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000082913710-i1vx6h-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/155226929/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Left Hand Free"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Mommy's Little Baby"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094363361-dnziu9-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172712345/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Precious Little"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086556965-8qo24q-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160808486/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Out of Mind"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"Jammin'"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000081310850-05efx8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/152589690/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Out of Mind"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"She Came To Give It To You"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Tuesday"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Precious Little"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086556965-8qo24q-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160808486/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Burnin It Down"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Burnin It Down"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Out of Mind"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"Lay Me Down"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000082913710-i1vx6h-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/155226929/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"How About Now"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Left Hand Free"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Tuesday"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Burnin It Down"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"I Knew You Were Trouble"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"She Came To Give It To You"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 3 && speed <= 6.5 && num == 2) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"Jammin'"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000081310850-05efx8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/152589690/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"I Knew You Were Trouble"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"How About Now"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Left Hand Free"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Mommy's Little Baby"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094363361-dnziu9-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172712345/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Burnin It Down"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"How About Now"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"Lay Me Down"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000082913710-i1vx6h-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/155226929/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Burnin It Down"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Tuesday"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"I Knew You Were Trouble"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Out of Mind"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"How About Now"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Tuesday"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"I Knew You Were Trouble"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Out of Mind"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"She Came To Give It To You"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"Jammin'"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000081310850-05efx8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/152589690/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Mommy's Little Baby"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094363361-dnziu9-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172712345/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 6.5 && num == 2) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Left Hand Free"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Tuesday"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Tuesday"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"She Came To Give It To You"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"How About Now"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"Jammin'"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000081310850-05efx8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/152589690/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"I Knew You Were Trouble"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Tuesday"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"She Came To Give It To You"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"How About Now"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Left Hand Free"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"She Came To Give It To You"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"She Came To Give It To You"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"How About Now"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"How About Now"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Hurricane"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Tuesday"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"I Knew You Were Trouble"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed == 0 && num == 3) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Instant Crush"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Sober"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090999691-55yj4g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/167701797/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Sober"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090999691-55yj4g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/167701797/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                ////[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"In Your Arms"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/avatars-000082149579-lje63v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/150525686/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Sippin' On Fire"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"The Silverwastes"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096259545-6n7h4n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175561037/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Shatter"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"The Silverwastes"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096259545-6n7h4n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175561037/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Shatter"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Sober"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090999691-55yj4g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/167701797/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Aerials"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Body Language"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000091531037-9gnhf2-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166806576/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"The Silverwastes"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096259545-6n7h4n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175561037/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Sippin' On Fire"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"In Your Arms"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/avatars-000082149579-lje63v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/150525686/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Aerials"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"Summer"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000085673471-db136n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159440665/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Shatter"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Anaconda"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161895971/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Body Language"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000091531037-9gnhf2-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166806576/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Sippin' On Fire"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Instant Crush"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
        
    }
    else if(speed > 0 && speed <= 3 && num == 3) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Shatter"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"Summer"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000085673471-db136n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159440665/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Aerials"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Sober"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090999691-55yj4g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/167701797/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"The Silverwastes"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096259545-6n7h4n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175561037/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Instant Crush"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"In Your Arms"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/avatars-000082149579-lje63v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/150525686/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Instant Crush"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Unappreciated"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Low"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"The Silverwastes"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096259545-6n7h4n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175561037/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Sippin' On Fire"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Sippin' On Fire"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Instant Crush"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"Summer"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000085673471-db136n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159440665/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Anaconda"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161895971/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Aerials"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Low"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Sippin' On Fire"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Shatter"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Unappreciated"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 3 && speed <= 6.5 && num == 3) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"In Your Arms"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/avatars-000082149579-lje63v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/150525686/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Shatter"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Anaconda"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161895971/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Aerials"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Sober"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090999691-55yj4g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/167701797/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Sippin' On Fire"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Anaconda"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161895971/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"Summer"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000085673471-db136n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159440665/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"Sippin' On Fire"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Low"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Shatter"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Instant Crush"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Anaconda"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161895971/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Low"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Shatter"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Instant Crush"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Unappreciated"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"In Your Arms"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/avatars-000082149579-lje63v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/150525686/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Sober"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090999691-55yj4g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/167701797/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 6.5 && num == 3) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Aerials"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Low"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Low"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Unappreciated"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Anaconda"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161895971/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"In Your Arms"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Shatter"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Low"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Unappreciated"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Anaconda"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161895971/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"Aerials"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Unappreciated"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Unappreciated"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Anaconda"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161895971/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Anaconda"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161895971/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Immortals"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Low"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Shatter"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    else if(speed == 0 && num == 4) {
        num=1;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Prove It"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087855607-2izjsk-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/154754678/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Take Care Of You"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093460457-h3xuzd-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171405786/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Take Care Of You"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093460457-h3xuzd-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171405786/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                ////[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"Stylin'"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094712253-f8lh3m-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173238968/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"If It's Just Me"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000097395375-iru8g8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172500170/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Interstellar Main Theme"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096552676-u050d5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175999197/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Killing Me Inside"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095468450-rbncus-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174364181/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Interstellar Main Theme"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096552676-u050d5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175999197/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Killing Me Inside"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095468450-rbncus-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174364181/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Take Care Of You"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093460457-h3xuzd-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171405786/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"I Bet My Life"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095310515-g5e5xw-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174130369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Body Language"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000091531037-9gnhf2-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166806576/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Interstellar Main Theme"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096552676-u050d5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175999197/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"If It's Just Me"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000097395375-iru8g8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172500170/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"Stylin'"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094712253-f8lh3m-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173238968/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"I Bet My Life"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095310515-g5e5xw-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174130369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"Five Nights at Freddy's Song"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089662968-itnm6r-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165603854/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Killing Me Inside"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095468450-rbncus-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174364181/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Beg For It"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094967047-fkm7ed-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173307495/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Body Language"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000091531037-9gnhf2-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166806576/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"If It's Just Me"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000097395375-iru8g8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172500170/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Prove It"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087855607-2izjsk-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/154754678/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
        
    }
    else if(speed > 0 && speed <= 3 && num == 4) {
        num=1;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Killing Me Inside"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095468450-rbncus-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174364181/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"Five Nights at Freddy's Song"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089662968-itnm6r-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165603854/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"I Bet My Life"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095310515-g5e5xw-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174130369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Take Care Of You"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093460457-h3xuzd-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171405786/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Interstellar Main Theme"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096552676-u050d5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175999197/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Prove It"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087855607-2izjsk-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/154754678/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"Stylin'"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094712253-f8lh3m-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173238968/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Prove It"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087855607-2izjsk-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/154754678/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Thinking Out Loud"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000098252592-0a39ax-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/178553851/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Body Language"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                self.gtitle.text = [NSString stringWithFormat:@"Interstellar Main Theme"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096552676-u050d5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175999197/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"If It's Just Me"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000097395375-iru8g8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172500170/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"If It's Just Me"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000097395375-iru8g8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172500170/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Prove It"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087855607-2izjsk-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/154754678/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"Five Nights at Freddy's Song"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089662968-itnm6r-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165603854/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Beg For It"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094967047-fkm7ed-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173307495/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"I Bet My Life"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095310515-g5e5xw-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174130369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Body Language"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"If It's Just Me"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000097395375-iru8g8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172500170/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Killing Me Inside"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095468450-rbncus-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174364181/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Thinking Out Loud"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000098252592-0a39ax-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/178553851/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 3 && speed <= 6.5 && num == 4) {
        num=1;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"Stylin'"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094712253-f8lh3m-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173238968/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Killing Me Inside"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095468450-rbncus-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174364181/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Beg For It"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094967047-fkm7ed-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173307495/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"I Bet My Life"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095310515-g5e5xw-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174130369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Take Care Of You"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093460457-h3xuzd-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171405786/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"If It's Just Me"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000097395375-iru8g8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172500170/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Beg For It"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094967047-fkm7ed-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173307495/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                self.gtitle.text = [NSString stringWithFormat:@"Five Nights at Freddy's Song"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089662968-itnm6r-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165603854/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                self.gtitle.text = [NSString stringWithFormat:@"If It's Just Me"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000097395375-iru8g8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172500170/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Body Language"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Killing Me Inside"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095468450-rbncus-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174364181/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Prove It"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087855607-2izjsk-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/154754678/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Beg For It"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094967047-fkm7ed-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173307495/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Body Language"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Killing Me Inside"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095468450-rbncus-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174364181/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                self.gtitle.text = [NSString stringWithFormat:@"Prove It"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087855607-2izjsk-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/154754678/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Thinking Out Loud"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000098252592-0a39ax-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/178553851/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"Stylin'"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094712253-f8lh3m-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173238968/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                self.gtitle.text = [NSString stringWithFormat:@"Take Care Of You"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093460457-h3xuzd-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171405786/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 6.5 && num == 4) {
        num=1;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"I Bet My Life"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095310515-g5e5xw-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174130369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Body Language"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Body Language"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Thinking Out Loud"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000098252592-0a39ax-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/178553851/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Beg For It"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094967047-fkm7ed-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173307495/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                self.gtitle.text = [NSString stringWithFormat:@"Stylin'"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Killing Me Inside"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095468450-rbncus-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174364181/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Body Language"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Thinking Out Loud"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000098252592-0a39ax-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/178553851/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Beg For It"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094967047-fkm7ed-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173307495/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                self.gtitle.text = [NSString stringWithFormat:@"I Bet My Life"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095310515-g5e5xw-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174130369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Thinking Out Loud"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000098252592-0a39ax-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/178553851/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                self.gtitle.text = [NSString stringWithFormat:@"Thinking Out Loud"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000098252592-0a39ax-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/178553851/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Beg For It"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094967047-fkm7ed-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173307495/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                self.gtitle.text = [NSString stringWithFormat:@"Beg For It"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094967047-fkm7ed-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173307495/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                self.gtitle.text = [NSString stringWithFormat:@"Animals"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089056769-mmalvb-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164661027/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                self.gtitle.text = [NSString stringWithFormat:@"Body Language"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                self.gtitle.text = [NSString stringWithFormat:@"Killing Me Inside"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095468450-rbncus-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/174364181/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    [self setSlider];
}

- (IBAction)playButtonPress:(id)sender {
    if (((AppDelegate *)([UIApplication sharedApplication].delegate)).player.rate > 0 && !((AppDelegate *)([UIApplication sharedApplication].delegate)).player.error) {
        [playButton setImage:[UIImage imageNamed:@"glyphicons-174-play.png"] forState:UIControlStateNormal];
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).player pause];
    }
    else {
        [playButton setImage:[UIImage imageNamed:@"Pause@2x.png"] forState:UIControlStateNormal];
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).player play];
    }
    //[player play];
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    if (playingInfoCenter) {
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        //MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [UIImage imageNamed:@"AlbumArt"]];
        [songInfo setObject:@"Audio Title" forKey:@"Song Name" /*forKey:MPMediaItemPropertyTitle */];
        //[songInfo setObject:@"Audio Author" forKey:MPMediaItemPropertyArtist];
        //[songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
        //[songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    }
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage: self.albumart.image];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.gtitle.text, MPMediaItemPropertyTitle,
                                                             self.genre.text, MPMediaItemPropertyArtist, artwork, MPMediaItemPropertyArtwork,  1.0f, MPNowPlayingInfoPropertyPlaybackRate, nil];
}
- (void) timeupdater {
    CMTime duration = playerItem.duration;
    CMTime currentTime = playerItem.currentTime;
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:CMTimeGetSeconds(duration)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    NSDate *date2 = [NSDate dateWithTimeIntervalSinceReferenceDate:CMTimeGetSeconds(currentTime)];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"mm:ss"];
    NSString *dateString2 = [formatter2 stringFromDate:date2];
    self.duration.text = [NSString stringWithFormat:@"%@",dateString];
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",dateString2];
    if(CMTimeGetSeconds(duration) == CMTimeGetSeconds(currentTime)) {
        [self musicManager:self.locationManager];
        //[player play];
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).player play];
    }
}


- (IBAction)pauseButtonPress:(id)sender {
    //[player pause];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).player pause];
}

- (void)resetSlider {
    self.currentTimeSlider.maximumValue = 1.0;
    self.currentTimeSlider.minimumValue = 0.0;
    [self.currentTimeSlider setValue:0.0];
}

- (IBAction)skipButtonPress:(id)sender {
    [self musicManager:self.locationManager];
   // [self resetSlider];
    //[player play];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).player play];
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    if (playingInfoCenter) {
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        //MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [UIImage imageNamed:@"AlbumArt"]];
        [songInfo setObject:@"Audio Title" forKey:@"Song Name" /*forKey:MPMediaItemPropertyTitle */];
        //[songInfo setObject:@"Audio Author" forKey:MPMediaItemPropertyArtist];
        //[songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
        //[songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    }
    //[self setSlider];
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage: self.albumart.image];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.gtitle.text, MPMediaItemPropertyTitle,
                                                             self.genre.text, MPMediaItemPropertyArtist, artwork, MPMediaItemPropertyArtwork,  1.0f, MPNowPlayingInfoPropertyPlaybackRate, nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = locations.lastObject;
    float x;
    x = self.location.speed*2.23693629;
    if(x<0) {
        x=0.000000;
    }
    speed = x;
    //x = 6.6;
    self.speed.text = [NSString stringWithFormat:@"Speed: %.2f MPH", x];
    [weatherManager fetchWeatherDataForLatitude:self.location.coordinate.latitude andLongitude:self.location.coordinate.longitude withAPIKeyOrNil:@"a4c33519650013f187bcdc2a48df7ead" :^(JFWeatherData *returnedWeatherData) {
        /*num =1;
        c = @"Strong Breeze";
        speed = 6.6;
        temp= 20.4;*/
        self.temp.text = [NSString stringWithFormat:@"Temperature: %.2f F",/*temp*/[returnedWeatherData temperatureInUnitFormat:kTemperatureFarenheit]];
        self.condition.text = [NSString stringWithFormat:@"Condition: %@",/*@"Strong Breeze"*/[returnedWeatherData currentConditionsTextualDescription]];
        tempC = [NSString stringWithFormat:@"Temperature: %.2f C",[returnedWeatherData temperatureInUnitFormat:kTemperatureCelcius]];
        tempK = [NSString stringWithFormat:@"Temperature: %.2f K",[returnedWeatherData temperatureInUnitFormat:kTemperatureKelvin]];
        //temp = [returnedWeatherData temperatureInUnitFormat:kTemperatureFarenheit];
        //c = [returnedWeatherData currentConditionsTextualDescription];
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

-(IBAction)sliding:(id)sender{
    
    CMTime newTime = CMTimeMakeWithSeconds(self.currentTimeSlider.value, 1);
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).player seekToTime:newTime];
}

-(void)setSlider{
    
    NSTimer *sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self    selector:@selector(updateSlider) userInfo:nil repeats:YES];
    self.currentTimeSlider.maximumValue = [self durationInSeconds];
    [self.currentTimeSlider addTarget:self action:@selector(sliding:) forControlEvents:UIControlEventValueChanged];
    self.currentTimeSlider.minimumValue = 0.0;
    self.currentTimeSlider.continuous = YES;
    [self updateSlider];
}

- (void)updateSlider {
    self.currentTimeSlider.maximumValue = [self durationInSeconds];
    self.currentTimeSlider.value = [self currentTimeInSeconds];
}

- (Float64)durationInSeconds {
    Float64 dur;
    if(CMTimeGetSeconds(playerItem.duration) < 10) {
        dur = CMTimeGetSeconds(playerItem.duration);
    }
    else {
        dur = 240;
    }
    /*Float64 dur = 240;
    NSLog(@"%f",CMTimeGetSeconds(playerItem.duration));*/
    return dur;
}


- (Float64)currentTimeInSeconds {
    Float64 dur = CMTimeGetSeconds(playerItem.currentTime);
    return dur;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)theEvent
{
    if (theEvent.type == UIEventTypeRemoteControl)
    {
        switch(theEvent.subtype) {
            //case UIEventSubtypeRemoteControlTogglePlayPause:
                //Insert code
                
            case UIEventSubtypeRemoteControlPlay:
                [((AppDelegate *)([UIApplication sharedApplication].delegate)).player play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [((AppDelegate *)([UIApplication sharedApplication].delegate)).player pause];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self musicManager:self.locationManager];
                [((AppDelegate *)([UIApplication sharedApplication].delegate)).player play];
                MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage: self.albumart.image];
                [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.gtitle.text, MPMediaItemPropertyTitle,
                                                                         self.genre.text, MPMediaItemPropertyArtist, artwork, MPMediaItemPropertyArtwork,  1.0f, MPNowPlayingInfoPropertyPlaybackRate, nil];
                break;
            //default:
                //return;
        }
    }
}

@end
