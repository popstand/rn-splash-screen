#import "RCTSplashScreen.h"

static RCTRootView *rootView = nil;

@interface RCTSplashScreen()

@end

@implementation RCTSplashScreen

RCT_EXPORT_MODULE(SplashScreen)

+ (NSString *)splashImageNameForOrientation {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGSize viewSize = CGSizeMake(screenWidth, screenHeight);

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    NSString* viewOrientation = @"Portrait";
    if (UIDeviceOrientationIsLandscape(orientation)) {
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
        viewOrientation = @"Landscape";
    }

    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];

    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            return dict[@"UILaunchImageName"];
    }
    return nil;
}

+ (void)show:(RCTRootView *)v {
    rootView = v;
    rootView.loadingViewFadeDelay = 0.0;
    rootView.loadingViewFadeDuration = 1.3;
    UIImageView *view = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    NSString* launchFn = [RCTSplashScreen splashImageNameForOrientation];
    view.image = [UIImage imageNamed:launchFn];

    [[NSNotificationCenter defaultCenter] removeObserver:rootView  name:RCTContentDidAppearNotification object:rootView];

    [rootView setLoadingView:view];
}


RCT_EXPORT_METHOD(hide) {
    if (!rootView) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(rootView.loadingViewFadeDuration * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   ^{
                     [UIView animateWithDuration:rootView.loadingViewFadeDuration
                                     animations:^{
                                         rootView.loadingView.transform = CGAffineTransformMakeScale(1.8, 1.8);
                                         rootView.loadingView.alpha = 0;
                                     } completion:^(__unused BOOL finished) {
                                         [rootView.loadingView removeFromSuperview];
                                     }];
                   });
}

@end
