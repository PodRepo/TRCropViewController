//
//  UIImage+UzysExtension.m
//  UzysAssetsPickerController
//
//  Created by jianpx on 8/26/14.
//  Copyright (c) 2014 Uzys. All rights reserved.
//

#import "UIImage+TRCropViewController.h"
#import "TRCropViewController.h"

@implementation UIImage (TRCropViewController)

+ (UIImage *)TRCropViewController_imageNamed:(NSString *)imageName
{
    UIImage *image = [[self class] imageNamed:imageName];
    if (image) {
        return image;
    }
    //for Swift podfile
    NSString *imagePathInBundleForClass = [NSString stringWithFormat:@"%@/%@", [[NSBundle bundleForClass:[TRCropViewController class]] resourcePath], imageName ];
    image = [[self class] imageNamed:imagePathInBundleForClass];
    return image;
}
@end
