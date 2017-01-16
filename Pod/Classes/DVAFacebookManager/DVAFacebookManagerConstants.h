//
//  DVAFacebookManagerConstants.h
//  Pods
//
//  Created by Pablo Romeu on 1/12/15.
//
//

#ifndef DVAFacebookManagerConstants_h
#define DVAFacebookManagerConstants_h

#pragma mark - General keys

static NSString *const kDVAFacebookManagerApplicationKey				= @"kDVAFacebookManagerApplicationKey";
static NSString *const kDVAFacebookManagerDidFinishLaunchingOptions		= @"kDVAFacebookManagerDidFinishLaunchingOptions";


static NSString *const kDVAFacebookManagerErrorDomain   = @"kDVAFacebookManagerErrorDomain";
static NSString *const kDVAFBKeyOriginalError   = @"kDVAFBKeyOriginalError";
static NSString *const kDVAFBKeyFailingPermission = @"kDVAFBKeyFailingPermission";
static NSString *const kDVAFBKeyResponseObject = @"kDVAFBKeyResponseObject";

static NSString * const kDVAFBManagerFacebookFields                     = @"fields";
static NSString * const kDVAFBManagerFacebookType                     = @"type";
static NSString * const kDVAFBManagerFacebookData                     = @"data";
static NSString * const kDVAFBManagerFacebookUrl                     = @"url";
static NSString * const kDVAFBManagerFacebookAlbum                     = @"album";
static NSString * const kDVAFBManagerFacebookObjectId = @"id";

#pragma mark - other keys
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
static NSString * const kDVAFBManagerFacebookImageTypeNormal             = @"normal";


//Permissions Parameters

static NSString * const kDVAFBManagerFacebookEmail                   = @"email";
static NSString * const kDVAFBManagerFacebookPublicProfile           = @"public_profile";
static NSString * const kDVAFBManagerFacebookEducation               = @"user_education_history";
static NSString * const kDVAFBManagerFacebookFriends                 = @"user_friends";
static NSString * const kDVAFBManagerFacebookPhotos                  = @"user_photos";
static NSString * const kDVAFBManagerFacebookBirthDay                = @"user_birthday";
static NSString * const kDVAFBManagerFacebookHometown                = @"user_hometown";
static NSString * const kDVAFBManagerFacebookAboutMe                 = @"user_about_me";
static NSString * const kDVAFBManagerFacebookImages                     = @"images";
static NSString * const kDVAFBManagerFacebookImagesSource                      = @"source";

#pragma mark - Graph Paths

static NSString * const kDVAFBManagerFacebookGraphMe            = @"me";
static NSString * const kDVAFBManagerFacebookGraphMePicture     = @"%@/picture?redirect=false";
static NSString * const kDVAFBManagerFacebookGraphMeAlbums      =@"me/albums";
static NSString * const kDVAFBManagerFacebookGraphFriends       =@"me/friends";

static NSString * const kDVAFBManagerFacebookGraphAlbumPhotos   =@"%@/photos";


#pragma mark - Other constants

static NSString * const kDVAFBManagerFacebookProfilePicturesAlbum                 = @"Profile Pictures";


#endif /* DVAFacebookManagerConstants_h */
