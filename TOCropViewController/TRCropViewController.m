//
//  TOCropViewController.h
//
//  Copyright 2015 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TRCropViewController.h"
#import "TOCropView.h"
#import "TOCropToolbar.h"
#import "TOCropViewControllerTransitioning.h"
#import "TOActivityCroppedImageProvider.h"
#import "UIImage+CropRotate.h"
#import "TOCroppedImageAttributes.h"

typedef NS_ENUM(NSInteger, TRCropViewControllerAspectRatio) {
    TOCropViewControllerAspectRatioOriginal,
    TOCropViewControllerAspectRatioSquare,
    TOCropViewControllerAspectRatio3x2,
    TOCropViewControllerAspectRatio5x3,
    TOCropViewControllerAspectRatio4x3,
    TOCropViewControllerAspectRatio5x4,
    TOCropViewControllerAspectRatio7x5,
    TOCropViewControllerAspectRatio16x9
};

@interface TRCropViewController () <UIActionSheetDelegate, UIViewControllerTransitioningDelegate, TOCropViewDelegate>

@property (nonatomic, readwrite) UIImage *image;
@property (nonatomic, strong) TOCropView *cropView;


- (void)rotateCropView;

/* View layout */
- (CGRect)frameForToolBarWithVerticalLayout:(BOOL)verticalLayout;

@end

@implementation TRCropViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        _image = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    self.cropView = [[TOCropView alloc] initWithImage:self.image];
    self.cropView.frame = (CGRect){0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)};
    self.cropView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    self.cropView.delegate = self;
    [self.view addSubview:self.cropView];
    [self.cropView setAspectLockEnabledWithAspectRatio:CGSizeMake(1.0, 1.0) animated:YES];
    
}


-(void)setupNavigationBar {
    self.navigationItem.title = @"裁剪?";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"uzysAP_navi_icon_close"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped:)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = done;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Status Bar -
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return FALSE;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

#pragma mark - Rotation Handling -
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.cropView.simpleMode = YES;
    [self.cropView prepareforRotation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    [self.cropView performRelayoutForRotation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.cropView setSimpleMode:NO animated:YES];
}

#pragma mark - Reset -
- (void)resetCropViewLayout
{
    [self.cropView resetLayoutToDefaultAnimated:YES];
    self.cropView.aspectLockEnabled = NO;
}


- (void)rotateCropView
{
    [self.cropView rotateImageNinetyDegreesAnimated:YES];
}


#pragma mark - Button Feedback -
- (void)cancelButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCancelled:)]) {
        [self.delegate cropViewController:self didFinishCancelled:YES];
        return;
    }
    
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped:(id)sender
{
    CGRect cropFrame = self.cropView.croppedImageFrame;
    NSInteger angle = self.cropView.angle;
    
    
    //If the delegate that only supplies crop data is provided, call it
    if ([self.delegate respondsToSelector:@selector(cropViewController:didCropImageToRect:angle:)]) {
        [self.delegate cropViewController:self didCropImageToRect:cropFrame angle:angle];
    }
    //If the delegate that requires the specific cropped image is provided, call it
    else if ([self.delegate respondsToSelector:@selector(cropViewController:didCropToImage:withRect:angle:)]) {
        UIImage *image = nil;
        if (angle == 0 && CGRectEqualToRect(cropFrame, (CGRect){CGPointZero, self.image.size})) {
            image = self.image;
        }
        else {
            image = [self.image croppedImageWithFrame:cropFrame angle:angle];
        }
        
        //dispatch on the next run-loop so the animation isn't interuppted by the crop operation
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate cropViewController:self didCropToImage:image withRect:cropFrame angle:angle];
        });
    }
    else {
    }
}

@end
