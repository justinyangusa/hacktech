//
//  mainViewController.m
//  hacktech
//
//  Created by Kevin Fang on 2/27/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "mainViewController.h"

@interface mainViewController ()

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
