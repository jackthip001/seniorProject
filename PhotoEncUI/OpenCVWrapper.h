//
//  OpenCVWrapper.h
//  PhotoEncUI
//
//  Created by FelisDJ on 3/16/2560 BE.
//  Copyright © 2560 Jackthip Pureesatian. All rights reserved.
//

#ifndef OpenCVWrapper_h
#define OpenCVWrapper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject

+(NSString *) openCVVersion;

+(UIImage *) makeGrayFromImage:(UIImage *)image;

+(UIImage *) enhancementIntensity:(UIImage *)image: (NSInteger) intensity: (NSString*) mode;

+(UIImage *) filterMode:(UIImage *) image: (NSString*) mode: (NSInteger) sizeFilter;

+(UIImage *) histogramData:(UIImage *) image ;

@end

#endif /* OpenCVWrapper_h */
