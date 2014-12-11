//
//  FluctCInterface.m
//  FluctCInterface
//
//  Created by KUROSAKI Ryota on 2014/01/28.
//  Copyright (c) 2014年 Zucks, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FluctSDK.h"
#import "FluctBannerView.h"
#import "FluctInterstitialView.h"

UIKIT_EXTERN CGRect CGRectMove(CGRect rect, CGFloat x, CGFloat y, CGFloat relativeX, CGFloat relativeY);
UIKIT_EXTERN CGFloat CGRectGetPointX(CGRect rect, CGFloat relativeX);
UIKIT_EXTERN CGFloat CGRectGetPointY(CGRect rect, CGFloat relativeY);
UIKIT_EXTERN CGPoint CGRectGetPoint(CGRect rect, CGFloat relativeX, CGFloat relativeY);
UIKIT_EXTERN CGRect CGRectContentMode(CGRect rect, CGRect parentRect, UIViewContentMode contentMode);

inline CGFloat CGRectGetPointX(CGRect rect, CGFloat relativeX)
{
    return rect.origin.x + rect.size.width * relativeX;
}

inline CGFloat CGRectGetPointY(CGRect rect, CGFloat relativeY)
{
    return rect.origin.y + rect.size.height * relativeY;
}

inline CGPoint CGRectGetPoint(CGRect rect, CGFloat relativeX, CGFloat relativeY)
{
    return CGPointMake(CGRectGetPointX(rect, relativeX),
                       CGRectGetPointY(rect, relativeY));
}

inline CGRect CGRectMove(CGRect rect, CGFloat x, CGFloat y, CGFloat relativeX, CGFloat relativeY)
{
    CGPoint relativePoint = CGRectGetPoint(rect, relativeX, relativeY);
    CGRect moveRect = rect;
    moveRect.origin.x += x - relativePoint.x;
    moveRect.origin.y += y - relativePoint.y;
    return moveRect;
}

CGRect CGRectContentMode(CGRect rect, CGRect parentRect, UIViewContentMode contentMode)
{
    CGRect result = rect;
    
    if (contentMode == UIViewContentModeScaleToFill) {
        result = parentRect;
    }
    else if (contentMode == UIViewContentModeScaleAspectFit) {
        if ((parentRect.size.width / parentRect.size.height) > (rect.size.width / rect.size.height)) {
            // rectの高さをparentRectの高さに揃えるようにリサイズする
            result.size = CGSizeMake(parentRect.size.height * rect.size.width / rect.size.height,
                                     parentRect.size.height);
        }
        else {
            // rectの幅をparentRectの幅に揃えるようにリサイズする
            result.size = CGSizeMake(parentRect.size.width,
                                     parentRect.size.width * rect.size.height / rect.size.width);
        }
        result = CGRectMove(result,
                            CGRectGetPointX(parentRect, 0.5),
                            CGRectGetPointY(parentRect, 0.5),
                            0.5, 0.5);
    }
    else if (contentMode == UIViewContentModeScaleAspectFill) {
        if ((parentRect.size.width / parentRect.size.height) > (rect.size.width / rect.size.height)) {
            // rectの幅をparentRectの幅に揃えるようにリサイズする
            result.size = CGSizeMake(parentRect.size.width,
                                     parentRect.size.width * rect.size.height / rect.size.width);
        }
        else {
            // rectの高さをparentRectの高さに揃えるようにリサイズする
            result.size = CGSizeMake(parentRect.size.height * rect.size.width / rect.size.height,
                                     parentRect.size.height);
        }
        result = CGRectMove(result,
                            CGRectGetPointX(parentRect, 0.5),
                            CGRectGetPointY(parentRect, 0.5),
                            0.5, 0.5);
    }
    else if (contentMode == UIViewContentModeRedraw) {
        // nothing to do
    }
    else if (contentMode == UIViewContentModeCenter) {
        result = CGRectMove(result,
                            CGRectGetPointX(parentRect, 0.5),
                            CGRectGetPointY(parentRect, 0.5),
                            0.5, 0.5);
    }
    else if (contentMode == UIViewContentModeTop) {
        result = CGRectMove(result,
                            CGRectGetPointX(parentRect, 0.5),
                            CGRectGetPointY(parentRect, 0.0),
                            0.5, 0.0);
    }
    else if (contentMode == UIViewContentModeBottom) {
        result = CGRectMove(result,
                            CGRectGetPointX(parentRect, 0.5),
                            CGRectGetPointY(parentRect, 1.0),
                            0.5, 1.0);
    }
    else if (contentMode == UIViewContentModeLeft) {
        result = CGRectMove(result,
                            CGRectGetPointX(parentRect, 0.0),
                            CGRectGetPointY(parentRect, 0.5),
                            0.0, 0.5);
    }
    else if (contentMode == UIViewContentModeRight) {
        result = CGRectMove(result,
                            CGRectGetPointX(parentRect, 1.0),
                            CGRectGetPointY(parentRect, 0.5),
                            1.0, 0.5);
    }
    else if (contentMode == UIViewContentModeTopLeft) {
        result = CGRectMove(result,
                            CGRectGetPointX(parentRect, 0.0),
                            CGRectGetPointY(parentRect, 0.0),
                            0.0, 0.0);
    }
    else if (contentMode == UIViewContentModeTopRight) {
        result = CGRectMove(result,
                            CGRectGetPointX(parentRect, 1.0),
                            CGRectGetPointY(parentRect, 0.5),
                            1.0, 0.5);
    }
    else if (contentMode == UIViewContentModeBottomLeft) {
        result = CGRectMove(result,
                            CGRectGetPointX(parentRect, 0.0),
                            CGRectGetPointY(parentRect, 1.0),
                            0.0, 1.0);
    }
    else if (contentMode == UIViewContentModeBottomRight) {
        result = CGRectMove(result,
                            CGRectGetPointX(parentRect, 1.0),
                            CGRectGetPointY(parentRect, 1.0),
                            1.0, 1.0);
    }
    
    return result;
}

