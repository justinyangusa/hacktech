//
//  mainViewController.m
//  hacktech
//
//  Created by Kevin Fang on 2/27/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "mainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AFNetworking/AFNetworking.h>

@interface mainViewController ()

@end

@implementation MyLocationViewController : NSObject  {
    CLLocationManager *locationManager;
}

@end
@implementation mainViewController
- (IBAction)logOut:(id)sender {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://postmatesthing.firebaseio.com"];
    [ref unauth];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}



- (NSString *) getDataFrom:(NSString *)url{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];

    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    NSString *pickupname;
    NSString *pickupAddress;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    [request setURL:[NSURL URLWithString:@"/v1/customers/:customer_id/deliveries"]];
    NSString * postUrl = [NSString stringWithFormat:@"pickup_address=%@&dropoff_address=%@", pickupname, pickupAddress];
    [request setHTTPBody:[postUrl dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
//    NSString *postString = [NSString stringWithFormat:@"pickup_name=%@&pickup_address=%@",pickupname,pickupAddress ];

    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    
    
    [request setHTTPBody:[postUrl dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    NSLog(@"%@",connection);
    
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
