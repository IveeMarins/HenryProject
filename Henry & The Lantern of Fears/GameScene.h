//
//  GameScene.h
//  Henry & The Lantern of Fears
//

//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>
@property (strong, nonatomic) SKLabelNode *lifeLabel;
@property (nonatomic) int numberOfLives;

@end
