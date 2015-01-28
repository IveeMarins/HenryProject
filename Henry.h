//
//  Henry.h
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 1/22/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Henry : SKSpriteNode

@property (strong, nonatomic) SKShapeNode *killPolygon;


+(id)henry;
-(void)walkRight;
-(void)walkLeft;
-(void)jump;
-(void)idleAnimation;
-(void)pickLantern;
@end
