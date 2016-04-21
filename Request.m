//
//  Request.m
//
//  Copyright © 2016. All rights reserved.
//

#import "DDLog.h"
#import "Request.h"

@implementation Request

+(RESPONSE_TYPE)getResultFromServer:(id*)data fromResponseObject:(id)responseObject
{
    NSError* error;
    NSDictionary* response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
    NSString* responseCode = [[response objectForKey:@"apiResult"] objectForKey:@"responseCode"];
    
    if([responseCode isEqualToString:@"LOGIN_FAILURE"])
        return RESPONSE_TYPE_LOGIN_FAILURE;
    if([responseCode isEqualToString:@"TOKEN_INVALID"])
        return RESPONSE_TYPE_TOKEN_INVALID;
    if([responseCode isEqualToString:@"ACCESS_DENIED"])
        return RESPONSE_TYPE_ACCESS_DENIED;
    if([responseCode isEqualToString:@"OK"])
    {
        *data = [response objectForKey:@"data"];
        return RESPONSE_TYPE_OK;
    }
    return RESPONSE_TYPE_TOKEN_INVALID;
}

+(AFSecurityPolicy *)getAFSecurityPolicy
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:NO];
    
    return securityPolicy;
}

+(void)requestToServerWithURL:(NSString *)url andParams:(NSMutableDictionary *)params success:(void(^)(id))success failure:(void(^)())failure token:(void(^)())token login:(void(^)())login access:(void(^)())access
{
    DDLogInfo(@"%@: Request sent to: %@ \n with parameters: %@", THIS_FILE, url, params);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy = [self getAFSecurityPolicy];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id responseData;
        RESPONSE_TYPE responseType = [self getResultFromServer:&responseData fromResponseObject:responseObject];
        switch (responseType) {
            case RESPONSE_TYPE_TOKEN_INVALID:
                token();
                break;
            case RESPONSE_TYPE_LOGIN_FAILURE:
                login();
                break;
            case RESPONSE_TYPE_ACCESS_DENIED:
                access();
                break;
            case RESPONSE_TYPE_OK:
                success(responseData);
                break;
            default:
                break;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@: Error occurred during request: %@ %@", THIS_FILE, url, error);
        failure();
    }];
}

+(void)downloadFileFromUrl:(NSString *)url toPath:(NSString *)path success:(void(^)())success failure:(void(^)())failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [self getAFSecurityPolicy];
    
    NSProgress *progress;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        return [documentsDirectoryPath URLByAppendingPathComponent:path];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error == nil) {
            success();
            DDLogInfo(@"%@: File downloaded to: %@", THIS_FILE, filePath);
        }
        else if([error code] != -999){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"errorOccurred", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alertView show];
        }
        else {
            failure();
            DDLogError(@"%@: Error occurred during file download: %@ %@", THIS_FILE, url, error);
        }
    }];
    [downloadTask resume];
}

@end
