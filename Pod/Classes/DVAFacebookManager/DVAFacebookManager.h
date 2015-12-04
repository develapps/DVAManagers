//
//  DVAFacebookManager.h
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

/*
 
 Remember to configure the app
 
 */

#import <Foundation/Foundation.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import <DVACache/DVACache.h>
#import "DVAFacebookManagerConstants.h"
#import "NSError+DVAFacebookManager.h"

typedef void(^DVAFacebookManagerCompletionBlock)(id userData, NSError *error, BOOL cachedData);
typedef void(^DVAFacebookManagerSuccessBlock)(BOOL success, NSError *error);

/*!
 @author Pablo Romeu, 15-12-01 13:12:20
 
 A facebook manager class
 
 @since 1.0.0
 */
@interface DVAFacebookManager : NSObject <FBSDKSharingDelegate>

/*!
 @author Pablo Romeu, 15-12-01 13:12:29
 
 A cache to be used by the facebook object
 
 @since 1.0.0
 */
@property (nonatomic,strong,readonly)   DVACache    *cache;
/*!
 @author Pablo Romeu, 15-12-01 13:12:51
 
 Debug flag
 
 @since 1.0.0
 */
@property (nonatomic)                   BOOL        debug;
/*!
 @author Pablo Romeu, 15-12-01 13:12:28
 
 Requested permissions. 
 
 Defaults to kDVAFBManagerFacebookEmail, kDVAFBManagerFacebookPublicProfile and kDVAFBManagerFacebookFriends
 
 @since 1.0.0
 */
@property (nonatomic, strong)           NSArray * dva_permissions;
/*!
 @author Pablo Romeu, 15-12-01 13:12:51
 
 Minimum requested permissions. If not provided login fails
 
 @since 1.0.0
 */
@property (nonatomic, strong)           NSArray * dva_minimumPermissions;

/*!
 @author Pablo Romeu, 15-12-01 13:12:02
 
 Shared instance.
 
 @return A manager instance
 
 @since 1.0.0
 */
+ (instancetype)shared;

#pragma mark - genericOps

/*!
 @author Pablo Romeu, 15-12-01 13:12:30
 
 Generic call for graphPath methods.
 
 @param path            the Graph Path
 @param method          the HTTP method
 @param parameters      the parameters, if needed
 @param completionBlock a completion block
 
 @since 1.0.0
 */
-(void)dva_requestWithGraphPath:(NSString*)path
                     httpMethod:(NSString*)method
                  andParameters:(NSDictionary*)parameters
             andCompletionBlock:(DVAFacebookManagerCompletionBlock)completionBlock;
/*!
 @author Pablo Romeu, 15-12-01 14:12:53
 
 Performs a facebook fetch
 
 Helper method for `dva_requestWithGraphPath:httpMethod:andParameters:andCompletionBlock:`
 
 @param path            the Graph Path
 @param parameters      the parameters, if needed
 @param completionBlock a completion block
 
 @since 1.0.0
 */
-(void)dva_requestWithGraphPath:(NSString *)path
                  andParameters:(NSDictionary *)parameters
             andCompletionBlock:(DVAFacebookManagerCompletionBlock)completionBlock;

#pragma mark - login and permisions
/*!
 @author Pablo Romeu, 15-12-01 13:12:49
 
 Requests login and returns user information.
 
 @param completionBlock a completion block
 
 @since 1.0.0
 */
- (void)dva_loginWithCompletionBlock:(DVAFacebookManagerSuccessBlock)completionBlock;
/*!
 @author Pablo Romeu, 15-12-01 13:12:55
 
 Asks for the user info with a completion block
 
 @param info            the info keys
 @param completionBlock a completion block
 
 @since 1.0.0
 */
- (void)dva_userInfo:(NSArray*)info withCompletionBlock:(DVAFacebookManagerCompletionBlock)completionBlock;
/*!
 @author Pablo Romeu, 15-12-01 13:12:41
 
 User logout
 
 @since 1.0.0
 */
- (void)dva_logout;

/*!
 @author Pablo Romeu, 15-12-01 13:12:17
 
 Asks for extra permissions
 
 @param extraPermissions the permissions
 @param completionBlock a completion block
 
 @since 1.0.0
 */
- (void)dva_askForExtraPermissions:(NSArray *)extraPermissions
               withCompletionBlock:(DVAFacebookManagerSuccessBlock)completionBlock;

/*!
 @author Pablo Romeu, 15-12-01 14:12:42
 
 Check if a permission has been granted
 
 @param permission the permission
 
 @return wheteher has the granted permission or not
 
 @since 1.0.0
 */
- (BOOL)dva_checkPermission:(NSString *)permission;

/*!
 @author Pablo Romeu, 15-12-01 14:12:07
 
 the access token
 
 @return returns a string with the current access token
 
 @since 1.0.0
 */
- (NSString *)dva_accessToken;

#pragma mark - facebook events
/*!
 @author Pablo Romeu, 15-12-01 14:12:09
 
 Activates facebook event colection
 
 @since 1.0.0
 */
#warning should save that we should track the events
- (void)dva_activateFacebookEvents;

#pragma mark -
#pragma mark - Actions
/*!
 @author Pablo Romeu, 15-12-01 14:12:21
 
 Content sharing. This is neede to share content to facebook
 
 @param contentURL      the content url, if any
 @param title           the title
 @param description     the description
 @param imageURL        the image url, if any
 @param controller      the controller if any
 @param completionBlock a completion block
 
 @since 1.0.0
 */
- (void)dva_shareContentUrl:(NSURL *)contentURL
                      title:(NSString *)title
                description:(NSString *)description
                   imageURL:(NSURL *)imageURL
                 controller:(UIViewController *)controller
                 completion:(DVAFacebookManagerSuccessBlock)completionBlock;


#pragma mark - Usual helpers

#pragma mark - images

/*!
 @author Pablo Romeu, 15-12-01 15:12:45
 
 Returns a user image with "album" size
 
 @param userId          the user ID
 @param completionBlock a completion block
 
 @since 1.0.0
 */
- (void)dva_pictureForUserId:(NSString*)userId withCompletion:(DVAFacebookManagerCompletionBlock)completionBlock;


/*!
 @author Pablo Romeu, 15-12-01 15:12:42
 
 Returns pictures' url from an Album
 
 @param completionBlock a completion block
 
 @since 1.0.0
 */
- (void)dva_albumsWithCompletionBlock:(DVAFacebookManagerCompletionBlock)completionBlock;
/*!
 @author Pablo Romeu, 15-12-01 15:12:41
 
 Returns picture images from an album
 
 @param completionBlock a completion block
 
 @since 1.0.0
 */
- (void)dva_picturesFromProfileAlbumWithCompletionBlock:(DVAFacebookManagerCompletionBlock)completionBlock;

/*!
 @author Pablo Romeu, 15-12-01 15:12:35
 
 Returns pictures from a concrete album
 
 @param albumId         the album Id
 @param completionBlock a completion block
 
 @since 1.0.0
 */
- (void)dva_picturesWithAlbumId:(NSString *)albumId
                completionBlock:(DVAFacebookManagerCompletionBlock)completionBlock;


#pragma mark - friends
/*!
 @author Pablo Romeu, 15-12-01 16:12:01
 
 Get friends with completion block
 
 @param completionBlock a completion block
 
 @since 1.0.0
 */
- (void)dva_friendsWithCompletionBlock:(DVAFacebookManagerCompletionBlock)completionBlock;
@end
