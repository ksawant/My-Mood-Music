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

@interface MusicViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate, UITableViewDelegate>{
    
    JFWeatherManager *weatherManager;
    
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (weak, nonatomic) IBOutlet UILabel *condition;
@property (weak, nonatomic) IBOutlet UILabel *temp;
@property(nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITextField *status;
- (void)pushAction:(id)sender;
- (void)pushAction2:(id)sender;
@end
