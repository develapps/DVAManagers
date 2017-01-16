//
//  DVAFacebookManager.m
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import "DVAFacebookManager.h"
//
// FBSDKShareKit cannot be included in a pod
//
//#import <FBSDKShareKit/FBSDKShareKit.h>

@interface DVAFacebookManager () //<FBSDKSharingDelegate>

@property (strong, nonatomic)   DVAFacebookManagerSuccessBlock sharingBlock;
@property (nonatomic,strong)    DVACache*cache;
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
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLaunchingNotification:) name:UIApplicationDidFinishLaunchingNotification object:nil];
		
		_dva_permissions        = @[kDVAFBManagerFacebookEmail,
									kDVAFBManagerFacebookPublicProfile,
									kDVAFBManagerFacebookFriends];
		
		_dva_minimumPermissions = @[];//@[kDVAFBManagerFacebookEmail, kDVAFBManagerFacebookPublicProfile, kDVAFBManagerFacebookEmail];
		_cache = [[DVACache alloc] initWithName:@"DVAFacebookManager-Cache"];
		[_cache setDefaultEvictionTime:3600];
		[_cache setDefaultPersistance:DVACacheInMemory|DVACacheOnDisk];
	}
	
	return self;
}

-(void)setDebug:(BOOL)debug{
	_debug=debug;
	_cache.debug=debug?DVACacheDebugLow:DVACacheDebugNone;
}

#pragma mark - Generic methods

-(void)dva_requestWithGraphPath:(NSString *)path
				  andParameters:(NSDictionary *)parameters
			 andCompletionBlock:(DVAFacebookManagerCompletionBlock)completionBlock{
	[self dva_requestWithGraphPath:path httpMethod:nil andParameters:parameters andCompletionBlock:completionBlock];
}

-(void)dva_requestWithGraphPath:(NSString *)path
					 httpMethod:(NSString *)method
				  andParameters:(NSDictionary *)parameters
			 andCompletionBlock:(DVAFacebookManagerCompletionBlock)completionBlock{
	
	if (!method) method = @"GET";
	if (self.debug) NSLog(@"-- %s -- \n Requesting graph path %@ method %@ with parameters %@",__PRETTY_FUNCTION__,path,method,parameters);
	
	[[[FBSDKGraphRequest alloc] initWithGraphPath:path parameters:parameters HTTPMethod:method] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
		if (error) {
			if (self.debug) NSLog(@"-- %s -- \n ERROR: Request graph path %@ method %@ with parameters %@ failed with error %@",__PRETTY_FUNCTION__,path,method,parameters,error);
			completionBlock(nil, error,NO);
		}else{
			if (self.debug) NSLog(@"-- %s -- \n SUCCESS: Request graph path %@ method %@ with parameters %@: \rRESULT: %@",__PRETTY_FUNCTION__,path,method,parameters,result);
			completionBlock(result, nil,NO);
		}
	}];
}

#pragma mark - Public Methods

- (void)dva_loginWithCompletionBlock:(DVAFacebookManagerSuccessBlock)completionBlock {
	if (self.debug) NSLog(@"-- %s -- \n Starting login...",__PRETTY_FUNCTION__);
	FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
	[login logInWithReadPermissions:self.dva_permissions
				 fromViewController:nil
							handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
								if (error) {
									// Process error
									if (self.debug) NSLog(@"-- %s -- \nERROR: Login failed %@",__PRETTY_FUNCTION__,error);
									completionBlock(NO, error);
								} else if (result.isCancelled) {
									// Handle cancellations
									NSError *newError = [NSError dva_facebookErrorWithType:kDVAFBEErrorOperationCancelled];
									if (self.debug) NSLog(@"-- %s -- \nERROR: Login cancelled %@",__PRETTY_FUNCTION__,newError);
									completionBlock(NO, newError);
								} else {
									// If you ask for multiple permissions at once, you
									// should check if specific permissions missing
									for (NSString *permission in self.dva_minimumPermissions) {
										if (![result.grantedPermissions containsObject:permission]) {
											NSError *newError = [NSError dva_facebookErrorWithType:kDVAFBEMinimumPermissionsNotAcquired
																						   andData:@{kDVAFBKeyOriginalError:error?:@{},
																									 kDVAFBKeyFailingPermission:permission,}];
											
											if (self.debug) NSLog(@"-- %s -- \nERROR: Login failed %@, minimum permission %@ not acquired",__PRETTY_FUNCTION__,newError,permission);
											completionBlock(NO, newError);
											return;
										}
									}
									
									if (self.debug) NSLog(@"-- %s -- \n Login succeeded",__PRETTY_FUNCTION__);
									// Do work
									completionBlock(YES, nil);
								}
							}];
}

