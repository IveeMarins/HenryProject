//
//  Energy.h
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/9/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Energy : SKNode
+(id)energy;
-(void)collectToPosition:(CGPoint)position;
-(void)setParticleTarget;

@property SKEmitterNode *energyEmmiter;

@end
