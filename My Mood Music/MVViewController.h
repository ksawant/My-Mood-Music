//
//  MVViewController.h
//  MusicPlayer
//
//  Created by dev27 on 5/14/13.
//  Copyright (c) 2013 Codigator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JFWeatherData.h"
#import "JFWeatherManager.h"
#import "DataModels.h"

@interface MVViewController : UIViewController <UITableViewDataSource,CLLocationManagerDelegate,MKMapViewDelegate, UITableViewDelegate>{
    
    JFWeatherManager *weatherManager;
    
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@end
