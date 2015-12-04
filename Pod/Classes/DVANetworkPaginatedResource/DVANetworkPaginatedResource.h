//
//  DVANetworkPaginatedResource.h
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <DVACache/DVACache.h>

typedef enum : NSUInteger {
    DVAPaginatedResponseCacheOrNetwork          = 0, // Cache or Network
    DVAPaginatedResponseCacheThenNetwork        = 1, // Cache then Network
    DVAPaginatedResponseNetworkOnly             = 2, // Network only
} DVAPaginatedResponse;

typedef void(^networkPaginatedResourceHandler)(BOOL fromCache,NSArray *items, NSInteger totalItemsCount, NSError *error);

@interface DVANetworkPaginatedResource : NSObject

@property (nonatomic, strong)               NSDictionary    *parameters;
@property (nonatomic, strong)               NSString        *nextURL;

@property (readonly, getter=isCompleted)    BOOL            completed;
@property (readonly, getter=isDownloading)  BOOL            downloading;

@property (nonatomic, copy)                 NSString        *emptyDatasetMessage;
@property (nonatomic, strong)               DVACache                *cache;
@property (nonatomic)                       DVAPaginatedResponse    cacheBehaviour;

@property (nonatomic)                       BOOL            debug;


-(instancetype)initWithApiProvider:(AFHTTPSessionManager*)manager
                   itemsArrayBlock:(NSArray *(^)(id jsonObject))itemsArray
                   itemsCountBlock:(NSInteger (^)(id jsonObject))itemsCountBlock
                     nextPageBlock:(NSString *(^)(id jsonObject))nextPageBlock;

- (void)nextBatch:(networkPaginatedResourceHandler)handler;

@end