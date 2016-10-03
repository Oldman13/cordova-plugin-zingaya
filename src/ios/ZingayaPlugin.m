//
//  ZingayaPlugin.m
//

#import "ZingayaPlugin.h"
#import "ZingayaSDKiOS.h"
#import "ZingayaTypes.h"

@interface ZingayaPlugin () {
    
    __block CDVPluginResult *pluginResult;
    
}

@property (strong, nonatomic) ZingayaSDKiOS *sdk;

@end

@implementation ZingayaPlugin

- (void) call:(CDVInvokedUrlCommand*)command
{
    self.currentCommand = command;
    
    if (!self.sdk) {
        self.sdk = [ZingayaSDKiOS new];
        [self.sdk setDelegate:self];
        currentState = Idle;
        callId = NULL;
    }
    
    switch (currentState)
    {
        case Idle:
            [self setState:Connecting];
            NSLog(@"Connecting to server...");
            [self.sdk connect];
            break;
        case Disconnecting:
            [self onConnectionSuccessful];
            break;
        case Calling:
        case Speaking:
        default:
            break;
    }
}

- (void) hangup:(CDVInvokedUrlCommand*)command
{
    self.currentCommand = command;
    switch (currentState)
    {
        case Idle:
        case Calling:
        case Speaking:
            [self setState:Disconnecting];
            [self.sdk disconnectCall:callId];
            break;
        default:
            break;
    }
}

- (void) microphoneOn:(CDVInvokedUrlCommand*)command
{
    if (self.sdk) {
        [self.sdk setMute:false];
        [self setOKResult:@""];
    } else {
        [self setErrorResult:@"Error initialization sdk"];
    }
}

- (void) microphoneOff:(CDVInvokedUrlCommand*)command
{
    if (self.sdk) {
        [self.sdk setMute:true];
        [self setOKResult:@""];
    } else {
        [self setErrorResult:@"Error initialization sdk"];
    }
}

/*
 *---------------
 * Local methods
 *---------------
 */

- (void)setState: (AppState) state
{
    currentState = state;
}

- (void) onConnectionSuccessful
{
    
    NSLog(@"Connected to server");
    [self setState:Calling];
    
    callId = [[NSString alloc] initWithString:[self.sdk createCall:@"a775f92b4754224fa36df44123074253" withVideo:NO]] ;
    
    [self.sdk startCall:callId withHeaders:Nil];
    [self.sdk attachAudioTo:callId];
}

- (void) onConnectionClosed
{
    NSLog(@"Connection to server closed");
    [self setState:Idle];
}

- (void) onConnectionFailed: (NSString *) reason
{
    NSLog(@"Connection to server failed: %@", reason);
    [self setState:Idle];
    [self setErrorResult:[NSString stringWithFormat:@"Connection to server failed: %@", reason]];
}

- (void) onCallConnected: (NSString *) callId
{
    NSLog(@"Call connected");
    [self setState:Speaking];
    [self setOKResult:@"Call connected"];
}

- (void) onCallDisconnected: (NSString *) call
{
    NSLog(@"Call ended");
    [self setState:Disconnecting];
    //[self.sdk closeConnection];
    callId = NULL;
    [self setOKResult:@"Call disconnected."];
}

- (void) onCallRinging: (NSString *) callId
{
    NSLog(@"Call ringing");
}

- (void) onCallFailed:(NSString *)cid withCode:(int)code andReason:(NSString *)reason
{
    NSLog(@"Call failed: %@", reason);
    [self setState:Disconnecting];
    [self.sdk closeConnection];
    callId = NULL;
    self.sdk = NULL;
    [self setErrorResult:[NSString stringWithFormat:@"Call failed: %d %@", code, reason]];
}

- (void) onCallStartAudio: (NSString *) callId
{
    
}

- (void) onAuthOk: (NSString *) displayName
{
    
}

- (void) onAuthFailed
{
    
}

- (void) onAudioInterruptionBegan
{
    
}

- (void) onAudioInterruptionEnded
{
    
}

-(void) onVoicemail:(NSString *)callId
{
    
}

- (void) drawIncomingVideo: (const unsigned char *) data: (int) width: (int) height: (int) linesize
{
    
}

-(void)setOKResult:(NSString *)message
{
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [pluginResult setKeepCallbackAsBool:false];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.currentCommand.callbackId];
}

-(void)setErrorResult:(NSString *)message
{
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    [pluginResult setKeepCallbackAsBool:false];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.currentCommand.callbackId];
}

@end
