//
//  InstructionReader.h
//  Yogi
//
//  Created by Kelsey Mayfield on 4/10/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@interface InstructionReader : NSObject <AVSpeechSynthesizerDelegate>

- (void)addInstruction:(NSString *)instruction;
- (void)addInstruction:(NSString *)instruction withBreaths:(NSInteger)breaths;
- (void)pause;
- (void)play;
@end
