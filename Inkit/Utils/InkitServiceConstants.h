//
//  InkitServiceConstants.h
//  Inkit
//
//  Created by Cristian Pena on 10/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#ifndef Inkit_InkitServiceConstants_h
#define Inkit_InkitServiceConstants_h

// Direcciones de Inkit
#define kWebServiceBase                 @"http://inkit.digbang.com/api/"
#define kWebServiceAuthorization        @"auth/"
#define kWebServiceBoards               @"boards/"
#define kWebServiceCreate               @"create"
#define kWebServiceEdit                 @"edit"
#define kWebServiceDelete               @"delete"
#define kWebServiceTermsAndConditions   @"terms-and-conditions"
#define kWebServiceRegister             @"register/"
#define kWebServiceUser                 @"user"
#define kWebServiceLogin                @"login"
#define kWebServiceMyProfile            @"my-profile"
#define kWebServiceUsers                @"users/"
#define kwebServiceLogout               @"logout"
#define kWebServiceInks                 @"inks"
#define kWebServiceGetBoards            @"boards"
#define kWebServiceGetInk               @"search?"
#define kWebServiceArtist               @"artist"
#define kWebServiceArtist2              @"artist/"
#define kWebServiceShop                 @"shop"
#define kWebServiceSearch               @"/search"
#define kWebServiceSearch2              @"search"
#define kWebServiceProfileAccesToken    @"profile?"
#define kWebServiceDashboard            @"/dashboard?"
#define kWebServiceLike                 @"/like"
#define kWebServiceUnLike               @"/unlike"
#define kWebServiceStatics              @"statics/"
#define kWebServiceBodyParts            @"body-parts"
#define kWebServiceTattooTypes          @"tattoo-types"
#define kWebServiceTattooStyles         @"tattoo-styles"
#define kWebServiceAccessToken          @"access_token"
#define kWebServiceSocialLogin          @"/social-network"
#define kWebServiceReportReason         @"statics/flag-reasons"

#define kWebServiceGrantType            @"grant_type"
#define kWebServiceGrantTypePassword    @"password"
#define kWebServiceGrantTypeSocial      @"social_network"
#define kWebServiceClientId             @"client_id"
#define kWebServiceClientSecret         @"client_secret"
#define kWebServiceClientIdConstant     @"iGjQNtRDDyfC81HE"
#define kWebServiceClientSecretConstant @"TZSCAiYPKN2GsI7TyrX94SAi8ZVZNyhm"

// Respuestas de los WS
#define kHTTPResponseCodeOK                 200
#define kHTTPResponseCodeOKNoResponse       204
#define kTTPResponseCodeCreateUserFailed    422
#define kTTPResponseCodeBadCredentials      400
#define kTTPResponseCodeUnauthorized        401

// Ink JSON Constants
#define kInkDescription                 @"description"

typedef void (^ServiceResponseError)(NSError *error);
typedef void (^ServiceResponse)(id response, NSError* error);
typedef void (^ServiceResponseArray)(NSArray *response, NSError *error);
typedef void (^ServiceResponseDictionary)(NSDictionary *response, NSError *error);

#endif
