//
//  Request.h
//
//  Copyright © 2016. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface Request : NSObject

/** Sends request to server using URL and PARAMS
 */
+(void)requestToServerWithURL:(NSString *)url andParams:(NSMutableDictionary *)params success:(void(^)(id))success failure:(void(^)())failure token:(void(^)())token login:(void(^)())login access:(void(^)())access;

/** Downloads file from server by URL and saves it to PATH
 */
+(void)downloadFileFromUrl:(NSString *)url toPath:(NSString *)path success:(void(^)())success failure:(void(^)())failure;

@end
