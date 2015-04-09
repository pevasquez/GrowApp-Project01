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
#define kWebServiceTermsAndConditions   @"terms-and-conditions"
#define kWebServiceRegister             @"register/"
#define kWebServiceUser                 @"user"
#define kWebServiceLogin                @"login"
#define kWebServiceMyProfile            @"my-profile"
#define kWebServiceUsers                @"users/"
#define kwebServiceLogout               @"logout"
#define kWebServiceInks                 @"inks"
#define kWebServiceGetBoards            @"boards?"
#define kWebServiceGetInk               @"search?access_token=3&keywords="
#define kWebServiceArtist               @"/artist"
#define kWebServiceArtist2              @"artist/"
#define kWebServiceSearch               @"/search"
#define kWebServiceSearch2              @"search"
#define kWebServiceProfileAccesToken    @"profile?access_token=3&user_id=2"
#define kWebServiceDashboardAccesToken  @"/dashboard?access_token="



// Respuestas de los WS
#define kHTTPResponseCodeOK                 200
#define kTTPResponseCodeCreateUserFailed    422
#define kTTPResponseCodeBadCredentials      400
#define kTTPResponseCodeUnauthorized        401

// Ink JSON Constants
#define kInkDescription                 @"description"

#endif
