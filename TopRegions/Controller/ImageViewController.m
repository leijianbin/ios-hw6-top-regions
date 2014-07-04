//
//  ImageViewController.m
//  TopPlace
//
//  Created by Jianbin Lei on 6/3/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImage *image;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic) BOOL userDidZoom;

@end

@implementation ImageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    // Do any additional setup after loading the view.
}

//lazy instantiation

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIImage *)image
{
    return self.imageView.image;
}

-(void)setImage:(UIImage *)image
{
    self.scrollView.zoomScale = 1.0;
    self.imageView.image = image;
    
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [self.imageView sizeToFit];
    
    //
    self.scrollView.contentSize = self.image ? self.image.size: CGSizeZero;
    [self setZoomScaleToFillScreen];
    [self.spinner stopAnimating];
    
    //self.userDidZoom = NO;
}

- (void)setZoomScaleToFillScreen
{
    double wScale = self.scrollView.bounds.size.width / self.imageView.image.size.width;
    double hScale = (self.scrollView.bounds.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height) / self.imageView.image.size.height;
    if (wScale > hScale) self.scrollView.zoomScale = wScale;
    else self.scrollView.zoomScale = hScale;
}


#pragma mark - Setting the Image from the Image's URL

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self startDownloadingImage];
}

- (void)startDownloadingImage
{
    self.image = nil;
    
    if (self.imageURL)
    {
        [self.spinner startAnimating];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        
        // another configuration option is backgroundSessionConfiguration (multitasking API required though)
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        // create the session without specifying a queue to run completion handler on (thus, not main queue)
        // we also don't specify a delegate (since completion handler is all we need)
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                                                            // this handler is not executing on the main queue, so we can't do UI directly here
                                                            if (!error) {
                                                                if ([request.URL isEqual:self.imageURL]) {
                                                                    // UIImage is an exception to the "can't do UI here"
                                                                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                                                                    // but calling "self.image =" is definitely not an exception to that!
                                                                    // so we must dispatch this back to the main queue
                                                                    dispatch_async(dispatch_get_main_queue(), ^{ self.image = image; });
                                                                }
                                                            }
                                                        }];
        [task resume]; // don't forget that all NSURLSession tasks start out suspended!
    }
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    // next three lines are necessary for zooming
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    
    // next line is necessary in case self.image gets set before self.scrollView does
    // for example, prepareForSegue:sender: is called before outlet-setting phase
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

//- (IBAction)zoomTap:(UITapGestureRecognizer *)sender {
//    CGRect zoomRect = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
//    [self.scrollView zoomToRect:zoomRect animated:NO];
//}

#pragma mark - UIScrollViewDelegate

// mandatory zooming method in UIScrollViewDelegate protocol

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //self.userDidZoom = YES;
    return self.imageView;
}



#pragma mark - UISpiltViewController
- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
