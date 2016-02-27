//
//  mainViewController.h
//  hacktech
//
//  Created by Kevin Fang on 2/27/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@import Foundation;

@interface mainViewController : UIViewController <CLLocationManagerDelegate>

@property (retain, nonatomic) NSMutableData *apiReturnXMLData;
@end
