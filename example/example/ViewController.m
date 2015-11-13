//
//  ViewController.m
//  TOCropViewControllerExample
//
//  Created by Tim Oliver on 3/19/15.
//  Copyright (c) 2015 Tim Oliver. All rights reserved.
//

#import "ViewController.h"
#import "TRCropViewController.h"
#import "TOCropView.h"

@interface ViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, TRCropViewControllerDelegate>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIPopoverController *activityPopoverController;

@property (nonatomic, strong) TOCropView *cropView;

- (void)showCropViewController;
- (void)sharePhoto;

- (void)layoutImageView;
- (void)didTapImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TOCropViewController";

    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showCropViewController)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharePhoto)];

    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView)];
    [self.imageView addGestureRecognizer:tapRecognizer];
    
//    [self initCrop];
}

- (void)initCrop{
    self.image = [UIImage imageNamed:@"iii"];
    self.cropView = [[TOCropView alloc] initWithImage:self.image];
    self.cropView.frame = (CGRect){0,0,CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) };
//    self.cropView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    self.cropView.delegate = self;
    [self.view addSubview:self.cropView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutImageView];
}

- (void)layoutImageView
{
    if (self.imageView.image == nil)
        return;
    
    CGFloat padding = 20.0f;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.width -= (padding * 2.0f);
    viewFrame.size.height -= ((padding * 2.0f));
    
    CGRect imageFrame = CGRectZero;
    imageFrame.size = self.imageView.image.size;
    
    CGFloat scale = MIN(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height);
    imageFrame.size.width *= scale;
    imageFrame.size.height *= scale;
    imageFrame.origin.x = (CGRectGetWidth(self.view.bounds) - imageFrame.size.width) * 0.5f;
    imageFrame.origin.y = (CGRectGetHeight(self.view.bounds) - imageFrame.size.height) * 0.5f;
    self.imageView.frame = imageFrame;
    
    self.view.backgroundColor = [UIColor grayColor];
    
}

#pragma mark - Bar Button Items -
- (void)showCropViewController
{
    UIImagePickerController *photoPickerController = [[UIImagePickerController alloc] init];
    photoPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPickerController.allowsEditing = NO;
    photoPickerController.delegate = self;
    [self presentViewController:photoPickerController animated:YES completion:nil];
}

- (void)sharePhoto
{
    if (self.imageView.image == nil)
        return;
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[self.imageView.image] applicationActivities:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityController animated:YES completion:nil];
    }
    else {
        [self.activityPopoverController dismissPopoverAnimated:NO];
        self.activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityController];
        [self.activityPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TRCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.imageView.image = image;
    [self layoutImageView];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    CGRect viewFrame = [self.view convertRect:self.imageView.frame toView:self.navigationController.view];
    self.imageView.hidden = FALSE;
    [cropViewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Image Picker Delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.image = image;
        TRCropViewController *cropController = [[TRCropViewController alloc] initWithImage:image];
        cropController.delegate = self;
        [self.navigationController pushViewController:cropController animated:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Gesture Recognizer -
- (void)didTapImageView
{
    TRCropViewController *cropController = [[TRCropViewController alloc] initWithImage:self.image];
    cropController.delegate = self;
    [self presentViewController:cropController animated:YES completion:nil];
}

@end
