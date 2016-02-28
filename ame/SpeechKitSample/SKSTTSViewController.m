//
//  SKSTTSViewController.m
//  same
//
//  Created by Kevin Fang on 2/27/16.
//  Copyright © 2016 Nuance Communications. All rights reserved.
//


#import "SKSTTSViewController.h"
#import "SKSConfiguration.h"
#import <SpeechKit/SpeechKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>
#import "NSStrinAdditions.h"
#import <Firebase/Firebase.h>
#import "NSData+Base64.h"


@interface SKSTTSViewController () <SKTransactionDelegate, SKAudioPlayerDelegate> {
    SKSession* _skSession;
    SKTransaction *_skTransaction;
    UIImageView *imageview;
    int count;

}

@property(nonatomic, retain) IBOutlet UIImageView *vImage;

@property (weak, nonatomic) IBOutlet UIView *vImagePreview;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;



@end

@implementation SKSTTSViewController

@synthesize toggleTtsButton;
@synthesize languageCode;
@synthesize ttsTextView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    CALayer *viewLayer = self.vImagePreview.layer;
    NSLog(@"viewLayer = %@", viewLayer);
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
    [self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:_stillImageOutput];
    
    [session startRunning];
    
}

-(IBAction)captureNow {
    UIImage *uploadImage;
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", _stillImageOutput);
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         } else {
             NSLog(@"no attachments");
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
        
         _imageView2.image = image;
         NSData *dataFromBase64 = UIImageJPEGRepresentation(image,0.6);
         UIImage *image2 = [[UIImage alloc] initWithData:dataFromBase64];

//         UIImage *image = [[UIImage alloc] initWithData:dataFromBase64];
         imageview.image = image;
//         NSLog(image);
         NSString *same2 = [self encodeToBase64String: image2];
         NSString *same = [self encodeToBase64String:image];
         
         
         //    Firebase* firebaseRef = [[Firebase alloc] initWithUrl:@"https://blinding-torch-8272.firebaseio.com/"];
         
         
         //    [firebaseRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
         //        long dataLength = snapshot.childrenCount;
         //        NSString *indexPath = [NSString stringWithFormat: @"%ld", dataLength];
         
         [[[[Firebase alloc] initWithUrl:@"https://blinding-torch-8272.firebaseio.com/"] childByAppendingPath:@"same"] setValue:same];
         [[[[Firebase alloc] initWithUrl:@"https://blinding-torch-8272.firebaseio.com/"] childByAppendingPath:@"waed"] setValue:same2];

         NSLog(@"KAEBJOAIRJEFIO %@",same);
         //        [[newImageRef childByAppendingPath:@"same"] childByAppendingPath:same];
         //        Firebase *post2Ref = [ref childByAutoId];
         //        [currentData setValue:[NSNumber numberWithInt:(1 + [value intValue])]];
         //        Firebase *post1Ref = [newImageRef childByAutoId];
         //        [post1Ref setValue: same];
         
         //        [newImageRef setValue:@{@"myImage": same}];
         //    }];

         [self.view addSubview:_imageView2];
//         [self.view addSubview:image];
     }];
    
//    NSString *same = @"Same";

}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImageJPEGRepresentation(image,0.6) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _skTransaction = nil;
    self.languageCode = @"eng-USA";
    self.languageTextInput.text = self.languageCode;
    
    _skSession = [[SKSession alloc] initWithURL:[NSURL URLWithString:SKSServerUrl] appToken:SKSAppKey];
    
    if (!_skSession) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"SpeechKit"
                                                           message:@"Failed to initialize SpeechKit session."
                                                          delegate:nil cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

#pragma mark - TTS Transactions

- (IBAction)toggleTts:(UIButton *)sender {
    if (!_skTransaction) {
        // Start a TTS transaction
        _skTransaction = [_skSession speakString:self.ttsTextView.text
                                    withLanguage:self.languageCode
                                        delegate:self];
        
//        [toggleTtsButton setTitle:@"cancel" forState:UIControlStateNormal];
    } else {
        // Cancel the TTS transaction
        [_skTransaction cancel];
        
        [self resetTransaction];
    }

}

#pragma mark - SKTransactionDelegate

- (void)transaction:(SKTransaction *)transaction didReceiveAudio:(SKAudio *)audio
{
    
    [self resetTransaction];
}

- (void)transaction:(SKTransaction *)transaction didFinishWithSuggestion:(NSString *)suggestion
{
    // Notification of a successful transaction. Nothing to do here.
}

- (void)transaction:(SKTransaction *)transaction didFailWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    
    // Something went wrong. Check Configuration.mm to ensure that your settings are correct.
    // The user could also be offline, so be sure to handle this case appropriately.
    
    [self resetTransaction];
}

#pragma mark - SKAudioPlayerDelegate



#pragma mark - Other Actions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.ttsTextView isFirstResponder] && [touch view] != self.ttsTextView) {
        [self.ttsTextView resignFirstResponder];
    }
    else if ([self.languageTextInput isFirstResponder] && [touch view] != self.languageTextInput) {
        [self.languageTextInput resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


- (IBAction)assignLanguageCode:(UITextField *)sender
{
    self.languageCode = sender.text;
}

#pragma mark - Helpers


- (void)log:(NSString *)message
{
//    self.logTextView.text = [self.logTextView.text stringByAppendingFormat:@"%@\n", message];
}

- (void)resetTransaction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _skTransaction = nil;
//        [toggleTtsButton setTitle:@"speakString" forState:UIControlStateNormal];
    }];
}


@end
