//
//  ViewController.m
//  relayServer
//
//  Created by Bosko Petreski on 5/9/19.
//  Copyright © 2019 Bosko Petreski. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController{
    NSData *peer1;
    NSData *peer2;
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
 
    NSLog(@"%@",[NSByteCountFormatter stringFromByteCount:data.length countStyle:NSByteCountFormatterCountStyleFile]);
    
    if(data.length < 10){
        NSString *respond = [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding];
        
        if([respond isEqualToString:@"1"]){
            peer1 = address;
            NSLog(@"PEER 1 REGISTER");
        }
        else if([respond isEqualToString:@"2"]){
            peer2 = address;
            NSLog(@"PEER 2 REGISTER");
        }
        else if([respond isEqualToString:@"3"]){
            peer2 = peer1 = nil;
            NSLog(@"PEER RESET");
        }
        else{
            if(peer1 && peer2){
                NSLog(@"SEND ADDRESSES");
                NSLog(@"%@:%d",[GCDAsyncUdpSocket hostFromAddress:peer1],[GCDAsyncUdpSocket portFromAddress:peer1]);
                NSLog(@"%@:%d",[GCDAsyncUdpSocket hostFromAddress:peer2],[GCDAsyncUdpSocket portFromAddress:peer2]);
                [udpSocket sendData:peer1 toAddress:peer2 withTimeout:-1 tag:0];
                [udpSocket sendData:peer2 toAddress:peer1 withTimeout:-1 tag:0];
            }
        }
    }
    else{
        

        //RELAY OPTIONS
//        if([address isEqualToData:peer1]){
//            [udpSocket sendData:data toAddress:peer2 withTimeout:-1 tag:0];
//        }
//        else{
//            [udpSocket sendData:data toAddress:peer1 withTimeout:-1 tag:0];
//        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    peer1 = peer2 = nil;
    
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    if (![udpSocket bindToPort:3312 error:&error]){
        NSLog(@"Error starting server (bind): %@", error);
        return;
    }
    
    if (![udpSocket beginReceiving:&error]){
        [udpSocket close];
        NSLog(@"Error starting server (recv): %@", error);
        return;
    }
    
    [udpSocket enableBroadcast:YES error:nil];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
