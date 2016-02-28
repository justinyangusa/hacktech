//
//  registerViewController.m
//  hacktech
//
//  Created by Kevin Fang on 2/27/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "registerViewController.h"

@interface registerViewController (){
    
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UITextField *emailTextField;
    
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITextField *phoneTextField;
}

@end

@implementation registerViewController
@synthesize Name;
@synthesize password;
@synthesize Number;
@synthesize email;

- (IBAction)registerAction:(id)sender {
    if(emailTextField.text != nil && passwordTextField.text != nil){
        Firebase *ref = [[Firebase alloc] initWithUrl:@"https://postmatesthing.firebaseio.com"];
        [ref createUser:emailTextField.text password:passwordTextField.text
withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
        if (error) {
        // There was an error creating the account
        } else {
            
            [[[[Firebase alloc] initWithUrl:@"https://postmatesthing"] childByAppendingPath:@"Name"] setValue:[NSNumber numberWithInt:Number]];
            [[[[Firebase alloc] initWithUrl:@"https://postmatesthing"] childByAppendingPath:@"Name"] setValue:[NSNumber numberWithInt:Name]];


            Name = nameTextField.text;
            password = passwordTextField.text;
            email = emailTextField.text;
            Number = phoneTextField.text;
            
            NSString *uid = [result objectForKey:@"uid"];
            NSLog(@"Successfully created user account with uid: %@", uid);
            [self performSegueWithIdentifier:@"registerSuccess" sender:self];

            }
        }];
        
        [ref authUser:emailTextField.text password:passwordTextField.text
withCompletionBlock:^(NSError *error, FAuthData *authData) {
        if (error) {
        // There was an error logging in to this account
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"enter a legit email"
                                                                           message:@""
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            NSLog(@" %@ ", error);
        } else {
        [self performSegueWithIdentifier:@"registerSuccess" sender:self];
            
        }
        }];
    }
    else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"m8 fill it out"
                                                                       message:@"empty field"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [passwordTextField setDelegate:self];
    [emailTextField setDelegate:self];
    [nameTextField setDelegate:self];
    [phoneTextField setDelegate:self];


    // Do any additional setup after loading the view.
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://postmatesthing.firebaseio.com"];
    [ref createUser:emailTextField.text password:passwordTextField.text
    withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
    if (error) {
        // There was an error creating the account
    } else {
        NSString *uid = [result objectForKey:@"uid"];
        NSLog(@"Successfully created user account with uid: %@", uid);
    }
}];

    [ref authUser:emailTextField.text password:passwordTextField.text
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
        // There was an error logging in to this account
    } else {
        
        // We are now logged in
    }
}];

}


-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
