//
//  GBRemoteDebugMessages.m
//  GBToolbox
//
//  Created by Luka Mirosevic on 08/11/2014.
//  Copyright (c) 2014 Luka Mirosevic. All rights reserved.
//

#import "GBRemoteDebugMessages.h"

static NSString * const kDefaultServer =            @"localhost";
static UInt32 const kDefaultPort =                  10000;
static BOOL const kDefaultShouldLogLocallyAsWell =  NO;

@interface GBRemoteDebugMessages () <NSStreamDelegate>

@property (strong, nonatomic) NSMutableString       *buffer;
@property (assign, nonatomic) dispatch_queue_t      messagesQueue;
@property (strong, nonatomic) NSOutputStream        *outputStream;

@end

@implementation GBRemoteDebugMessages

+ (instancetype)sharedMessages {
    static GBRemoteDebugMessages *sharedMessages;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMessages = [self new];
    });
    return sharedMessages;
}

- (id)init {
    if (self = [super init]) {
        self.messagesQueue = dispatch_queue_create("com.goonbee.GBToolbox.GBRemoteDebugMessages.Queue", DISPATCH_QUEUE_SERIAL);
        self.shouldLogLocallyAsWell = kDefaultShouldLogLocallyAsWell;
        dispatch_async(self.messagesQueue, ^{
            self.buffer = [NSMutableString new];
        });
    }
    
    return self;
}

#pragma mark - API

- (void)sendRemoteDebugMessage:(NSString *)message, ... {
    va_list args;
    va_start(args, message);
    NSString *completeMessage = [[NSString alloc] initWithFormat:message arguments:args];
    va_end(args);
    
    [[GBRemoteDebugMessages sharedMessages] _sendRemoteDebugMessage:completeMessage];
}

- (void)_sendRemoteDebugMessage:(NSString *)completeMessage {
    dispatch_async(self.messagesQueue, ^{
        if (self.shouldLogLocallyAsWell) NSLog(@"%@", completeMessage);
        
        // make sure the stream exists
        if (!self.outputStream || !self.outputStream.hasSpaceAvailable) {
            [self _setupOutputStreamToServer:kDefaultServer onPort:kDefaultPort];
        }
        
        // just write the message to our buffer
        [self _addMessageToBuffer:completeMessage];
    });
}

- (void)routeRemoteDebugMessagesToServer:(NSString *)server onPort:(UInt32)port {
    dispatch_async(self.messagesQueue, ^{
        // sets up our stream
        [self _setupOutputStreamToServer:server onPort:port];
    });
}

#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventHasSpaceAvailable: {
            dispatch_async(self.messagesQueue, ^{
                [self _flushBufferToStream];
            });
        } break;
            
        default: {
            // noop
        } break;
    }
}

#pragma mark - Private

- (void)_addMessageToBuffer:(NSString *)message {
    // append it with a newline
    [self.buffer appendFormat:@"%@\n", message];
    
    // if we have space on our stream
//    if ([self.outputStream hasSpaceAvailable]) {
        // we flush the buffer
        [self _flushBufferToStream];
//    }
}

- (void)_flushBufferToStream {
    [self _writeStringToStream:self.buffer stream:self.outputStream];
    [self.buffer setString:@""];
}

- (void)_writeStringToStream:(NSString *)string stream:(NSOutputStream *)stream {
    // convert string to bytes
    NSData *messageData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // send string
    uint8_t *bytes = (uint8_t *)[messageData bytes];
    [stream write:bytes maxLength:messageData.length];
}

- (void)_setupOutputStreamToServer:(NSString *)server onPort:(UInt32)port {
    // clean up an old one if we have one
    if (self.outputStream) {
        [self.outputStream close];
        self.outputStream = nil;
    }
    
    // open socket and stream
    NSOutputStream *outputStream;
    [NSStream getStreamsToHostWithName:server port:port inputStream:nil outputStream:&outputStream];
    self.outputStream = outputStream;
    self.outputStream.delegate = self;
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream open];
}

@end

void SendRemoteDebugMessage(NSString *message, ...) {
    va_list args;
    va_start(args, message);
    NSString *completeMessage = [[NSString alloc] initWithFormat:message arguments:args];
    va_end(args);
    
    [[GBRemoteDebugMessages sharedMessages] _sendRemoteDebugMessage:completeMessage];
}

void RouteRemoteDebugMessagesToServerOnPort(NSString *server, UInt32 port) {
    [[GBRemoteDebugMessages sharedMessages] routeRemoteDebugMessagesToServer:server onPort:port];
}
