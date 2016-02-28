//
//  SKSTTSViewController.h
//  SpeechKitSample
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKSTTSViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *ttsTextView;
@property (weak, nonatomic) IBOutlet UITextField *languageTextInput;
@property (weak, nonatomic) IBOutlet UIButton *toggleTtsButton;

@property (strong, nonatomic) NSString *languageCode;

- (IBAction) assignLanguageCode:(UITextField *)sender;

@end
