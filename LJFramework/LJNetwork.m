//
//  LJNetwork.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/9.
//

#import "LJNetwork.h"
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>

typedef void (^SuccessComplete)(id object);
typedef void (^ErrorComplete)(NSError *error);

static NSString *_baseUrl = nil;

static NSMutableDictionary *_headers = nil;

static NSMutableDictionary *_defaultParams = nil;

static NSString *_codeKey = nil;

static NSString *_messageKey = nil;

static NSInteger _successCode = 200;

static NSTimeInterval _timeoutInterval = 30;

static ErrorComplete _allErrorComplete = nil;

static AFHTTPSessionManager *_manager = nil;

static NSMutableDictionary *_taskDic = nil;

@interface LJNetwork ()

@property (nonatomic, copy, class) ErrorComplete handleAllErrorComplete;

@property (nonatomic, strong, class, readonly) AFHTTPSessionManager *manager;

@property (nonatomic, strong, class, readonly) NSMutableDictionary *taskDic;

@end

@implementation LJNetwork

#pragma mark - Mehtods

+ (void)get:(NSString *)path
     params:(NSDictionary *)params
extraHeaders:(NSDictionary *)extraHeaders
 modelClass:(Class)class
    success:(void (^)(id _Nonnull))successComplete
    failure:(void (^)(NSError * _Nonnull))errorComplete {
    [self request:path
           isPost:NO
           params:params
     extraHeaders:extraHeaders
       modelClass:(Class)class
          success:successComplete
          failure:errorComplete];
}

+ (void)post:(NSString *)path
      params:(NSDictionary *)params
extraHeaders:(NSDictionary *)extraHeaders
  modelClass:(Class)class
     success:(void (^)(id _Nonnull))successComplete
     failure:(void (^)(NSError * _Nonnull))errorComplete {
    [self request:path
           isPost:YES
           params:params
     extraHeaders:extraHeaders
       modelClass:(Class)class
          success:successComplete
          failure:errorComplete];
}

+ (void)request:(NSString *)path
         isPost:(BOOL)isPost
         params:(NSDictionary *)params
   extraHeaders:(NSDictionary *)extraHeaders
     modelClass:(Class)class
        success:(void (^)(NSDictionary * _Nonnull))successComplete
        failure:(void (^)(NSError * _Nonnull))errorComplete {
    NSString *finalUrl = [path containsString:@"http"] || [path containsString:@"https"] ? path : [NSString stringWithFormat:@"%@%@", self.baseUrl, path];
    if ([self.taskDic.allKeys containsObject:finalUrl])
        return;
    
    
    NSMutableDictionary *finalParams = @{}.mutableCopy;
    [finalParams addEntriesFromDictionary:self.defaultParams];
    [finalParams addEntriesFromDictionary:params];
    
    NSMutableDictionary *finalHeaders = @{}.mutableCopy;
    [finalHeaders addEntriesFromDictionary:self.headers];
    [finalHeaders addEntriesFromDictionary:extraHeaders];
    
    NSURLSessionDataTask *task = [self.manager dataTaskWithHTTPMethod:isPost ? @"POST" : @"GET"
                                                            URLString:finalUrl
                                                           parameters:finalParams
                                                              headers:finalHeaders
                                                       uploadProgress:nil
                                                     downloadProgress:nil
                                                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonString = [responseObject yy_modelToJSONString];
        NSLog(@"%@", jsonString);
        [self.taskDic removeObjectForKey:finalUrl];
        
        id model = class ? [class yy_modelWithDictionary:responseObject] : responseObject;
        
        NSInteger code = [responseObject[self.codeKey] integerValue];
        if (code == self.successCode) {
            if (successComplete)
                successComplete(model);
        }else {
            NSError *error = [NSError errorWithDomain:task.currentRequest.URL.absoluteString code:code userInfo:nil];
            error.message = responseObject[self.messageKey];
            
            if (errorComplete)
                errorComplete(error);
            
            if (self.handleAllErrorComplete)
                self.handleAllErrorComplete(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.taskDic removeObjectForKey:finalUrl];
        
        if (errorComplete)
            errorComplete(error);
        
        if (self.handleAllErrorComplete)
            self.handleAllErrorComplete(error);
    }];
    
    [task resume];
    [self.taskDic setObject:task forKey:finalUrl];
}

