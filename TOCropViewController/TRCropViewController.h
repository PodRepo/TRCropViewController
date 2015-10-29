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

#import <UIKit/UIKit.h>

@class TRCropViewController;

///------------------------------------------------
/// @name Delegate
///------------------------------------------------

@protocol TRCropViewControllerDelegate <NSObject>
@optional

/**
 Called when the user has committed the crop action, and provides just the cropping rectangle
 
 @param image The newly cropped image.
 @param cropRect A rectangle indicating the crop region of the image the user chose (In the original image's local co-ordinate space)
 */
- (void)cropViewController:(TRCropViewController *)cropViewController didCropImageToRect:(CGRect)cropRect angle:(NSInteger)angle;

/**
 Called when the user has committed the crop action, and provides both the original image with crop co-ordinates.
 
 @param image The newly cropped image.
 @param cropRect A rectangle indicating the crop region of the image the user chose (In the original image's local co-ordinate space)
 */
- (void)cropViewController:(TRCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle;

/**
 If implemented, when the user hits cancel, or completes a UIActivityViewController operation, this delegate will be called,
 giving you a chance to manually dismiss the view controller
 
 */
- (void)cropViewController:(TRCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled;

@end

@interface TRCropViewController : UIViewController

/**
 The original, uncropped image that was passed to this controller.
 */
@property (nonatomic, readonly) UIImage *image;

/**
 The view controller's delegate that will return the resulting cropped image, as well as crop information
 */
@property (nonatomic, weak) id<TRCropViewControllerDelegate> delegate;


///------------------------------------------------
/// @name Object Creation
///------------------------------------------------

/**
 Creates a new instance of a crop view controller with the supplied image
 
 @param image The image that will be used to crop.
 */
- (instancetype)initWithImage:(UIImage *)image;



@end

