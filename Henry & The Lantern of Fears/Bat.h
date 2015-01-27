//
//  Bat.h
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 1/23/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Henry.h"

@interface Bat : SKSpriteNode

+(id)bat;
-(void)attackPlayer:(Henry *)henry;
@end
