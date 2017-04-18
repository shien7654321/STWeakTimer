//
//  STWeakTimer.h
//  STWeakTimer
//
//  Created by Suta on 2017/4/14.
//  Copyright © 2017年 Suta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STWeakTimer : NSObject

@property (readonly) NSTimeInterval timeInterval;
@property NSTimeInterval tolerance;
@property (readonly) BOOL valid;
@property (strong, readonly, nullable) id userInfo;

#pragma mark -

+ (nullable instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(nonnull id)target selector:(nonnull SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats;
+ (nullable instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(nonnull id)target selector:(nonnull SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats dispatchQueue:(nullable dispatch_queue_t)queue;
+ (nullable instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval userInfo:(nullable id)userInfo repeats:(BOOL)repeats handler:(void(^ _Nullable)(STWeakTimer * _Nullable timer))handler;
+ (nullable instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval userInfo:(nullable id)userInfo repeats:(BOOL)repeats dispatchQueue:(nullable dispatch_queue_t)queue handler:(void(^ _Nullable)(STWeakTimer * _Nullable timer))handler;
+ (nullable instancetype)timerWithTimeInterval:(NSTimeInterval)interval target:(nonnull id)target selector:(nonnull SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats;
+ (nullable instancetype)timerWithTimeInterval:(NSTimeInterval)interval target:(nonnull id)target selector:(nonnull SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats dispatchQueue:(nullable dispatch_queue_t)queue;
+ (nullable instancetype)timerWithTimeInterval:(NSTimeInterval)interval userInfo:(nullable id)userInfo repeats:(BOOL)repeats handler:(void(^ _Nullable)(STWeakTimer * _Nullable timer))handler;
+ (nullable instancetype)timerWithTimeInterval:(NSTimeInterval)interval userInfo:(nullable id)userInfo repeats:(BOOL)repeats dispatchQueue:(nullable dispatch_queue_t)queue handler:(void(^ _Nullable)(STWeakTimer * _Nullable timer))handler;
- (void)schedule;
- (void)invalidate;
- (void)fire;
- (void)pause;
- (void)resume;

@end
