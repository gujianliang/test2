

#import <Foundation/Foundation.h>

#import "Address.h"
#import "BigNumber.h"

typedef NS_OPTIONS(NSUInteger, EtherFormatOption) {
    EtherFormatOptionNone         = 0,
    EtherFormatOptionCommify      = (1 << 0),
    EtherFormatOptionApproximate  = (1 << 1)
};



@interface Payment : NSObject


@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) BigNumber *amount;
@property (nonatomic, assign) BOOL firm;


+ (NSString*)formatEther: (BigNumber*)wei;
+ (NSString*)formatEther: (BigNumber*)wei options: (NSUInteger)options;

+ (BigNumber*)parseEther: (NSString*)etherString;

+ (BigNumber*)parseToken: (NSString*)etherString dicimals:(NSUInteger)decimals;
+ (NSString*)formatToken: (BigNumber*)wei decimals:(NSUInteger)decimals options: (NSUInteger)options;

@end