-(void)dva_userInfo:(NSArray *)info withCompletionBlock:(DVAFacebookManagerCompletionBlock)completionBlock{
	NSAssert(info, @"ERROR: You should pass the required fields");
	NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
	[parameters setValue:[info componentsJoinedByString:@","] forKey:kDVAFBManagerFacebookFields];
	if (self.debug) NSLog(@"-- %s -- \n Requesting user info for %@",__PRETTY_FUNCTION__,info);
	[self dva_requestWithGraphPath:kDVAFBManagerFacebookGraphMe andParameters:parameters andCompletionBlock:completionBlock];
}

- (void)dva_logout {
	if (self.debug) NSLog(@"-- %s -- \n Login out",__PRETTY_FUNCTION__);
	FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
	[login logOut];
}

- (void)dva_askForExtraPermissions:(NSArray *)extraPermissions
			   withCompletionBlock:(DVAFacebookManagerSuccessBlock)completionBlock{
	NSAssert(extraPermissions, @"-- %s -- \n extra permissions cannot be nil",__PRETTY_FUNCTION__);
	if (self.debug) NSLog(@"-- %s -- \n Asking for extra permissions %@",__PRETTY_FUNCTION__, extraPermissions);
	FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
	[login logInWithReadPermissions:extraPermissions
				 fromViewController:nil
							handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
								if (error) {
									// Process error
									if (self.debug) NSLog(@"-- %s -- \nERROR: Extra permissions failed %@",__PRETTY_FUNCTION__, error);
									completionBlock(NO, error);
								} else if (result.isCancelled) {
									// Handle cancellations
									
									NSError* newError = [NSError dva_facebookErrorWithType:kDVAFBEErrorOperationCancelled];
									if (self.debug) NSLog(@"-- %s -- \nERROR: Extra permissions cancelled %@",__PRETTY_FUNCTION__, newError);
									
									completionBlock(NO, newError);
								} else {
									// If you ask for multiple permissions at once, you
									// should check if specific permissions missing
									NSMutableSet *required = [NSMutableSet setWithArray:extraPermissions];
									[required minusSet:result.grantedPermissions];
									if ([required count]==0) { // All permissions are granted
										if (self.debug) NSLog(@"-- %s -- \n Extra permissions granted %@",__PRETTY_FUNCTION__, extraPermissions);
										completionBlock(YES,nil);
									}
									else{
										if (self.debug) NSLog(@"-- %s -- \nERROR: Extra permissions not granted %@",__PRETTY_FUNCTION__,required);
										completionBlock(NO,[NSError dva_facebookErrorWithType:kDVAFBEMinimumPermissionsNotAcquired
																					  andData:@{kDVAFBKeyFailingPermission:[required anyObject]}]);
									}
								}
							}];
}

- (BOOL)dva_checkPermission:(NSString *)permission{
	return ([[FBSDKAccessToken currentAccessToken] hasGranted:permission]);
}


- (NSString *)dva_accessToken {
	return [[FBSDKAccessToken currentAccessToken]tokenString];
}

#pragma mark - Facebook events
- (void)dva_activateFacebookEvents {
	[FBSDKAppEvents activateApp];
}

#pragma mark - Sharing methods

//  FBSDKShareKit cannot be included in pod
//
- (void)dva_shareContentUrl:(NSURL *)contentURL
					  title:(NSString *)title
				description:(NSString *)description
				   imageURL:(NSURL *)imageURL
				 controller:(UIViewController *)controller
				 completion:(DVAFacebookManagerSuccessBlock)completionBlock {
	if (self.debug) NSLog(@"-- %s -- \n Sharing content url %@\rtitle %@\rdescription %@\rimageUrl %@\rcontroller %@",__PRETTY_FUNCTION__,contentURL,title,description,imageURL,controller);
	
	//
	//    self.sharingBlock = completionBlock;
	//
	//    FBSDKShareLinkContent *content = [FBSDKShareLinkContent new];
	//    content.contentURL = contentURL;
	//    content.contentTitle = title;
	//    content.contentDescription = description;
	//
	//    FBSDKShareDialog *shareDialog = [FBSDKShareDialog new];
	//    [shareDialog setMode:FBSDKShareDialogModeFeedWeb ];
	//    [shareDialog setShareContent:content];
	//    [shareDialog setFromViewController:controller];
	//    [shareDialog setDelegate:self];
	//    [shareDialog show];
	NSAssert(NO, @"This method is not implemented as FBSDKShareKit cannot be included in pod");
}