typedef void (*FluctInterstitialViewCallbackFunction)(int callbackValue);

typedef enum FluctBannerViewPosition {
    FluctBannerViewPositionLeft             = 0x1 << 0,
    FluctBannerViewPositionTop              = 0x1 << 1,
    FluctBannerViewPositionRight            = 0x1 << 2,
    FluctBannerViewPositionBottom           = 0x1 << 3,
    FluctBannerViewPositionCenterVertical   = 0x1 << 4,
    FluctBannerViewPositionCenterHorizontal = 0x1 << 5,
} FluctBannerViewPosition;

extern UIViewController *UnityGetGLViewController();
extern void UnitySendMessage(const char *, const char *, const char *);

@interface FluctCInterface : NSObject <FluctInterstitialViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *bannerDictionary;
@property (nonatomic, strong) NSMutableDictionary *interstitialDictionary;
@property (nonatomic, strong) NSMutableDictionary *interstitialCallbackDictionary;

@end

@implementation FluctCInterface

+ (FluctCInterface *)sharedObject
{
    static dispatch_once_t onceToken;
    static FluctCInterface *_sharedObject;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[FluctCInterface alloc] init];
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        _bannerDictionary = @{}.mutableCopy;
        _interstitialDictionary = @{}.mutableCopy;
        _interstitialCallbackDictionary = @{}.mutableCopy;
    }
    return self;
}

- (BOOL)bannerExistWithID:(int)bannerObjectID
{
    return (self.bannerDictionary[@(bannerObjectID)] != nil);
}

- (BOOL)interstitialExistWithID:(int)interstitialObjectID
{
    return (self.interstitialDictionary[@(interstitialObjectID)] != nil);
}

- (FluctBannerView *)bannerWithID:(int)bannerObjectID
{
    return self.bannerDictionary[@(bannerObjectID)];
}

- (FluctInterstitialView *)interstitialWithID:(int)interstitialObjectID
{
    return self.interstitialDictionary[@(interstitialObjectID)];
}

- (BOOL)setBanner:(FluctBannerView *)bannerView forID:(int)bannerObjectID
{
    if (![self bannerExistWithID:bannerObjectID]) {
        self.bannerDictionary[@(bannerObjectID)] = bannerView;
        return YES;
    }
    return NO;
}

- (BOOL)setInterstitial:(FluctInterstitialView *)interstitialView forID:(int)interstitialObjectID
{
    if (![self interstitialExistWithID:interstitialObjectID]) {
        self.interstitialDictionary[@(interstitialObjectID)] = interstitialView;
        return YES;
    }
    return NO;
}

- (BOOL)removeBannerForID:(int)bannerObjectID
{
    if ([self bannerExistWithID:bannerObjectID]) {
        [self.bannerDictionary removeObjectForKey:@(bannerObjectID)];
        return YES;
    }
    return NO;
}

- (BOOL)removeInterstitialForID:(int)interstitialObjectID
{
    if ([self interstitialExistWithID:interstitialObjectID]) {
        [self.interstitialDictionary removeObjectForKey:@(interstitialObjectID)];
        return YES;
    }
    return NO;
}

- (BOOL)startInterstitialCallbackForID:(int)interstitialObjectID objectName:(NSString *)objectName
{
    if ([self interstitialExistWithID:interstitialObjectID]) {
        self.interstitialCallbackDictionary[@(interstitialObjectID)] = objectName;
        FluctInterstitialView *interstitialView = [self interstitialWithID:interstitialObjectID];
        interstitialView.delegate = self;
        return YES;
    }
    return NO;
}

