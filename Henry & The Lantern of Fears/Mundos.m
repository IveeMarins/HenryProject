//
//  Mundos.m
//  Henry & The Lantern of Fears
//
//  Created by Bruno Baring on 1/26/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "Mundos.h"
#import "GameScene.h"
#import "FasesMundo1.h"

@implementation Mundos
{
    SKSpriteNode *_world;
    SKSpriteNode *_world1;
    SKLabelNode *_carregando;
    SKSpriteNode *_configuracao;
    SKShapeNode *_circle;

}
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        _world = [SKSpriteNode spriteNodeWithImageNamed:(@"worldScene")];
        _world.position = CGPointMake(self.scene.frame.size.width * 0.5 , self.scene.frame.size.height * 0.5);
        _world.size = CGSizeMake(self.scene.frame.size.width , self.scene.frame.size.height) ;
        [self addChild: _world];
        
        _world1 = [SKSpriteNode spriteNodeWithImageNamed:@"cristalVerde"];
        _world1.position = CGPointMake(80, 250);
        _world1.size = CGSizeMake(80, 80);
        _world1.name = @"mundo1";
        
        [self addChild: _world1];
        [self animateWithPulse: _world1];
        
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        if([n.name isEqualToString:@"mundo1"]){
           
            FasesMundo1 *scene = [[FasesMundo1 alloc] initWithSize:self.view.bounds.size];
            
            scene.anchorPoint = CGPointMake(0.5, 0.5);
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            SKTransition *reveal = [SKTransition fadeWithDuration:3];
            [self.view presentScene:scene transition: reveal];
            
        }
    }
}

-(void)animateWithPulse:(SKNode *)node
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:0.8];
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:0.8];
    SKAction *pulse = [SKAction sequence:@[disappear,appear]];
    [node runAction:[SKAction repeatActionForever:pulse]];
}

@end
