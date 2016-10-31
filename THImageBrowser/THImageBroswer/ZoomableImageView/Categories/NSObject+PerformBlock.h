#pragma mark Class Interface

#import <Foundation/Foundation.h>
@interface NSObject (PerformBlock)


#pragma mark -
#pragma mark Methods

- (void)performBlock: (dispatch_block_t)block 
	afterDelay: (NSTimeInterval)delay;

- (void)performBlockOnMainThread: (dispatch_block_t)block;

- (void)performBlockInBackground: (dispatch_block_t)block;


@end // @interface NSObject (PerformBlock)