#pragma mark - Usual helpers

- (void)dva_pictureForUserId:(NSString*)userId withCompletion:(DVAFacebookManagerCompletionBlock)completionBlock{
	NSDictionary *params = @{kDVAFBManagerFacebookType      : kDVAFBManagerFacebookAlbum,
							 kDVAFBManagerFacebookFields    : [@[kDVAFBManagerFacebookData,kDVAFBManagerFacebookUrl] componentsJoinedByString:@","]}; /* enum{thumbnail,small,album} */
	
	
	if ([self dva_checkPermission:kDVAFBManagerFacebookPhotos]) {
		[self dva_requestWithGraphPath:[NSString stringWithFormat:kDVAFBManagerFacebookGraphMePicture,userId]
						 andParameters:params
					andCompletionBlock:completionBlock];
	}
	else{
		NSError *error = [NSError dva_facebookErrorWithType:kDVAFBEErrorNoPermission andData:@{kDVAFBKeyFailingPermission:kDVAFBManagerFacebookPhotos}];
		if (self.debug) NSLog(@"-- %s -- \nERROR: Extra permissions required %@",__PRETTY_FUNCTION__,error);
		completionBlock(nil,error,NO);
	}
}

- (void)dva_albumsWithCompletionBlock:(DVAFacebookManagerCompletionBlock)completionBlock{
	
	NSDictionary *params = @{kDVAFBManagerFacebookFields:[@[kDVAFBManagerFacebookData,kDVAFBManagerFacebookName,kDVAFBManagerFacebookObjectId] componentsJoinedByString:@","]};
	
	if ([self dva_checkPermission:kDVAFBManagerFacebookPhotos]) {
		id resultCached=[self.cache objectForKey:kDVAFBManagerFacebookGraphMeAlbums];
		if (resultCached) {
			completionBlock(resultCached, nil,YES);
			return;
		}
		[self dva_requestWithGraphPath:kDVAFBManagerFacebookGraphMeAlbums
						 andParameters:params
					andCompletionBlock:completionBlock];
	}
	else{
		NSError *error = [NSError dva_facebookErrorWithType:kDVAFBEErrorNoPermission andData:@{kDVAFBKeyFailingPermission:kDVAFBManagerFacebookPhotos}];
		if (self.debug) NSLog(@"-- %s -- \nERROR: Extra permissions required %@",__PRETTY_FUNCTION__,error);
		completionBlock(nil,error,NO);
	}
}


- (void)dva_picturesWithAlbumId:(NSString *)albumId completionBlock:(DVAFacebookManagerCompletionBlock)completionBlock {
	
	NSDictionary *params = @{kDVAFBManagerFacebookType: kDVAFBManagerFacebookAlbum,
							 kDVAFBManagerFacebookFields:[@[kDVAFBManagerFacebookData,kDVAFBManagerFacebookImages,kDVAFBManagerFacebookImagesSource] componentsJoinedByString:@","]};
	NSString *graphPath  = [NSString stringWithFormat:kDVAFBManagerFacebookGraphAlbumPhotos,albumId];
	[self dva_requestWithGraphPath:graphPath andParameters:params andCompletionBlock:completionBlock];
}



- (void)dva_picturesFromProfileAlbumWithCompletionBlock:(DVAFacebookManagerCompletionBlock)completionBlock {
	[self dva_albumsWithCompletionBlock:^(id userData, NSError *error, BOOL cached) {
		NSString *albumId = nil;
		if (error) {
			completionBlock(userData,error,cached);
			return ;
		}
		
		for (NSDictionary *album in [userData objectForKey:kDVAFBManagerFacebookData]) {
			if ([album[kDVAFBManagerFacebookName] isEqualToString:kDVAFBManagerFacebookProfilePicturesAlbum]){
				albumId = album[kDVAFBManagerFacebookObjectId];
			}
		}
		
		if (!albumId) {
			completionBlock(nil, error,NO);
		}
		
		[self dva_picturesWithAlbumId:albumId completionBlock:^(id userData, NSError *error, BOOL cached) {
			completionBlock(userData, error,NO);
		}];
	}];
}

