

#import <Foundation/Foundation.h>


extern NSErrorDomain RLPSerializationErrorDomain;

#define kRLPSerializationErrorInvalidObject       -1
#define kRLPSerializationErrorInvalidData         -2


@interface RLPSerialization : NSObject

+ (NSData *)dataWithObject:(NSObject*)object error:(NSError **)error;
+ (NSObject*)objectWithData:(NSData*)data error:(NSError **)error;

@end
