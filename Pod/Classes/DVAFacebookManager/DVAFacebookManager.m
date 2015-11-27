//
//  DVAFacebookManager.m
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import "DVAFacebookManager.h"

@interface DVAFacebookManager ()

@property (nonatomic, strong) NSArray * permissions;
@property (nonatomic, strong) NSArray * minimumPermissions;
@property (strong, nonatomic) DVAFacebookSuccessBlock sharingBlock;
@property (nonatomic,strong) DVACache*cache;
@end

@implementation DVAFacebookManager

#pragma mark - Init

+ (instancetype)shared {
    
    static DVAFacebookManager *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        _permissions        = @[kDVAFBManagerFacebookEmail,
                                kDVAFBManagerFacebookPublicProfile,
                                kDVAFBManagerFacebookFriends,
                                kDVAFBManagerFacebookBirthDay,
                                kDVAFBManagerFacebookPhotos,
                                kDVAFBManagerFacebookEducation,
                                kDVAFBManagerFacebookAboutMe];
        
        _minimumPermissions = @[];//@[kDVAFBManagerFacebookEmail, kDVAFBManagerFacebookPublicProfile, kDVAFBManagerFacebookEmail];
        _cache = [[DVACache alloc] initWithName:@"DVAFacebook-Cache"];
        [_cache setDefaultEvictionTime:3600];
        [_cache setDefaultPersistance:DVACacheInMemory|DVACacheOnDisk];
    }
    
    return self;
}

-(void)setDebug:(BOOL)debug{
    _debug=debug;
    _cache.debug=debug?DVACacheDebugLow:DVACacheDebugNone;
}

#pragma mark - Public Methods

- (void)loginWithCopletionBlock:(DVAFacebookCompletionBlock)completionBlock {
    
    [self loginWithFacebook:^(BOOL success, NSError *error) {
        if (!success) {
            completionBlock(nil, error);
        }
        
        [self userDataWithCompletionBlock:^(id userData, NSError *error) {
            completionBlock(userData, error);
        }];
    }];
}

- (void)logout {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
}

- (void)extraPermission:(NSString *)extraPermission withCopletionBlock:(DVAFacebookCompletionBlock)completionBlock {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[extraPermission]
                 fromViewController:nil
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    // Process error
                                    completionBlock(nil, error);
                                } else if (result.isCancelled) {
                                    // Handle cancellations
                                    completionBlock(nil, error);
                                } else {
                                    // If you ask for multiple permissions at once, you
                                    // should check if specific permissions missing
                                    if ([result.grantedPermissions containsObject:extraPermission]) {
                                        // Do work
                                        [self userDataWithCompletionBlock:^(id userData, NSError *error) {
                                            completionBlock(userData, error);
                                        }];
                                    }
                                }
                            }];
}

- (BOOL)checkPermission:(NSString *)permission{
    return ([[FBSDKAccessToken currentAccessToken] hasGranted:permission]);
}

- (BOOL)userLogged {
    return [FBSDKAccessToken currentAccessToken];
}

- (NSString *)accessToken {
    return [[FBSDKAccessToken currentAccessToken]tokenString];
}

//Facebook events
- (void)activateFacebookEvents {
    [FBSDKAppEvents activateApp];
}

- (void)activateIntallTraking {
    [FBSDKAppEvents activateApp];
}

- (void)friendsWithCompletionBlock:(DVAFacebookCompletionBlock)completionBlock {
    NSDictionary*parameters = @{@"fields":@"id,name"};
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:kDVAFBManagerFacebookFriends]) {
        id resultCached=[self.cache objectForKey:@"me/friends"];
        if (resultCached) {
            completionBlock(resultCached, nil);
            return;
        }
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             [self.cache setObject:result[@"data"] forKey:@"me/friends"];
             completionBlock(result[@"data"], error);
         }];
    }
}

- (void)pictureForUserId:(NSString*)userId withCompletion:(DVAFacebookCompletionBlock)completionBlock{
    NSDictionary *params = @{@"type": @"album",
                             @"fields":@"data,url"}; /* enum{thumbnail,small,album} */
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:kDVAFBManagerFacebookPhotos]) {
        [[[FBSDKGraphRequest alloc]
          initWithGraphPath:[NSString stringWithFormat:@"/%@/picture?redirect=false",userId]
          parameters:params
          HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                          id result,
                                                          NSError *error) {
            NSDictionary*aResult = result;
            if (self.debug) NSLog(@"%s %@",__PRETTY_FUNCTION__,result);
            completionBlock ([aResult[@"data"][@"url"] copy], error);
        }];
    }
    else {
        completionBlock(nil,nil);
    }
}

- (void)picturesFromProfileAlbumWithCompletionBlock:(DVAFacebookCompletionBlock)completionBlock {
    [self albumsWithCompletionBlock:^(id userData, NSError *error) {
        NSString *albumId = nil;
        for (NSDictionary *album in userData) {
            if ([album[@"name"] isEqualToString:@"Profile Pictures"]){
                albumId = album[@"id"];
            }
        }
        
        if (!albumId) {
            completionBlock(nil, error);
        }
        
        [self picturesWithAlbumId:albumId completionBlock:^(id userData, NSError *error) {
            completionBlock(userData, error);
        }];
    }];
}

