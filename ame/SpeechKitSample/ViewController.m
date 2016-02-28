//
//  ViewController.m
//  same
//
//  Created by Kevin Fang on 2/27/16.
//  Copyright © 2016 Nuance Communications. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h> 
#import <Firebase/Firebase.h>
#import "NSStrinAdditions.h"
#import "SKSConfiguration.h"
#import <SpeechKit/SpeechKit.h>

@interface ViewController () <SKTransactionDelegate, SKAudioPlayerDelegate> {
    IBOutlet UIView *vImagePreview;
    SKSession* _skSession;
    SKTransaction *_skTransaction;
}
//@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) UIImage *displayImage;

@end

#define dWidth self.view.frame.size.width
#define dHeight self.view.frame.size.height

@implementation ViewController
{
    AVCaptureStillImageOutput* stillImageOutput;
    UIImageView* capturedView;
    UIButton* capture;
    UILabel* label;
    int count;
    UIImageView *picture;
}
-(void)viewDidLoad{
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureDevice *device = [self frontFacingCameraIfAvailable];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    //stillImageOutput is a global variable in .h file: "AVCaptureStillImageOutput *stillImageOutput;"
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
}

-(AVCaptureDevice *)frontFacingCameraIfAvailable{
    
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    
    for (AVCaptureDevice *device in videoDevices){
        
        if (device.position == AVCaptureDevicePositionFront){
            
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if (!captureDevice){
        
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}

-(IBAction)captureNow{
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections){
        for (AVCaptureInputPort *port in [connection inputPorts]){
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo]){
                
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error){
        
        CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        if (exifAttachments){
            
            // Do something with the attachments if you want to.
            NSLog(@"attachements: %@", exifAttachments);
        }
        else
            NSLog(@"no attachments");
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        picture.image = image;
    }];
}


-(void)same {
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:nil
                                    repeats:NO];
    
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://postmatesthing.firebaseio.com"];

    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections)
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
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         } else {
             NSLog(@"no attachments");
         }

         UIImage *uploadImage = picture.image;
         NSData *imageData = UIImageJPEGRepresentation(uploadImage, 0.9);
         
         // using base64StringFromData method, we are able to convert data to string
         NSString *imageString = [NSString base64StringFromData:imageData length:[imageData length]];
         
         Firebase* firebaseRef = [[Firebase alloc] initWithUrl:@"https://blinding-torch-8272.firebaseio.com/images/data"];
         NSLog(@" same is %d", imageString);
         [firebaseRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
             long dataLength = snapshot.childrenCount;
             NSString *indexPath = [NSString stringWithFormat: @"%ld", dataLength];
             Firebase* newImageRef = [firebaseRef childByAppendingPath:indexPath];
             [newImageRef setValue:@{@"myImage": imageString, @"someObjectId": @"null"}];
         }];
     }];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}


-(void) tick:(NSTimer*)timer
{
    count = count - 1;
//    label.text = [NSString stringWithFormat:@"%d",count];
    if(count == 0)
    {
        count = 3;
//        [self captureNow];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initCapture{
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] init];
    
    AVCaptureStillImageOutput *newStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey,
                                    nil];
    
    
    [newStillImageOutput setOutputSettings:outputSettings];
    
    
    AVCaptureSession *newCaptureSession = [[AVCaptureSession alloc] init];
    
    if ([newCaptureSession canAddInput:newVideoInput]) {
        [newCaptureSession addInput:newVideoInput];
    }
    if ([newCaptureSession canAddOutput:newStillImageOutput]) {
        [newCaptureSession addOutput:newStillImageOutput];
    }
    self->stillImageOutput = newStillImageOutput;
    
    
//    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation: (__bridge CMSampleBufferRef)(newStillImageOutput)];
//    UIImage *image = [[UIImage alloc] initWithData:imageData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
NSString *spoken = @"same";

- (IBAction)toggleTts {
    NSLog(@"same");
    if (!_skTransaction) {
        // Start a TTS transaction
        _skTransaction = [_skSession speakString:spoken
                                    withLanguage:@"eng-USA"
                                        delegate:self];
        [self resetTransaction];

    } else {
        // Cancel the TTS transaction
        [_skTransaction cancel];
        
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
- (void)log:(NSString *)message
{

}

- (void)resetTransaction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _skTransaction = nil;
    }];
}
- (void)transaction:(SKTransaction *)transaction didFailWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    [self log:[NSString stringWithFormat:@"didFailWithError: %@. %@", [error description], suggestion]];
    
    // Something went wrong. Check Configuration.mm to ensure that your settings are correct.
    // The user could also be offline, so be sure to handle this case appropriately.
    
    [self resetTransaction];
}

#pragma mark - SKAudioPlayerDelegate

- (void)audioPlayer:(SKAudioPlayer *)player willBeginPlaying:(SKAudio *)audio
{
    [self log:@"willBeginPlaying"];
    
    // The TTS Audio will begin playing.
}

- (void)audioPlayer:(SKAudioPlayer *)player didFinishPlaying:(SKAudio *)audio
{
    [self log:@"didFinishPlaying"];
    
    // The TTS Audio has finished playing.
}



@end
