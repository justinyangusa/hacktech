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
//@synthesize ref;
int x,y,z;

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)login:(id)sender {
    [super viewDidLoad];
    NSLog(@"same");
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://postmatesthing.firebaseio.com"];
    // Attach a block to read the data at our posts reference

        [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//            NSLog(@"%@", snapshot.value);
            NSLog(@"%@", snapshot.value);
//            NSLog(@"%@", snapshot.value[@"email"]);
//            NSLog(@"stuff = %@  %@", snapshot.key, snapshot.value[@"email"]);
//            NSLog(@"more stuff = %@  %@", snapshot.key, snapshot.value[@"password"]);
            NSLog(@"same at %@", [snapshot.value class]);
            NSLog(@"%@", snapshot.value[0]);

//            NSLog(@"Awedcawedc %@", [snapshot.value 0]);
            NSString *email = [NSString stringWithFormat:@"%@", snapshot.value[0][@"Email"]];
            
            NSString *password = [NSString stringWithFormat:@"%@", snapshot.value[0][@"Password"]];
            
            NSString *emailtext = [emailTextField text];
            NSString *passwordtext = [passwordTextField text];
            
        //         NSString *passwords = snapshot.value[@"password"];
            NSLog(@"a %@",emailtext);
            NSLog(@"b %@",passwordtext);
            NSLog(@"c %@", email);
            NSLog(@"d %@", password);

            if([email isEqualToString: emailtext] && [password isEqualToString: passwordtext]) {
                [self performSegueWithIdentifier:@"loginSuccess" sender:self];
            }
            else{
//                NSLog(@"a %@",emailtext);
//                NSLog(@"b %@",passwordtext);
//                NSLog(@"c %@", email);
//                NSLog(@"d %@", password);

                x=1;
                [self alert];
            }
            
        } withCancelBlock:^(NSError *error) {
            NSLog(@"%@", error.description);
        }];

    
//    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://postmatesthing.firebaseio.com/accounts"];
         //    NSString *username = emailTextField.text;
//    NSString *password = passwordTextField.text;
//    
//    [ref authUser:username password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
//    if (error) {
//        // There was an error logging in to this account
//        switch(error.code) {
//            case FAuthenticationErrorUserDoesNotExist:
//                NSLog(@"make an account");
//                // Handle invalid user
//                x = 0;
//                [self alert];
//                break;
//            case FAuthenticationErrorInvalidEmail:
//                // Handle invalid email
//                NSLog(@"the email doesnt exist");
//                x = 1;
//                [self alert];
//
//                break;
//            case FAuthenticationErrorInvalidPassword:
//                // Handle invalid password
//                NSLog(@"stahp hacking");
//                x = 2;
//                [self alert];
//                break;
//            default:
//                break;
//        }} else {
//        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
//
//        // We are now logged in
//    }
//}];
    

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
