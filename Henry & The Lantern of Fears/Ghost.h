//
//  Ghost.h
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 1/26/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Henry.h"

@interface Ghost : SKSpriteNode
+(id)ghost;
-(void)attackPlayer:(Henry *)henry;
@end
