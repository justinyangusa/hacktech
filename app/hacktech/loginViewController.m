//
//  loginViewController.m
//  hacktech
//
//  Created by Kevin Fang on 2/27/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "loginViewController.h"

@interface loginViewController (){
    
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *passwordTextField;
}

@end

@implementation loginViewController
@synthesize ref;
int x,y,z;

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)login:(id)sender {
    [super viewDidLoad];
    NSString *username = emailTextField.text;
    NSString *password = passwordTextField.text;
    
    [ref authUser:username password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
        // There was an error logging in to this account
        switch(error.code) {
            case FAuthenticationErrorUserDoesNotExist:
                NSLog(@"make an account");
                // Handle invalid user
                x = 0;
                [self alert];
                break;
            case FAuthenticationErrorInvalidEmail:
                // Handle invalid email
                NSLog(@"the email doesnt exist");
                x = 1;
                [self alert];

                break;
            case FAuthenticationErrorInvalidPassword:
                // Handle invalid password
                NSLog(@"stahp hacking");
                x = 2;
                [self alert];
                break;
            default:
                break;
        }} else {
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];

        // We are now logged in
    }
}];
    

}

-(void) alert{
    NSString *message;
    NSString *alertText = @"Wrong login credentials";
    if(x==0){
        message = @"There's no account associated with this";
    }else if(x==1){
        message = @"There's no email associated with this";
    }
    else{
        message = @"Wrong password";
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertText
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
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
