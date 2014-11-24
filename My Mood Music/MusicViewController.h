//
//  MusicViewController.h
//  My Mood Music
//
//  Created by Kartik Sawant on 10/26/14.
//  Copyright (c) 2014 Kartik Sawant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JFWeatherData.h"
#import "JFWeatherManager.h"
#import "DataModels.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>

@interface MusicViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate, UITableViewDelegate>{
    
    JFWeatherManager *weatherManager;
    MPMoviePlayerController *audioPlayer;
    AVPlayerItem *playerItem;
}
@property (nonatomic, retain) MPMoviePlayerController *audioPlayer;
@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;
@property (strong, nonatomic) AVPlayerItem *playerItem;
//@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (weak, nonatomic) IBOutlet UILabel *condition;
@property (weak, nonatomic) IBOutlet UILabel *temp;
@property(nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITextField *status;
@property (weak, nonatomic) IBOutlet UIImageView *albumart;
- (void)pushAction:(id)sender;
- (void)pushAction2:(id)sender;
- (IBAction)playButtonPress:(id)sender;
- (IBAction)pauseButtonPress:(id)sender;
- (IBAction)skipButtonPress:(id)sender;
- (void)remoteControlReceivedWithEvent:(UIEvent *)theEvent;
@end
