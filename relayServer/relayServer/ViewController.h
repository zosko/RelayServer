//
//  ViewController.h
//  relayServer
//
//  Created by Bosko Petreski on 5/9/19.
//  Copyright © 2019 Bosko Petreski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCDAsyncUdpSocket.h"

@interface ViewController : NSViewController <GCDAsyncUdpSocketDelegate>{
    GCDAsyncUdpSocket *udpSocket;
}


@end

