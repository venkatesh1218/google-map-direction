//
//  WebData.h
//  MobileDoctor
//
//  Created by visansoft on 22/11/14.
//  Copyright (c) 2014 visansoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebData : NSObject


+ (NSMutableURLRequest *) getRequest:(NSString *) url;

+ (NSMutableURLRequest *) apiRequest:(NSString *) url Response:(NSString *)responseBody Method:(NSString *)method;
+ (NSMutableURLRequest *) deleteRequest:(NSString *) url UserName:(NSString *) username Password:(NSString *)password;

@end
