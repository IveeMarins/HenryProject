//
//  FasesMundo1.m
//  Henry & The Lantern of Fears
//
//  Created by Ivee Mendes Marins on 1/30/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "FasesMundo1.h"
#import "GameScene.h"

@implementation FasesMundo1
{
    SKSpriteNode *_fasesBackground;
    SKSpriteNode *_fase1;
    SKLabelNode *_carregando;
    SKSpriteNode *_configuracao;
    SKShapeNode *_circle;
    
}
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        _fasesBackground = [SKSpriteNode spriteNodeWithImageNamed:(@"fasesScene")];
        _fasesBackground.position = CGPointMake(0,0);
        _fasesBackground.size = CGSizeMake(self.scene.frame.size.width , self.scene.frame.size.height) ;
        [self addChild: _fasesBackground];
        
        _fase1 = [SKSpriteNode spriteNodeWithImageNamed:@"fase1"];
        _fase1.position = CGPointMake(-200,60);
        _fase1.size = CGSizeMake(65, 30);
        _fase1.name = @"fase1";
        
        [self addChild: _fase1];
        [self animateWithPulse: _fase1];
        
        _circle = [SKShapeNode shapeNodeWithCircleOfRadius:12.0];
        _circle.position = CGPointMake( self.scene.frame.size.width *0.5 +300, self.scene.frame.size.height * 0.5 + 170);
        _circle.fillColor = [UIColor whiteColor];
        _circle.lineWidth = 2;
        _circle.zPosition= 1;
        
        _configuracao = [SKSpriteNode spriteNodeWithImageNamed:@"gear"];
        _configuracao.size = CGSizeMake(20.0,20.0);
        _configuracao.position = CGPointMake( self.scene.frame.size.width *0.5 +300, self.scene.frame.size.height * 0.5 + 170);
        _configuracao.zPosition=1;
        [self addChild:_circle];
        [self addChild:_configuracao];
        
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        if([n.name isEqualToString:@"fase1"]){
            
            NSString *fontName = [NSString stringWithFormat:@"KGLuckoftheIrish"];
            _carregando = [SKLabelNode labelNodeWithFontNamed:fontName];
            _carregando.text = @"Carregando...";
            _carregando.fontColor = [UIColor whiteColor];
            _carregando.fontSize = 50;
            _carregando.position = CGPointMake(0,0);
            _carregando.name = @"carregando";
            _carregando.zPosition = 1;
            
            [self addChild:_carregando];
        }
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        if([n.name isEqualToString:@"fase1"]){
            
            GameScene *scene = [[GameScene alloc] initWithSize:self.view.bounds.size];
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
