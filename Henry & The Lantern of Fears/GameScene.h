//
//  GameScene.h
//  Henry & The Lantern of Fears
//

//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (strong, nonatomic) SKLabelNode *lifeLabel;
@property (nonatomic) int numberOfLives;
@property (nonatomic) int score;
@property (strong, nonatomic) AVAudioPlayer *soundPlayer;
@property (strong, nonatomic) AVAudioPlayer *musicPlayer;


@end
