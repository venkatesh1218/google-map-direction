//
//  WebData.m
//  MobileDoctor
//
//  Created by visansoft on 22/11/14.
//  Copyright (c) 2014 visansoft. All rights reserved.
//

#import "WebData.h"

@implementation WebData


+ (NSMutableURLRequest *) getRequest:(NSString *) url {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
  
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
//    [request addValue:username forHTTPHeaderField:@"USERNAME"];
//    
//    [request addValue:password forHTTPHeaderField:@"PASSWORD"];
    
    //[request addValue:APPID forHTTPHeaderField:@"APPID"];

    return request;
}

+ (NSMutableURLRequest *) deleteRequest:(NSString *) url UserName:(NSString *) username Password:(NSString *)password{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"DELETE"];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    [request addValue:username forHTTPHeaderField:@"USERNAME"];
    
    [request addValue:password forHTTPHeaderField:@"PASSWORD"];
    
    //[request addValue:APPID forHTTPHeaderField:@"APPID"];
    
    return request;
}

+ (NSMutableURLRequest *) apiRequest:(NSString *) url Response:(NSString *)responseBody Method:(NSString *)method{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:method];
    
    [request setHTTPBody:[responseBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
//    [request addValue:username forHTTPHeaderField:@"USERNAME"];
//    
//    [request addValue:password forHTTPHeaderField:@"PASSWORD"];
    
   // [request addValue:APPID forHTTPHeaderField:@"APPID"];
    
    return request;
}

@end
