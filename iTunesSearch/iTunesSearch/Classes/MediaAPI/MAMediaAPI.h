//
//  MAMediaAPI.h
//  iTunesSearch
//
//  Created by Michael Akopyants on 26/01/2017.
//  Copyright © 2017 devthanatos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAMediaAPI : NSObject
+ (instancetype)sharedAPI;

- (void) searchMediaQuery:(NSString*)query completion:(void (^)(NSArray *,NSError*)) completion;

@end
