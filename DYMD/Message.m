//
//  Message.m
//  OSClib
//
//  Created by 蒋华阳 on 14-10-1.
//  Copyright (c) 2014年 蒋华阳. All rights reserved.
//

#import "Message.h"
#import "AsyncUdpSocket.h"
#import "OSCConnectionDelegate.h"
#import "OSCConnection.h"
#import "OSCDispatcher.h"
#import "OSCPacket.h"
#import "AppDelegate.h"

@implementation Message
static Message *shareMessage;
@synthesize address=_address;
@synthesize port=_port;
@synthesize IndicatorView;
@synthesize indicatorText;
+(Message*)shareMessage{
    if (shareMessage == nil) {
        shareMessage = [[Message alloc] init];
    }
    return shareMessage;
}
-(void)showIndicatorView{
    if (self.IndicatorView == nil) {
        self.IndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.IndicatorView setCenter:CGPointMake(570, 10)];
        [[[AppDelegate sharedAppDelegate] controller].view addSubview:self.IndicatorView];
    }
    if(self.indicatorText == nil) {
        self.indicatorText = [[UILabel alloc] initWithFrame:CGRectMake(585, -4, 200, 30)];
        [self.indicatorText setTextColor:[UIColor whiteColor]];
        [self.indicatorText setFont:[UIFont boldSystemFontOfSize:15]];
        [self.indicatorText setText:@"正在连接中控,请耐心等待..."];
        [[[AppDelegate sharedAppDelegate] controller].view addSubview:self.indicatorText];
    }
    [self.IndicatorView startAnimating];
    [self.indicatorText setHidden:false];
}
-(void)stopIndicatorView{
    [self.IndicatorView stopAnimating];
    [self.indicatorText setHidden:true];
}
//-(void)reConnectTip{
//    [self showIndicatorView];
//     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"与中控连接已经断开!" message:nil delegate:self cancelButtonTitle:@"点击重新连接" otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
//}
-(void)releaseMessage{
    [shareMessage release];
    shareMessage = nil;
    
}
-(void)connectTCP{
    [self showIndicatorView];
    if(syncFlag == true) {
        [NSThread sleepForTimeInterval:0.2f];
        //    [self reConnectTip];
        //    if (connection) {
        //        [connection disconnect];
        //        connection.delegate = nil;
        //        [connection release];
        //    }
        connection = [[OSCConnection alloc] init];
        connection.delegate = self;
        connection.continuouslyReceivePackets = YES;
        NSError *error;
        if (![connection connectToHost:self.address port:self.port protocol:OSCConnectionTCP_Int32Header error:&error])
        {
            NSLog(@"Could not bind TCP connection: %@", error);
        }
        syncFlag = false;
        [connection receivePacket];
    }
    
}
/*
-(void)connect{
    if (connection) {
        connection.delegate = nil;
        [connection release];
    }
    connection = [[OSCConnection alloc] init];
    connection.delegate = self;
    connection.continuouslyReceivePackets = YES;
    NSError *error;
    if (![connection bindToAddress:nil port:0 error:&error])
    {
        NSLog(@"Could not bind UDP connection: %@", error);
    } else {
        //[self stopIndicatorView];
    }
    [connection receivePacket];
}*/

-(id)initWithAddress:(NSString*)address port:(int)port{
    syncFlag =true;
    if ((self = [super init])) {
        self.address = address;
        self.port = port;
        [self connectTCP];
//        [self connect];
    }
    return self;
}
- (void)oscConnection:(OSCConnection *)con didSendPacket:(OSCPacket *)packet;
{
    NSLog(@".....");
    [self stopIndicatorView];
    //    ((UITextField *)[window viewWithTag:kTagLocalPort]).text = [NSString stringWithFormat:@"%hu", con.localPort];
    //    [self.text setText:[NSString stringWithFormat:@"发送包: localport %hu", con.localPort]];
}

- (void)oscConnection:(OSCConnection *)con didReceivePacket:(OSCPacket *)packet fromHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"KKKKK");
    //    ((UITextField *)[window viewWithTag:kTagReceivedValue]).text = [packet.arguments description];
    //    ((UITextField *)[window viewWithTag:kTagLocalAddress]).text = packet.address;
    //    NSLog(@"HHHHJJJJJJ");
    //[self.rectext setText:[NSString stringWithFormat:@"接受包 %@", [packet.arguments description]]];
    
}
//-(void)dealloc{
//    if (connection) {
//        connection.delegate = nil;
//        [connection release];
//    }
//    self.address = nil;
//    [super dealloc];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)sendMessage:(NSString*)address Int:(int)flag{
    
    if (address==nil) {
        return;
    }
    OSCMutableMessage *message = [[OSCMutableMessage alloc] init];
//    NSString *address =[NSString stringWithFormat:@"/layer1/%@/connect",name];
//    NSString *address =[NSString stringWithFormat:@"/layer1/%@/connect",name];
//    NSLog(@"FFF %@",address);
    message.address = address;
    [message addInt:flag];//@"192.168.0.190"
    [connection sendPacket:message toHost:self.address port:self.port];
    [message release];
}

- (void) oscConnectionDidConnect:(OSCConnection *)con{
    NSLog(@"Connection Established!");
    
    [self stopIndicatorView];
}

- (void)oscConnectionDidDisconnect:(OSCConnection *)con{
    
    [self showIndicatorView];
    NSLog(@"Detected Connection Disconnected!");
    if(syncFlag == false) {
        NSLog(@"Now connect to the server...");
        syncFlag = true;
        [self connectTCP];
    }
    //[self reConnectTip];
    
    //    NSError *error;
//    if (![connection connectToHost:self.address port:6000 protocol:OSCConnectionTCP_Int32Header error:&error])
//    {
//        NSLog(@"Could not bind TCP connection: %@", error);
//    } else {
//        [self stopIndicatorView];
//    }
}
- (void)oscConnection:(OSCConnection *)connection failedToReceivePacketWithError:(NSError *)error{
    NSLog(@"IIIIIII");
}
-(void)sendMessage:(NSString*)address Float:(float)volume{
    
    if (address==nil) {
        return;
    }
    OSCMutableMessage *message = [[OSCMutableMessage alloc] init];
    //    NSString *address =[NSString stringWithFormat:@"/layer1/%@/connect",name];
    //    NSString *address =[NSString stringWithFormat:@"/layer1/%@/connect",name];
    //    NSLog(@"FFF %@",address);
    message.address = address;
    [message addFloat:volume];//@"192.168.0.190"
//    [connection sendPacket:message toHost:self.address port:self.port];
    BOOL result = [connection sendPacket:message];
    if(result== FALSE) {
        [self connectTCP];
        
    }
    [message release];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    NSError *error = nil;
//    if (![connection connectToHost:self.address port:6000 protocol:OSCConnectionTCP_Int32Header error:&error])
//    {
//        NSLog(@"Could not bind TCP connection: %@", error);
//    }else {
//        [self stopIndicatorView];
//    }
//    
//}

@end
