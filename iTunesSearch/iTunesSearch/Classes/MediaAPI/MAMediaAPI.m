//
//  MAMediaAPI.m
//  iTunesSearch
//
//  Created by Michael Akopyants on 26/01/2017.
//  Copyright © 2017 devthanatos. All rights reserved.
//

#import "MAMediaAPI.h"

@implementation NSString (Urlencode)

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end

@interface MAMediaAPI ()

@property (strong, nonatomic) NSURLSessionDataTask * searchDataTask;

@end
@implementation MAMediaAPI

+ (instancetype)sharedAPI
{
    static MAMediaAPI *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSURL*)buildURLForQuery:(NSString*)query
{
    NSString * endpointString = [@"https://itunes.apple.com/search?media=music&entity=song&term=" stringByAppendingString:[query urlencode]];
    
    
    return [NSURL URLWithString:endpointString];
}

- (void)searchMediaQuery:(NSString *)query completion:(void (^)(NSArray *,NSError*))completion
{
    NSURL * url = [self buildURLForQuery:query];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    if (self.searchDataTask && self.searchDataTask)
    {
        [self.searchDataTask cancel];
    }
    self.searchDataTask = [session dataTaskWithURL:url completionHandler:^(NSData * data, NSURLResponse * response, NSError * error){
        if (error)
        {
            NSLog(@"%@",[error userInfo]);
        }
        NSArray * result = @[];
        if ([(NSHTTPURLResponse*)response statusCode] == 200)
        {
            //decode data
            NSDictionary * iTunesResponse = [self jsonFromNSData:data];
            
            if ([[iTunesResponse objectForKey:@"results"] isKindOfClass:[NSArray class]])
            {
                result = [iTunesResponse objectForKey:@"results"];
            }
        }
        
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^(){
                completion(result, error);
            });
        }
    }];
    [self.searchDataTask resume];
}

- (NSDictionary*)jsonFromNSData:(NSData*)data
{
    NSDictionary * jsonResponse = [[NSDictionary alloc] init];
    NSError * error;
    jsonResponse = [NSJSONSerialization
                    JSONObjectWithData:data
                    options:NSJSONReadingMutableLeaves
                    error:&error];
    if (error)
    {
        NSLog(@"%@",[error userInfo]);
    }
    return jsonResponse;
}

@end