- (void)dva_friendsWithCompletionBlock:(DVAFacebookManagerCompletionBlock)completionBlock {
	NSDictionary*parameters = @{kDVAFBManagerFacebookFields:[@[kDVAFBManagerFacebookObjectId,kDVAFBManagerFacebookName] componentsJoinedByString:@","]};
	if ([self dva_checkPermission:kDVAFBManagerFacebookFriends]) {
		id resultCached=[self.cache objectForKey:kDVAFBManagerFacebookGraphFriends];
		if (resultCached) {
			completionBlock(resultCached, nil,YES);
			return;
		}
		[self dva_requestWithGraphPath:kDVAFBManagerFacebookGraphFriends
						 andParameters:parameters
					andCompletionBlock:completionBlock];
	}
	else{
		NSError *error = [NSError dva_facebookErrorWithType:kDVAFBEErrorNoPermission andData:@{kDVAFBKeyFailingPermission:kDVAFBManagerFacebookPhotos}];
		if (self.debug) NSLog(@"-- %s -- \nERROR: Extra permissions required %@",__PRETTY_FUNCTION__,error);
		completionBlock(nil,error,NO);
	}
}


#pragma mark - Private methods

// FBSDKShareKit cannot be included in a pod
//
///*!
// @abstract Sent to the delegate when the share completes without error or cancellation.
// @param sharer The FBSDKSharing that completed.
// @param results The results from the sharer.  This may be nil or empty.
// */
//- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
//
//    if (self.sharingBlock) {
//        if (results[@"postId"]) {
//            if (self.debug) NSLog(@"-- %s -- \n Sharing content succeed %@",__PRETTY_FUNCTION__,results[@"postId"]);
//
//            if (self.sharingBlock) self.sharingBlock (YES,nil);
//        }else{
//
//            NSError*error = [NSError dva_facebookErrorWithType:kDVAFBENotSharedContent andData:@{kDVAFBKeyResponseObject:results}];
//            if (self.debug) NSLog(@"-- %s -- \nERROR: Sharing content failed %@",__PRETTY_FUNCTION__,error);
//            if (self.sharingBlock) self.sharingBlock (NO,error);
//        }
//    }
//}
//
///*!
// @abstract Sent to the delegate when the sharer encounters an error.
// @param sharer The FBSDKSharing that completed.
// @param error The error.
// */
//- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
//    NSError*newError = [NSError dva_facebookErrorWithType:kDVAFBENotSharedContent andData:@{kDVAFBKeyOriginalError:error}];
//    if (self.debug) NSLog(@"-- %s -- \nERROR: Sharing content failed %@",__PRETTY_FUNCTION__,newError);
//    if (self.sharingBlock) self.sharingBlock (NO,newError);
//}
//
///*!
// @abstract Sent to the delegate when the sharer is cancelled.
// @param sharer The FBSDKSharing that completed.
// */
//- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
//    NSError*newError = [NSError dva_facebookErrorWithType:kDVAFBEErrorOperationCancelled];
//    if (self.debug) NSLog(@"-- %s -- \nERROR: Sharing content cancelled %@",__PRETTY_FUNCTION__,newError);
//    if (self.sharingBlock) self.sharingBlock (NO,newError);
//}

#pragma mark - App Delegate Notifications

- (void)didFinishLaunchingNotification:(NSNotification*)notification{
	NSDictionary*dict = notification.userInfo;
	NSDictionary*options = dict[kDVAFacebookManagerDidFinishLaunchingOptions];
	UIApplication*app = dict[kDVAFacebookManagerApplicationKey];
	[FBSDKApplicationDelegate.sharedInstance application:app didFinishLaunchingWithOptions:options];
}

- (void)didBecomeActiveNotification:(NSNotification *)notification {
	if (self.debug) NSLog(@"-- %s -- \n Activating facebook events",__PRETTY_FUNCTION__);
	//Install traking
	[[DVAFacebookManager shared] dva_activateFacebookEvents];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
