//
//  DVANetworkPaginatedResource.m
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import "DVANetworkPaginatedResource.h"

@interface DVANetworkPaginatedResource ()

@property (nonatomic, strong) 	AFHTTPSessionManager *apiProvider;
@property (nonatomic, copy)     NSArray *(^itemsArray)(NSArray *);
@property (nonatomic, copy)     NSInteger(^itemsCountBlock)(id jsonObject);
@property (nonatomic, copy)     NSString *(^nextPageBlock)(id jsonObject);

@property (assign) BOOL downloading;

@end

@implementation DVANetworkPaginatedResource

- (instancetype)initWithApiProvider:(AFHTTPSessionManager *)manager
                    itemsArrayBlock:(NSArray *(^)(id))itemsArray
                    itemsCountBlock:(NSInteger (^)(id))itemsCountBlock
                      nextPageBlock:(NSString *(^)(id))nextPageBlock
{
    self = [super init];
    if (self) {
        _apiProvider=manager;
        _itemsArray=itemsArray;
        _nextPageBlock=nextPageBlock;
        _itemsCountBlock=itemsCountBlock;
    }
    return self;
}

- (BOOL)isCompleted {
    return (self.nextURL == nil);
}

-(DVACache*)cache{
    if (!_cache){
        _cache=[DVACache sharedInstance];
        [_cache setEnabled:YES];
    };
    return _cache;
}

-(void)setDebug:(BOOL)debug{
    _debug = debug;
    _cache.debug = DVACacheDebugLow;
}

- (void)nextBatch:(void(^)(BOOL fromCache, NSArray *items, NSInteger totalItemsCount, NSError *error))handler {
    NSAssert(self.apiProvider, @"No apiProvider configured");
    NSAssert(self.itemsArray, @"No itemsArray configured");
    NSAssert(self.nextPageBlock, @"No nextPageBlock configured");
    
    if (self.isDownloading) {
        return;
    }
    
    if (!self.nextURL) {
        handler(NO, [NSArray new], 0, nil);
        return;
    }
    
    NSString*cachedUrl=self.nextURL;
    if (self.parameters && self.parameters.count > 0) {
        NSMutableArray *array = [NSMutableArray new];
        for (NSString*parameterKey in self.parameters) {
            NSURLQueryItem *item = [[NSURLQueryItem alloc] initWithName:parameterKey value:self.parameters[parameterKey]];
            [array addObject:item];
        }
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:self.nextURL];
        [components setQueryItems:array];
        cachedUrl =  [components string];
    }
    
    self.downloading = YES;
    
    [self.cache objectForKey:cachedUrl withCompletionBlock:^(id jsonObject) {
        if (jsonObject &&
            self.cacheBehaviour != DVAPaginatedResponseNetworkOnly) // If we want cache...
        {
            [self processResponseForJson:jsonObject cached:YES withHandler:handler];
            if (self.cacheBehaviour != DVAPaginatedResponseCacheThenNetwork) return; // Make the call anyway
        }
        if (_debug) NSLog(@"-- %s -- \n Quering for :%@ parameters: %@",__PRETTY_FUNCTION__,self.nextURL,self.parameters);
        [self.apiProvider GET:self.nextURL parameters:self.parameters success:^(NSURLSessionDataTask *task, id json) {
            if (self.cache.enabled &&
                [self.itemsArray(json) count]>0) {
                [self.cache setObject:json forKey:self.nextURL];
            }
            if (_debug) NSLog(@"-- %s -- \n SUCCESS: %@ json: %@",__PRETTY_FUNCTION__,self.nextURL,json);
            [self processResponseForJson:json cached:NO withHandler:handler];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (_debug) NSLog(@"-- %s -- \n ERROR: %@ json: %@",__PRETTY_FUNCTION__,self.nextURL,error);
            if (_debug) NSLog(@"-- %s -- \n%@",__PRETTY_FUNCTION__,task.response.URL);
            self.downloading = NO;
            handler(NO,nil, 0, error);
        }];
    }];
}

-(void)processResponseForJson:(id)jsonObject cached:(BOOL)cached withHandler:(void(^)(BOOL fromCache, NSArray *items, NSInteger totalItemsCount, NSError *error))handler {
    NSArray *items = self.itemsArray(jsonObject);
    NSInteger count = self.itemsCountBlock(jsonObject);
    self.nextURL=self.nextPageBlock(jsonObject);
    self.downloading = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        handler(cached, items, count, nil);
    });
    
}
@end
