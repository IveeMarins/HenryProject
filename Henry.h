//
//  Henry.h
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 1/22/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
// 

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Henry : SKSpriteNode



+(id)henry;
-(void)walkRight;
-(void)walkLeft;
-(void)jump;
-(void)idleAnimation;
-(void)idleAnimationLeft;
-(void)pickLantern;
-(void)deathAnimation;
-(void)deathAnimationLeft;
@property (strong, nonatomic) AVAudioPlayer *soundPlayer;
@end






