//
//  UILabelCollectionViewCell.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "UILabelCollectionViewCell.h"

@interface UILabelCollectionViewCell()

- (void)commonInit;

@end

@implementation UILabelCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	
	return self;
}

- (void)commonInit
{
	const float height = 0.5f;
	const float tableViewInsetFactor = 0.89f;
	
	float width = floorf(self.layer.bounds.size.width * tableViewInsetFactor);
	UIColor *tableViewCellGray = [UIColor colorWithRed:(200.f/255.f) green:(199.f/255.f) blue:(205.f/255.f) alpha:1.f];
	
	CALayer *separatorLayer = [CALayer layer];
	separatorLayer.contentsScale = [UIScreen mainScreen].scale;
	separatorLayer.backgroundColor = tableViewCellGray.CGColor;
	separatorLayer.bounds = CGRectMake(0.f, 0.f, width, height);
	separatorLayer.anchorPoint = CGPointMake(1.f, 1.f);
	separatorLayer.position = CGPointMake(self.layer.bounds.size.width, self.layer.bounds.size.height);
	[self.layer addSublayer:separatorLayer];
}

@end
