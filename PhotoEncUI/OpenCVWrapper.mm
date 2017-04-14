//
//  OpenCVWrapper.m
//  PhotoEncUI
//
//  Created by FelisDJ on 3/16/2560 BE.
//  Copyright © 2560 Jackthip Pureesatian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>

using namespace cv;

@implementation OpenCVWrapper


// Here we can use C++ code
-(NSString *) openCVVersion {
	return [NSString stringWithFormat:@"OpenCV version : %s", CV_VERSION];
}

+(UIImage *) makeGrayFromImage:(UIImage *)image {
	Mat imageMat;
	UIImageToMat(image, imageMat);
	
	if(imageMat.channels() == 1) return image;
	
	Mat grayMat;
	cvtColor(imageMat, grayMat, CV_BGR2GRAY);
	
	return MatToUIImage(grayMat);
	
}

+(UIImage *) enhancementIntensity:(UIImage *)image: (NSInteger) intensity: (NSString*) mode {
	Mat imageMat;
	UIImageToMat(image, imageMat);
	
	//	if(imageMat.channels() == 1) return image;
	
//	NSLog(@"rows : %i, cols : %i", imageMat.rows, imageMat.cols);
	if(imageMat.channels() == 1) {
		if([mode isEqualToString:@"intensity"]) {
			for( int x = 0 ; x < imageMat.cols ; x++ )
			{
				for( int y = 0; y < imageMat.rows ; y++ )
				{
					imageMat.at<uchar>(y,x) = saturate_cast<uchar>(( imageMat.at<uchar>(y,x)) + (int)intensity);

				}
			}
		}
		return MatToUIImage(imageMat);
	}
	
	if([mode isEqualToString:@"intensity"]) {
		for( int x = 0 ; x < imageMat.cols ; x++ )
		{
			for( int y = 0; y < imageMat.rows ; y++ )
			{
				for( int c = 0; c < 4; c++ )
				{
					imageMat.at<Vec4b>(y,x)[c] = saturate_cast<uchar>(( imageMat.at<Vec4b>(y,x)[c]) + (int)intensity);
					
				}
			}
		}
		return MatToUIImage(imageMat);
		
	}
	else if([mode isEqualToString:@"intensityRed"]) {
		for( int x = 0 ; x < imageMat.cols; x++ )
		{
			for( int y = 0; y < imageMat.rows ; y++ )
			{
				imageMat.at<Vec4b>(y,x)[0] = saturate_cast<uchar>(( imageMat.at<Vec4b>(y,x)[0]) + (int)intensity);
				
			}
		}
		return MatToUIImage(imageMat);
	}
	
	else if([mode isEqualToString:@"intensityGreen"]) {
		for( int x = 0 ; x < imageMat.cols; x++ )
		{
			for( int y = 0; y < imageMat.rows ; y++ )
			{
				imageMat.at<Vec4b>(y,x)[1] = saturate_cast<uchar>(( imageMat.at<Vec4b>(y,x)[1]) + (int)intensity);
				
			}
		}
		return MatToUIImage(imageMat);
	}
	
	else if([mode isEqualToString:@"intensityBlue"]) {
		for( int x = 0 ; x < imageMat.cols; x++ )
		{
			for( int y = 0; y < imageMat.rows ; y++ )
			{
				imageMat.at<Vec4b>(y,x)[2] = saturate_cast<uchar>(( imageMat.at<Vec4b>(y,x)[2]) + (int)intensity);
				
			}
		}
		return MatToUIImage(imageMat);
	}
	
	Mat newImage = Mat::zeros( imageMat.size(), imageMat.type() );
	cvtColor(imageMat, newImage, CV_RGB2HLS);
	
	for( int x = 0 ; x < imageMat.cols; x++ )
	{
		for( int y = 0; y < imageMat.rows ; y++ )
		{
			newImage.at<Vec3b>(y,x)[2] = saturate_cast<uchar>(( newImage.at<Vec3b>(y,x)[2]) + (int)intensity );
			
		}
	}
	
	cvtColor(newImage, newImage, CV_HLS2RGB);
	
	return MatToUIImage(newImage);
	
}

+(UIImage *) filterMode:(UIImage *) image: (NSString*) mode: (NSInteger) sizeFilter
{
	Mat imageMat;
	int sizes = (int)sizeFilter;
	UIImageToMat(image, imageMat);
	if([mode isEqualToString:@"averageFilter"]) {
		blur(imageMat, imageMat, cvSize(sizes,sizes));
	} else if ([mode isEqualToString:@"gaussianFilter"]) {
		GaussianBlur(imageMat, imageMat, cvSize(sizes,sizes) , 0);
	} else if ([mode isEqualToString:@"medianFilter"]) {
		medianBlur(imageMat, imageMat, sizes);
	} else if ([mode isEqualToString:@"sharpen"]) {
		Mat blurImg;
		
		GaussianBlur(imageMat, blurImg, cvSize(0,0), sizes);
		addWeighted(imageMat, 1.5, blurImg, -0.5, 0, blurImg);
		
		imageMat = blurImg;
		
	}
	return MatToUIImage(imageMat);
}

+(UIImage *) histogramData:(UIImage *)image {
	Mat imageMat;
	UIImageToMat(image, imageMat);
	
	if(imageMat.channels() == 1) {
		return image;
	}
	
	vector<Mat> bgr;
	split(imageMat, bgr);
	int numbins = 256;
	float range[] = {0, 255};
	const float* histRange = { range };
	Mat b_hist, g_hist, r_hist;
	
	calcHist( &bgr[0], 1, 0, Mat(), b_hist, 1, &numbins, &histRange);
	calcHist( &bgr[1], 1, 0, Mat(), g_hist, 1, &numbins, &histRange);
	calcHist( &bgr[2], 1, 0, Mat(), r_hist, 1, &numbins, &histRange);
	
	int width = 512;
	int height = 300;
	Mat histogram( height, width, CV_8UC3, Scalar(20,20,20));
	
	normalize(b_hist, b_hist, 0, height, NORM_MINMAX);
	normalize(g_hist, g_hist, 0, height, NORM_MINMAX);
	normalize(r_hist, r_hist, 0, height, NORM_MINMAX);
	
	int binStep = cvRound((float)width/(float)numbins);
	for(int i = 1 ; i < numbins ; i++ ) {
		line( histogram, cvPoint( binStep*(i-1), height-cvRound(b_hist.at<float>(i-1))), cvPoint(binStep*(i), height-cvRound(b_hist.at<float>(i))),Scalar(255,0,0));
		line( histogram, cvPoint( binStep*(i-1), height-cvRound(g_hist.at<float>(i-1))), cvPoint(binStep*(i), height-cvRound(g_hist.at<float>(i))),Scalar(0,255,0));
		line( histogram, cvPoint( binStep*(i-1), height-cvRound(r_hist.at<float>(i-1))), cvPoint(binStep*(i), height-cvRound(r_hist.at<float>(i))),Scalar(0,0,255));
	}
	
	for( int x = 0 ; x < histogram.cols ; x++ )
	{
		for( int y = 0; y < histogram.rows ; y++ )
		{
			if(histogram.at<Vec4b>(y,x)[0] == 0 && histogram.at<Vec4b>(y,x)[1] == 0 && histogram.at<Vec4b>(y,x)[2] == 0) {
				for(int i = 0 ; i < 3 ; i++) {
					histogram.at<Vec4b>(y,x)[i] = 255;
				}
				histogram.at<Vec4b>(y,x)[3] = 1;
			}
		}
	}
	
	return MatToUIImage(histogram);
	
}

@end
