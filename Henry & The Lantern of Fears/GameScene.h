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
<<<<<<< Updated upstream
@property (nonatomic) int score;
=======
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong,nonatomic) AVAudioPlayer *musicPLayer;
>>>>>>> Stashed changes
@end
