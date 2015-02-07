//
//  Menu.m
//  Henry & The Lantern of Fears
//
//  Created by Bruno Baring on 1/26/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "Menu.h"
#import "GameScene.h"
#import "GameViewController.h"
#import "Mundos.h"

@implementation Menu
{
        SKSpriteNode *_lanternInicial;
}
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size])
    {
        //Adicionando: Background, Start e Lanterna
        SKSpriteNode *background;
        background = [SKSpriteNode spriteNodeWithImageNamed: @"telaInicial"];
        background.position = CGPointMake(self.scene.frame.size.width * 0.5, self.scene.frame.size.height * 0.5);
        background.size = CGSizeMake(self.scene.frame.size.width , self.scene.frame.size.height);
        [self addChild:background];
        
        _lanternInicial = [SKSpriteNode spriteNodeWithImageNamed:@"lanternInicial"];
        _lanternInicial.position = CGPointMake(background.frame.size.width * 0.5, background.frame.size.height * 0.5 - 35);
        [_lanternInicial setScale: 0.6];
        [self addChild: _lanternInicial];
        
        SKSpriteNode *buttonStart = [SKSpriteNode spriteNodeWithImageNamed:@"buttonStart"];
        buttonStart.position = CGPointMake(_lanternInicial.position.x,_lanternInicial.position.y - 90);
        buttonStart.name = @"start";
        [buttonStart setScale:0.5];
        [self addChild: buttonStart];
        [self animateWithPulse: _lanternInicial];
        
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        if([n.name isEqualToString:@"start"])
        {

            NSString *lanternLightEmmiterPath = [[NSBundle mainBundle] pathForResource:@"LanternMagicFirstScreen" ofType:@"sks"];
            SKEmitterNode *lanternLightEmmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:lanternLightEmmiterPath];
            
            lanternLightEmmitter.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5 - 50);
            lanternLightEmmitter.name = @"lanternLightParticle";
            //lanternLightEmmitter.particleScale = ;
            //lanternLightEmmitter.particleLifetime = 100000;
           
            //lanternLightEmmitter.particleSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
            
            SKLightNode *lanternLight = [[SKLightNode alloc] init];
            lanternLight.name = @"lanternLight";
            lanternLight.position = CGPointMake(_lanternInicial.frame.size.width * 0.5, _lanternInicial.frame.size.height *0.5);
            
            [lanternLightEmmitter addChild:lanternLight];
            [self addChild:lanternLightEmmitter];
            
            
            NSLog(@"mundou pro mundo");
            
            double delayInSeconds = 3.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                Mundos *scene = [[Mundos alloc] initWithSize:self.view.bounds.size];
                scene.scaleMode = SKSceneScaleModeAspectFill;
                
                // Present the scene.
                SKTransition *reveal = [SKTransition fadeWithDuration:1];
                [self.view presentScene:scene transition: reveal];
            });
            
        }
    }
}


-(void)animateWithPulse:(SKNode *)node
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:1];
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:1];
    SKAction *pulse = [SKAction sequence:@[disappear,appear]];
    [node runAction:[SKAction repeatActionForever:pulse]];
}

@end



