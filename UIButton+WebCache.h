

#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"

@interface UIButton (WebCache) <SDWebImageManagerDelegate>

/**
 * Set the imageView `image` with an `url`.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url that the image is found.
 * @see setImageWithURL:placeholderImage:
 */
- (void)setImageWithURL:(NSURL *)url;

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url that the `image` is found.
 * @param placeholder A `image` that will be visible while loading the final image.
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

/**
 * Cancel the current download
 */
- (void)cancelCurrentImageLoad;

@end
