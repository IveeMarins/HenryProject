//
//  GameScene.h
//  Henry & The Lantern of Fears
//

//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) AVAudioPlayer *musicPlayer;

@end
