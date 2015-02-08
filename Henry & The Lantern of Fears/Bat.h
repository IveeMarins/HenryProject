//
//  Bat.h
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 1/23/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Henry.h"
#import <AVFoundation/AVFoundation.h>

@interface Bat : SKSpriteNode

+(id)bat;
-(void)attackPlayer:(Henry *)henry;
-(void)animate;
-(void)death;
@property (strong, nonatomic) AVAudioPlayer *soundPlayer;
@property (strong, nonatomic) AVAudioPlayer *batSoundPlayer;
@end
