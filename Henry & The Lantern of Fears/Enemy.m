//
//  Enemy.m
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 1/23/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "Enemy.h"
#import "Henry.h"

@implementation Enemy

+(id)enemy:(NSString *)imageName withLife:(int)life withScore:(int)score
{
    
    Enemy *enemy = [Enemy spriteNodeWithImageNamed:imageName];
    
    enemy.life = life;
    enemy.score = score;
    
    
    return enemy;
}

-(void)die
{
        [self removeFromParent];
    
}
-(void)receiveDamage
{
    self.life--;
    
    if (self.life <= 0) {
        [self die];
    }
    
}


@end
