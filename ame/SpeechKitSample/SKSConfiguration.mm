//
//  SKSConfiguration.mm
//  SpeechKitSample
//
//  All Nuance Developers configuration parameters can be set here.
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

#import "SKSConfiguration.h"

// All fields are required.
// Your credentials can be found in your Nuance Developers portal, under "Manage My Apps".
NSString* SKSAppKey = @"756eb13b15ec420df5ce3f8338db56dd3ea6fce40477bacfab987f37fcd17e713f30ac541cef6112bda195f57cebd2ba91ce9e96455865f0f0e427ecb5a65df4";
NSString* SKSAppId = @"NMDPTRIAL_kevinfang28_gmail_com20160213040012";
NSString* SKSServerHost = @"sslsandbox.nmdp.nuancemobility.net";
NSString* SKSServerPort = @"443";



NSString* SKSServerUrl = [NSString stringWithFormat:@"nmsps://%@@%@:%@", SKSAppId, SKSServerHost, SKSServerPort];

// Only needed if using NLU/Bolt
NSString* SKSNLUContextTag = @"!NLU_CONTEXT_TAG!";