- (void)albumsWithCompletionBlock:(DVAFacebookCompletionBlock)completionBlock{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:kDVAFBManagerFacebookPhotos]) {
        NSDictionary *params = @{@"fields":@"data,name,id"};
        id resultCached=[self.cache objectForKey:@"me/albums"];
        if (resultCached) {
            completionBlock(resultCached, nil);
            return;
        }
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/albums" parameters:params]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             NSArray *albumsArray = (NSArray *)result[@"data"];
             completionBlock(albumsArray,error);
         }];
    }
    else{
        completionBlock(nil,nil);
    }
}

- (void)picturesWithAlbumId:(NSString *)albumId completionBlock:(DVAFacebookCompletionBlock)completionBlock {
    
    NSDictionary *params = @{@"type": @"album",
                             @"fields":@"data,images,source"}; /* enum{thumbnail,small,album} */
    NSString *graphPath  = [NSString stringWithFormat:@"/%@/photos",albumId];
    NSMutableArray *pictures = [NSMutableArray new];
    
    // make the API call
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath: graphPath
                                  parameters:params
                                  HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,id result,NSError *error) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (self.debug) NSLog(@"%s %@",__PRETTY_FUNCTION__,str);
        
        for (NSDictionary *dictionary in (NSArray *)result[@"data"]) {
            NSDictionary*firstImage=[(NSArray*)[dictionary objectForKey:@"images"] firstObject];
            [pictures addObject:firstImage[@"source"]];
        }
        
        completionBlock ([pictures copy], error);
    }];
}

- (void)fillProfilePicture:(FBSDKProfilePictureView *)pictureView fromProfileId:(NSString *)profileId {
    [pictureView setProfileID:profileId];
    [pictureView setPictureMode:FBSDKProfilePictureModeSquare];
}

#pragma mark - Private methods

- (void)loginWithFacebook:(DVAFacebookSuccessBlock)successBlock  {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:self.permissions
                 fromViewController:nil
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    // Process error
                                    successBlock(NO, error);
                                } else if (result.isCancelled) {
                                    // Handle cancellations
                                    successBlock(NO, error);
                                } else {
                                    // If you ask for multiple permissions at once, you
                                    // should check if specific permissions missing
                                    for (NSString *permission in self.minimumPermissions) {
                                        if (![result.grantedPermissions containsObject:permission]) {
                                            successBlock(NO, error);
                                            return;
                                        }
                                    }
                                    
                                    // Do work
                                    successBlock(YES, nil);
                                }
                            }];
}

- (void)userDataWithCompletionBlock:(DVAFacebookCompletionBlock)completionBlock {
    
    //if ([FBSDKAccessToken currentAccessToken]) {
    
    NSArray *parametersArray = @[kDVAFBManagerFacebookFirstName,kDVAFBManagerFacebookLastName,kDVAFBManagerFacebookAbout,kDVAFBManagerFacebookEmail,kDVAFBManagerFacebookGender,kDVAFBManagerFacebookHometownKey,kDVAFBManagerFacebookEducationKey,kDVAFBManagerFacebookProviderId,kDVAFBManagerFacebookBirthDayKey];
    
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[parametersArray componentsJoinedByString:@","] forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (error) {
             completionBlock(nil, error);
         }else{
             completionBlock(result, nil);
         }
     }];
    //}
}

#pragma mark -
#pragma mark - Sharing Actions

- (void)shareContentUrl:(NSURL *)contentURL
                  title:(NSString *)title
            description:(NSString *)description
               imageURL:(NSURL *)imageURL
             controller:(UIViewController *)controller
             completion:(DVAFacebookSuccessBlock)completionBlock {
    
    self.sharingBlock = completionBlock;
    
    FBSDKShareLinkContent *content = [FBSDKShareLinkContent new];
    content.contentURL = contentURL;
    content.contentTitle = title;
    content.contentDescription = description;
    
    FBSDKShareDialog *shareDialog = [FBSDKShareDialog new];
    [shareDialog setMode:FBSDKShareDialogModeFeedWeb ];
    [shareDialog setShareContent:content];
    [shareDialog setFromViewController:controller];
    [shareDialog setDelegate:self];
    [shareDialog show];
}

/*!
 @abstract Sent to the delegate when the share completes without error or cancellation.
 @param sharer The FBSDKSharing that completed.
 @param results The results from the sharer.  This may be nil or empty.
 */
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    
    if (self.sharingBlock) {
        if (results[@"postId"]) {
            self.sharingBlock (YES,nil);
        }else{
            self.sharingBlock (NO,nil);
        }
    }
}

/*!
 @abstract Sent to the delegate when the sharer encounters an error.
 @param sharer The FBSDKSharing that completed.
 @param error The error.
 */
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    if (self.sharingBlock) self.sharingBlock (NO,error);
}

/*!
 @abstract Sent to the delegate when the sharer is cancelled.
 @param sharer The FBSDKSharing that completed.
 */
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    if (self.sharingBlock) self.sharingBlock (NO,nil);
}

#pragma mark - App Delegate Notifications

- (void)didBecomeActiveNotification:(NSNotification *)notification {
    if (self.debug) NSLog(@"%s %@",__PRETTY_FUNCTION__,notification);
    
    //Install traking
    [[DVAFacebookManager shared]activateIntallTraking];
    
    //Facebook Evnets
    [[DVAFacebookManager shared]activateFacebookEvents];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