- (BOOL)stopInterstitialCallbackForID:(int)interstitialObjectID
{
    if ([self interstitialExistWithID:interstitialObjectID]) {
        [self.interstitialCallbackDictionary removeObjectForKey:@(interstitialObjectID)];
        FluctInterstitialView *interstitialView = [self interstitialWithID:interstitialObjectID];
        interstitialView.delegate = nil;
        return YES;
    }
    return NO;
}

- (void)fluctInterstitialView:(FluctInterstitialView *)interstitialView
                callbackValue:(NSInteger)callbackValue
{
    for (NSNumber *n in self.interstitialDictionary.allKeys) {
        if (self.interstitialDictionary[n] == interstitialView) {
            NSString *objectName = self.interstitialCallbackDictionary[n];
            NSString *message = [NSString stringWithFormat:@"%d:%d", n.intValue, callbackValue];
            UnitySendMessage(objectName.UTF8String, "CallbackValue", message.UTF8String);
        }
    }
}

@end

#ifdef __cplusplus
extern "C" {
#endif

#pragma mark - FluctSDK

void FluctSDKSetBannerConfiguration(char *media_id)
{
    NSString *mediaID = [NSString stringWithCString:media_id encoding:NSUTF8StringEncoding];
    [[FluctSDK sharedInstance] setBannerConfiguration:mediaID];
}

#pragma mark - FluctBannerView

bool FluctBannerViewCreate(int object_id, char *media_id)
{
    if (![[FluctCInterface sharedObject] bannerExistWithID:object_id]) {
        FluctBannerView *view = [[FluctBannerView alloc] init];
        if (media_id != NULL && strlen(media_id) > 0) {
            [view setMediaID:@(media_id)];
        }
        [[FluctCInterface sharedObject] setBanner:view forID:object_id];
        return true;
    }
    return false;
}

bool FluctBannerViewDestroy(int object_id)
{
    return [[FluctCInterface sharedObject] removeBannerForID:object_id];
}

bool FluctBannerViewExist(int object_id)
{
    return [[FluctCInterface sharedObject] bannerExistWithID:object_id];
}

bool FluctBannerViewSetMediaID(int object_id, char *media_id)
{
    FluctBannerView *view = [[FluctCInterface sharedObject] bannerWithID:object_id];
    if (view) {
        if (media_id != NULL && strlen(media_id) > 0) {
            [view setMediaID:@(media_id)];
            return true;
        }
    }
    return false;
}

bool FluctBannerViewGetFrame(int object_id, float *x, float *y, float *width, float *height)
{
    FluctBannerView *view = [[FluctCInterface sharedObject] bannerWithID:object_id];
    if (view) {
        CGRect frame = view.frame;
        if (x != NULL) {
            *x = frame.origin.x;
        }
        if (y != NULL) {
            *y = frame.origin.y;
        }
        if (width != NULL) {
            *width = frame.size.width;
        }
        if (height != NULL) {
            *height = frame.size.height;
        }
        return true;
    }
    return false;
}

bool FluctBannerViewSetFrame(int object_id, float x, float y, float width, float height)
{
    FluctBannerView *view = [[FluctCInterface sharedObject] bannerWithID:object_id];
    if (view) {
        view.frame = CGRectMake(x, y, width, height);
        return true;
    }
    return false;
}

bool FluctBannerViewSetPosition(int object_id, float width, float height, int position, float left, float top, float right, float bottom)
{
    FluctBannerView *view = [[FluctCInterface sharedObject] bannerWithID:object_id];
    if (view) {
        int adjustPosition = 0;
        if (position & FluctBannerViewPositionLeft) {
            adjustPosition |= FluctBannerViewPositionLeft;
        }
        else if (position & FluctBannerViewPositionRight) {
            adjustPosition |= FluctBannerViewPositionRight;
        }
        else if (position & FluctBannerViewPositionCenterHorizontal) {
            adjustPosition |= FluctBannerViewPositionCenterHorizontal;
        }
        else {
            adjustPosition |= FluctBannerViewPositionLeft;
        }
        
        if (position & FluctBannerViewPositionTop) {
            adjustPosition |= FluctBannerViewPositionTop;
        }
        else if (position & FluctBannerViewPositionBottom) {
            adjustPosition |= FluctBannerViewPositionBottom;
        }
        else if (position & FluctBannerViewPositionCenterVertical) {
            adjustPosition |= FluctBannerViewPositionCenterVertical;
        }
        else {
            adjustPosition |= FluctBannerViewPositionTop;
        }
        
        CGRect frame = CGRectMake(0.0f, 0.0f, width, height);
        UIViewController *c = UnityGetGLViewController();

        UIViewContentMode mode = UIViewContentModeTopLeft;
        if (adjustPosition & FluctBannerViewPositionLeft) {
            if (adjustPosition & FluctBannerViewPositionTop) {
                mode = UIViewContentModeTopLeft;
            }
            else if (adjustPosition & FluctBannerViewPositionCenterVertical) {
                mode = UIViewContentModeLeft;
            }
            else if (adjustPosition & FluctBannerViewPositionBottom) {
                mode = UIViewContentModeBottomLeft;
            }
        }
        else if (adjustPosition & FluctBannerViewPositionCenterHorizontal) {
            if (adjustPosition & FluctBannerViewPositionTop) {
                mode = UIViewContentModeTop;
            }
            else if (adjustPosition & FluctBannerViewPositionCenterVertical) {
                mode = UIViewContentModeCenter;
            }
            else if (adjustPosition & FluctBannerViewPositionBottom) {
                mode = UIViewContentModeBottom;
            }
        }
        else if (adjustPosition & FluctBannerViewPositionRight) {
            if (adjustPosition & FluctBannerViewPositionTop) {
                mode = UIViewContentModeTopRight;
            }
            else if (adjustPosition & FluctBannerViewPositionCenterVertical) {
                mode = UIViewContentModeRight;
            }
            else if (adjustPosition & FluctBannerViewPositionBottom) {
                mode = UIViewContentModeBottomRight;
            }
        }
        
        frame = CGRectContentMode(frame, c.view.bounds, mode);
        frame.origin.x += left + (-1 * right);
        frame.origin.y += top + (-1 * bottom);
        FluctBannerViewSetFrame(object_id, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        return true;
    }
    return false;
}

bool FluctBannerViewShow(int object_id)
{
    FluctBannerView *view = [[FluctCInterface sharedObject] bannerWithID:object_id];
    if (view) {
        UIViewController *c = UnityGetGLViewController();
        [c.view addSubview:view];
        return true;
    }
    return false;
}

bool FluctBannerViewDismiss(int object_id)
{
    FluctBannerView *view = [[FluctCInterface sharedObject] bannerWithID:object_id];
    if (view) {
        [view removeFromSuperview];
        return true;
    }
    return false;
}

#pragma mark - FluctInterstitialView

bool FluctInterstitialViewCreate(int object_id, char *media_id)
{
    if (![[FluctCInterface sharedObject] bannerExistWithID:object_id]) {
        FluctInterstitialView *view = [[FluctInterstitialView alloc] init];
        if (media_id != NULL && strlen(media_id) > 0) {
            [view setMediaID:@(media_id)];
        }
        [[FluctCInterface sharedObject] setInterstitial:view forID:object_id];
        return true;
    }
    return false;

}

bool FluctInterstitialViewDestroy(int object_id)
{
    [[FluctCInterface sharedObject] stopInterstitialCallbackForID:object_id];
    return [[FluctCInterface sharedObject] removeInterstitialForID:object_id];
}

bool FluctInterstitialViewExist(int object_id)
{
    return [[FluctCInterface sharedObject] interstitialExistWithID:object_id];
}

bool FluctInterstitialViewSetMediaID(int object_id, char *media_id)
{
    FluctInterstitialView *view = [[FluctCInterface sharedObject] interstitialWithID:object_id];
    if (view) {
        if (media_id != NULL && strlen(media_id) > 0) {
            [view setMediaID:@(media_id)];
            return true;
        }
    }
    return false;
}

bool FluctInterstitialViewStartCallback(int object_id, char *object_name)
{
    if ([[FluctCInterface sharedObject] interstitialExistWithID:object_id]) {
        [[FluctCInterface sharedObject] startInterstitialCallbackForID:object_id objectName:@(object_name)];
        return true;
    }
    return false;
}

bool FluctInterstitialViewStopCallback(int object_id)
{
    if ([[FluctCInterface sharedObject] interstitialExistWithID:object_id]) {
        [[FluctCInterface sharedObject] stopInterstitialCallbackForID:object_id];
        return true;
    }
    return false;
}

bool FluctInterstitialViewShow(int object_id, char *hex_color_string)
{
    FluctInterstitialView *view = [[FluctCInterface sharedObject] interstitialWithID:object_id];
    if (view) {
        NSString *hexColorString = nil;
        if (hex_color_string != NULL && strlen(hex_color_string) > 0) {
            hexColorString = @(hex_color_string);
        }
        [view showInterstitialAdWithHexColor:hexColorString];
        return true;
    }
    return false;
}

bool FluctInterstitialViewDismiss(int object_id)
{
    FluctInterstitialView *view = [[FluctCInterface sharedObject] interstitialWithID:object_id];
    if (view) {
        [view dismissInterstitialAd];
        return true;
    }
    return false;
}

#ifdef __cplusplus
}
#endif
