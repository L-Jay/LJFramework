//
//  LJNetwork.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/9.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface LJNetwork : NSObject

@property (nonatomic, copy, class) NSString *baseUrl;

@property (nonatomic, copy, class, readonly) NSMutableDictionary *headers;

@property (nonatomic, copy, class, readonly) NSMutableDictionary *defaultParams;

@property (nonatomic, copy, class) NSString *codeKey;

@property (nonatomic, copy, class) NSString *messageKey;

@property (nonatomic, class) NSInteger successCode;

@property (nonatomic, class) NSTimeInterval timeoutInterval;

+ (void)hanleAllError:(void(^)(NSError *error))errorCallback;

+ (void)get:(NSString *)path
     params:(NSDictionary *)params
extraHeaders:(NSDictionary *)extraHeaders
 modelClass:(Class)class
    success:(void(^)(id model))successComplete
failure:(void(^)(NSError *error))errorComplete;

+ (void)post:(NSString *)path
      params:(NSDictionary *)params
extraHeaders:(NSDictionary *)extraHeaders
  modelClass:(Class)class
     success:(void(^)(id model))successComplete
failure:(void(^)(NSError *error))errorComplete;

+ (void)uploadImage:(NSString *)path
              image:(NSData *)imageData
            fileKey:(NSString *)fileKey
        params:(NSDictionary *)params
  extraHeaders:(NSDictionary *)extraHeaders
    modelClass:(Class)class
       success:(void(^)(id model))successComplete
  failure:(void(^)(NSError *error))errorComplete;

@end

@interface NSError (LJNetwork)

@property (nonatomic, copy) NSString *message;

@end
