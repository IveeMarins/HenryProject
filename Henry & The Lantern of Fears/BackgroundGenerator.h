//
//  BackgroundGenerator.h
//  Henry & The Lantern of Fears
//
//  Created by Ivee Mendes Marins on 2/26/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BackgroundGenerator : SKNode

@property (nonatomic) NSMutableArray *layers;

+(BackgroundGenerator *) createBackgroundGenerator;

-(void)generateBackgroundWithImage:(NSString *)backgroundImageName repeat:(int)times OnZPosition:(int)zPosition WithFrameSize:(CGSize)size WithStartPosition:(CGFloat)startPosition;



@end
