//
//  BackgroundGenerator.m
//  Henry & The Lantern of Fears
//
//  Created by Ivee Mendes Marins on 2/26/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "BackgroundGenerator.h"

@implementation BackgroundGenerator


+(BackgroundGenerator *) createBackgroundGenerator
{
    BackgroundGenerator *generator = [BackgroundGenerator node];
    generator.layers = [NSMutableArray array];
    return generator;
}

-(void)generateBackgroundWithImage:(NSString *)backgroundImageName repeat:(int)times OnZPosition:(int)zPosition WithFrameSize:(CGSize)size WithStartPosition:(CGFloat)startPosition {
    
    CGFloat currentBackgroundX = startPosition;
    SKNode *backgroundLayer = [SKNode node];
    
    for (int i = 0; i < times; i++) {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:backgroundImageName normalMapped:NO];
        //background.lightingBitMask = 0x1 << 31;
        background.size = size;
        background.position = CGPointMake(currentBackgroundX,70);
        background.name = @"background";
        backgroundLayer.zPosition = zPosition;
        [backgroundLayer addChild:background];
        currentBackgroundX += background.frame.size.width;
    }
    
    [self.layers addObject:backgroundLayer];
    
}

@end
