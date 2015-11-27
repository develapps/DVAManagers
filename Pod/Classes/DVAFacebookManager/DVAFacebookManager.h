//
//  DVAFacebookManager.h
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//


#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import <DVACache/DVACache.h>


// Keys
static NSString * const kDVAFBManagerFacebookName                      = @"name";
static NSString * const kDVAFBManagerFacebookFirstName                 = @"first_name";
static NSString * const kDVAFBManagerFacebookLastName                  = @"last_name";
static NSString * const kDVAFBManagerFacebookCaption                   = @"caption";
static NSString * const kDVAFBManagerFacebookDescription               = @"description";
static NSString * const kDVAFBManagerFacebookLink                      = @"link";
static NSString * const kDVAFBManagerFacebookPicture                   = @"picture";
static NSString * const kDVAFBManagerFacebookBirthDayKey               = @"birthday";
static NSString * const kDVAFBManagerFacebookAbout                     = @"bio";

static NSString * const kDVAFBManagerFacebookGender                      = @"gender";
static NSString * const kDVAFBManagerFacebookGenderMale                  = @"male";
static NSString * const kDVAFBManagerFacebookGenderFemale                = @"female";
static NSString * const kDVAFBManagerFacebookHometownKey                 = @"hometown";
static NSString * const kDVAFBManagerFacebookHometownName                = @"name";
static NSString * const kDVAFBManagerFacebookEducationKey                = @"education";
static NSString * const kDVAFBManagerFacebookEducationSchool             = @"school";
static NSString * const kDVAFBManagerFacebookEducationSchoolName         = @"name";
static NSString * const kDVAFBManagerFacebookProviderId                  = @"id";

//Permissions Parameters

static NSString * const kDVAFBManagerFacebookEmail                   = @"email";
static NSString * const kDVAFBManagerFacebookPublicProfile           = @"public_profile";
static NSString * const kDVAFBManagerFacebookEducation               = @"user_education_history";
static NSString * const kDVAFBManagerFacebookFriends                 = @"user_friends";
static NSString * const kDVAFBManagerFacebookPhotos                  = @"user_photos";
static NSString * const kDVAFBManagerFacebookBirthDay                = @"user_birthday";
static NSString * const kDVAFBManagerFacebookHometown                = @"user_hometown";
static NSString * const kDVAFBManagerFacebookAboutMe                 = @"user_about_me";


typedef void(^DVAFacebookCompletionBlock)(id userData, NSError *error);
typedef void(^DVAFacebookSuccessBlock)(BOOL success, NSError *error);

@interface DVAFacebookManager : NSObject <FBSDKSharingDelegate>

@property (nonatomic,strong,readonly)   DVACache    *cache;
@property (nonatomic)                   BOOL        debug;

+ (instancetype)shared;

#pragma mark - login and permisions
- (void)loginWithCopletionBlock:(DVAFacebookCompletionBlock)completionBlock;
- (BOOL)checkPermission:(NSString *)permission;
- (void)extraPermission:(NSString *)extraPermission withCopletionBlock:(DVAFacebookCompletionBlock)completionBlock;
- (BOOL)userLogged;
- (void)activateFacebookEvents;
- (NSString *)accessToken;
- (void)logout;

#pragma mark -
#pragma mark - Actions

- (void)shareContentUrl:(NSURL *)contentURL
                  title:(NSString *)title
            description:(NSString *)description
               imageURL:(NSURL *)imageURL
             controller:(UIViewController *)controller
             completion:(DVAFacebookSuccessBlock)completionBlock;

#pragma mark - images
- (void)fillProfilePicture:(FBSDKProfilePictureView *)pictureView fromProfileId:(NSString *)profileId;
- (void)pictureForUserId:(NSString*)userId withCompletion:(DVAFacebookCompletionBlock)completionBlock;
- (void)picturesFromProfileAlbumWithCompletionBlock:(DVAFacebookCompletionBlock)completionBlock;

- (void)albumsWithCompletionBlock:(DVAFacebookCompletionBlock)completionBlock;
- (void)picturesWithAlbumId:(NSString *)albumId completionBlock:(DVAFacebookCompletionBlock)completionBlock;


#pragma mark - friends

- (void)friendsWithCompletionBlock:(DVAFacebookCompletionBlock)completionBlock;
@end
