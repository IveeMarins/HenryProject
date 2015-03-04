//
//  Constants.m
//  Henry & The Lantern of Fears
//
//  Created by Ivee Mendes Marins on 3/3/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "Constants.h"

@implementation Constants

const uint32_t GROUND_CATEGORY = 0x1;
const uint32_t PLAYER_CATEGORY = 0x1 << 1;
const uint32_t ENEMY_CATEGORY = 0x1 << 2;
const uint32_t KILL_ENEMY_CATEGORY = 0x1 << 3;
const uint32_t ENERGY_CATEGORY = 0x1 << 4;
const uint32_t VICTORY_LIGHT_CATEGORY = 0x1 << 28;
const uint32_t LIGHT_CATEGORY = 0x1 << 31;

@end
