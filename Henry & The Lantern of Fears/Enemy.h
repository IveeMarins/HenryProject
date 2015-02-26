//
//  Enemy.h
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 1/23/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Henry.h"
#import <AVFoundation/AVFoundation.h>

@interface Enemy : SKSpriteNode
//@property (strong, nonatomic) NSString *imageName;
//@property (nonatomic) int life;
//@property (nonatomic) int score;
//+(id)enemy:(NSString *)imageName withLife:(int)life withScore:(int)score;
//-(void)receiveDamage;
//-(void)die;



+(id)createEnemy;
-(void)attackPlayer:(Henry *)henry;
-(void)animate;
-(void)death;

@property (strong, nonatomic) AVAudioPlayer *soundPlayer;
@property (strong, nonatomic) AVAudioPlayer *EnemySoundPlayer;




@end
