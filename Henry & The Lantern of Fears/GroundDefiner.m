//
//  GroundDefiner.m
//  Henry & The Lantern of Fears
//
//  Created by Ivee Mendes Marins on 3/3/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "GroundDefiner.h"
#import "Constants.h"

@implementation GroundDefiner

+(GroundDefiner *) createGroundDefiner
{
    GroundDefiner *definer = [GroundDefiner node];
    definer.ground = [SKNode node];
    return definer;
}

-(float) generateGroundWithImage: (NSString *) groundImageName repeat: (int) times WithFrameSize:(CGSize)size WithStartPoint: (float) currentGroundX
{
    
    
    if([groundImageName isEqualToString:@"ground"]){
        
        for (int i = 0; i < times; i++) {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
            ground.size = CGSizeMake(size.width , 100);
            ground.position = CGPointMake(currentGroundX, - size.height * 0.5 + ground.frame.size.height * 0.5);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(size.width , 50)];
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = GROUND_CATEGORY;
            [self.ground addChild:ground];
            currentGroundX += ground.frame.size.width;
        }
        
        
    }
    else if([groundImageName isEqualToString:@"groundBig"]){
        
        for (int i = 0; i < times; i++) {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"groundBig"];
            ground.size = CGSizeMake(size.width , 160);
            ground.position = CGPointMake(currentGroundX, - size.height * 0.5 + ground.frame.size.height * 0.5);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(size.width, 80)];
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = GROUND_CATEGORY;
            [self.ground addChild:ground];
            currentGroundX += ground.frame.size.width;
        }
        
        
    }
    else if([groundImageName isEqualToString:@"groundRamp"]){
        
        for (int i = 0; i < times; i++) {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"groundRamp"];
            ground.size = CGSizeMake(size.width , 160);
            ground.position = CGPointMake(currentGroundX, - size.height * 0.5 + ground.frame.size.height * 0.5);
            ground.physicsBody = [SKPhysicsBody bodyWithTexture:[SKTexture textureWithImageNamed:@"groundRamp"] size:CGSizeMake(ground.frame.size.width, ground.frame.size.height - 90)];
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = GROUND_CATEGORY;
            [self.ground addChild:ground];
            currentGroundX += ground.frame.size.width;
            
        }
        
        
    }
    else if([groundImageName isEqualToString:@"spikes"]){
        
        for (int i = 0; i < times; i++) {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"spikes"];
            ground.size = CGSizeMake(size.width * 0.25 , 80);
            ground.position = CGPointMake(currentGroundX - size.width * 0.5 + ground.frame.size.width * 0.5, - size.height * 0.5 + ground.frame.size.height * 0.5);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(ground.size.width - 90, ground.size.height)];
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = ENEMY_CATEGORY;
            ground.physicsBody.collisionBitMask = PLAYER_CATEGORY;
            [self.ground addChild:ground];
            currentGroundX += ground.frame.size.width;
            
        }
        
        
    }
    return currentGroundX;
}
@end