+ (void)uploadImage:(NSString *)path
              image:(NSData *)imageData
            fileKey:(NSString *)fileKey
             params:(NSDictionary *)params
       extraHeaders:(NSDictionary *)extraHeaders
         modelClass:(Class)class
            success:(void (^)(id))successComplete
            failure:(void (^)(NSError *))errorComplete {
    NSString *finalUrl = [path containsString:@"http"] || [path containsString:@"https"] ? path : [NSString stringWithFormat:@"%@%@", self.baseUrl, path];
    if ([self.taskDic.allKeys containsObject:finalUrl])
        return;
    
    NSMutableDictionary *finalParams = @{}.mutableCopy;
    [finalParams addEntriesFromDictionary:self.defaultParams];
    [finalParams addEntriesFromDictionary:params];
    
    NSMutableDictionary *finalHeaders = @{}.mutableCopy;
    [finalHeaders addEntriesFromDictionary:self.headers];
    [finalHeaders addEntriesFromDictionary:extraHeaders];
    
    [self.manager POST:finalUrl
            parameters:finalParams
               headers:finalHeaders
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
        [formData appendPartWithFileData:imageData name:fileKey fileName:fileName mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonString = [responseObject yy_modelToJSONString];
        NSLog(@"%@", jsonString);
        [self.taskDic removeObjectForKey:finalUrl];
        
        id model = class ? [class yy_modelWithDictionary:responseObject] : responseObject;
        
        NSInteger code = [responseObject[self.codeKey] integerValue];
        if (code == self.successCode) {
            if (successComplete)
                successComplete(model);
        }else {
            NSError *error = [NSError errorWithDomain:task.currentRequest.URL.absoluteString code:code userInfo:nil];
            error.message = responseObject[self.messageKey];
            
            if (errorComplete)
                errorComplete(error);
            
            if (self.handleAllErrorComplete)
                self.handleAllErrorComplete(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.taskDic removeObjectForKey:finalUrl];
        
        if (errorComplete)
            errorComplete(error);
        
        if (self.handleAllErrorComplete)
            self.handleAllErrorComplete(error);
    }];
}


+ (void)hanleAllError:(void (^)(NSError * _Nonnull))errorCallback {
    self.handleAllErrorComplete = errorCallback;
}

+ (void)cancelAll {
    [self.taskDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSURLSessionDataTask *task, BOOL * _Nonnull stop) {
        [task cancel];
    }];
}

#pragma mark - Setter And Getter

+ (void)setBaseUrl:(NSString *)baseUrl {
    _baseUrl = baseUrl.copy;
}

+ (NSString *)baseUrl {
    return _baseUrl;
}

+ (NSMutableDictionary *)headers {
    if (!_headers)
        _headers = @{}.mutableCopy;
        
    return _headers;
}

+ (NSMutableDictionary *)defaultParams {
    if (!_defaultParams)
        _defaultParams = @{}.mutableCopy;
        
    return _defaultParams;
}

+ (void)setCodeKey:(NSString *)codeKey {
    _codeKey = codeKey.copy;
}

+ (NSString *)codeKey {
    return _codeKey;
}

+ (void)setMessageKey:(NSString *)messageKey {
    _messageKey = messageKey.copy;
}

+ (NSString *)messageKey {
    return _messageKey;
}

+ (void)setSuccessCode:(NSInteger)successCode {
    _successCode = successCode;
}

+ (NSInteger)successCode {
    return _successCode;
}

+ (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    _timeoutInterval = timeoutInterval;
}

+ (NSTimeInterval)timeoutInterval {
    return _timeoutInterval;
}

+ (void)setHandleAllErrorComplete:(ErrorComplete)handleAllErrorComplete {
    _allErrorComplete = [handleAllErrorComplete copy];
}

+ (ErrorComplete)handleAllErrorComplete {
    return _allErrorComplete;
}

+ (AFHTTPSessionManager *)manager {
    if (!_manager) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = self.timeoutInterval;
        config.timeoutIntervalForResource = self.timeoutInterval;
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", nil];
    }
    
    return _manager;
}

+ (NSMutableDictionary *)taskDic {
    if (!_taskDic)
        _taskDic = @{}.mutableCopy;
    
    return _taskDic;
}

@end

@implementation NSError (LJNetwork)

@dynamic message;

- (void)setMessage:(NSString *)message {
    objc_setAssociatedObject(self,  @selector(message), message, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)message {
    return objc_getAssociatedObject(self, @selector(message));
}

@end
