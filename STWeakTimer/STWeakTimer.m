//
//  STWeakTimer.m
//  STWeakTimer
//
//  Created by Suta on 2017/4/14.
//  Copyright © 2017年 Suta. All rights reserved.
//

#import "STWeakTimer.h"
#import <libkern/OSAtomic.h>

#pragma mark -

@implementation STWeakTimer {
    __weak id _target;
    SEL _selector;
    BOOL _repeats, _scheduled;
    dispatch_queue_t _queue;
    dispatch_source_t _timer;
    struct {
        uint32_t invalidated;
    } _timerFlag;
    OSSpinLock _lock;
    void(^_handler)(STWeakTimer * _Nullable timer);
}

@synthesize tolerance = _tolerance;

- (void)dealloc {
    [self invalidate];
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:target selector:selector userInfo:userInfo repeats:repeats dispatchQueue:nil];
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats dispatchQueue:(dispatch_queue_t)queue {
    STWeakTimer *timer = [self timerWithTimeInterval:interval target:target selector:selector userInfo:userInfo repeats:repeats dispatchQueue:queue];
    [timer schedule];
    return timer;
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval userInfo:(id)userInfo repeats:(BOOL)repeats handler:(void (^)(STWeakTimer * _Nullable))handler {
    return [self scheduledTimerWithTimeInterval:interval userInfo:userInfo repeats:repeats dispatchQueue:nil handler:handler];
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval userInfo:(id)userInfo repeats:(BOOL)repeats dispatchQueue:(dispatch_queue_t)queue handler:(void (^)(STWeakTimer * _Nullable))handler {
    STWeakTimer *timer = [self timerWithTimeInterval:interval userInfo:userInfo repeats:repeats dispatchQueue:queue handler:handler];
    [timer schedule];
    return timer;
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats {
    return [self timerWithTimeInterval:interval target:target selector:selector userInfo:userInfo repeats:repeats dispatchQueue:dispatch_get_main_queue()];
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats dispatchQueue:(dispatch_queue_t)queue {
    return [[self alloc] initWithTimeInterval:interval target:target selector:selector userInfo:userInfo repeats:repeats dispatchQueue:queue handler:nil];
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval userInfo:(id)userInfo repeats:(BOOL)repeats handler:(void (^)(STWeakTimer * _Nullable))handler {
    return [self timerWithTimeInterval:interval userInfo:userInfo repeats:repeats dispatchQueue:nil handler:handler];
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval userInfo:(id)userInfo repeats:(BOOL)repeats dispatchQueue:(dispatch_queue_t)queue handler:(void (^)(STWeakTimer * _Nullable))handler {
    return [[self alloc] initWithTimeInterval:interval target:nil selector:nil userInfo:userInfo repeats:repeats dispatchQueue:queue handler:handler];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats dispatchQueue:(dispatch_queue_t)queue handler:(void (^)(STWeakTimer * _Nullable))handler {
    if ((!target && selector) || (!selector && !handler) || interval <= 0) {
        return nil;
    }
    if (!queue) {
        queue = dispatch_get_main_queue();
    }
    self = [super init];
    if (self) {
        _timeInterval = interval;
        _target = target;
        _selector = selector;
        _handler = handler;
        _userInfo = userInfo;
        _repeats = repeats;
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"com.suta.STWeaktimer.%@", self] cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(_queue, queue);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
        _lock = OS_SPINLOCK_INIT;
        _valid = YES;
        _scheduled = NO;
    }
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"You can not use the init method to initialize the timer.");
    return nil;
}

- (void)schedule {
    if (!_valid) {
        return;
    }
    _scheduled = YES;
    [self resetTimerProperties];
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleTimer];
    });
    dispatch_resume(_timer);
}

- (void)invalidate {
    if (_queue && _timer) {
        if (!OSAtomicAnd32OrigBarrier(7, &_timerFlag.invalidated)) {
            dispatch_source_t timer = _timer;
            BOOL scheduled = _scheduled;
            dispatch_async(_queue, ^{
                if (!scheduled) {
                    dispatch_resume(timer);
                }
                dispatch_source_cancel(timer);
            });
        }
    }
    _valid = NO;
}

- (void)fire {
    if (!_valid) {
        return;
    }
    [self handleTimer];
}

- (void)resetTimerProperties {
    int64_t intervalInNanoseconds = (int64_t)(_timeInterval * NSEC_PER_SEC);
    uint64_t toleranceInNanoseconds = (uint64_t)(_tolerance * NSEC_PER_SEC);
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, intervalInNanoseconds), (uint64_t)intervalInNanoseconds, toleranceInNanoseconds);
}

- (void)handleTimer {
    if (OSAtomicAnd32OrigBarrier(1, &_timerFlag.invalidated)) {
        return;
    }
    if (_handler) {
        _handler(self);
    }
    if (_selector) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_selector withObject:self];
#pragma clang diagnostic pop
    }
    if (!_repeats) {
        [self invalidate];
    }
}

- (void)pause {
    if (!_valid || !_queue || !_timer) {
        return;
    }
    if (!OSAtomicAnd32OrigBarrier(7, &_timerFlag.invalidated)) {
        dispatch_source_t timer = _timer;
        __weak typeof(self) weakSelf = self;
        dispatch_async(_queue, ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf->_scheduled = NO;
            dispatch_suspend(timer);
        });
    }
}

- (void)resume {
    if (!_valid || !_queue || !_timer) {
        return;
    }
    if (!OSAtomicAnd32OrigBarrier(7, &_timerFlag.invalidated)) {
        dispatch_source_t timer = _timer;
        __weak typeof(self) weakSelf = self;
        dispatch_async(_queue, ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf->_scheduled = YES;
            dispatch_resume(timer);
        });
    }
}

#pragma mark - getter & setter

- (void)setTolerance:(NSTimeInterval)tolerance {
    OSSpinLockLock(&_lock);
    if (tolerance != _tolerance) {
        _tolerance = tolerance;
        [self resetTimerProperties];
    }
    OSSpinLockUnlock(&_lock);
}

- (NSTimeInterval)tolerance {
    NSTimeInterval toleranceToReturn = 0;
    OSSpinLockLock(&_lock);
    toleranceToReturn = _tolerance;
    OSSpinLockUnlock(&_lock);
    return toleranceToReturn;
}

@end
