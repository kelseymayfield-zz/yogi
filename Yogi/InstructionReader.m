//
//  InstructionReader.m
//  
//
//  Created by Kelsey Mayfield on 4/10/15.
//
//

#import "InstructionReader.h"

@interface InstructionReader()
@property (strong, nonatomic) AVSpeechSynthesizer *synth;
@property (strong, nonatomic) NSMutableArray *nextInstructions;
@end

@implementation InstructionReader

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
	if ([self.nextInstructions count])
		[self readNextInstruction];
	else
		[[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedSpeechNotification" object:self];
}

-(void)addInstruction:(NSString *)instruction
{
	[self addInstruction:instruction withBreaths:0];
}

-(void)addInstruction:(NSString *)instruction withBreaths:(NSInteger)breaths
{
	[self.nextInstructions addObject:instruction];
	[self readNextInstruction];
	[self addBreathInstructions:breaths];
}

-(void)readNextInstruction
{
//	NSLog(@"Read next instruction.");
	NSString *instruction = self.nextInstructions[0];
	if (instruction) {
//		NSLog(@"reading");
		[self.nextInstructions removeObjectAtIndex:0];
		AVSpeechUtterance *ut = [AVSpeechUtterance speechUtteranceWithString:instruction];
		ut.rate = 0.15;
		ut.postUtteranceDelay = 0.35;
		[self.synth speakUtterance:ut];
	}
}

-(void)addBreathInstructions:(NSInteger)breaths
{
	for (NSInteger i = 0; i < breaths; i++) {
		AVSpeechUtterance *inhaleUtterance = [AVSpeechUtterance speechUtteranceWithString:@"Inhale."];
		inhaleUtterance.rate = 0.15;
		inhaleUtterance.postUtteranceDelay = 1.3;
		[self.synth speakUtterance:inhaleUtterance];
		AVSpeechUtterance *exhaleUtterance = [AVSpeechUtterance speechUtteranceWithString:@"Exhale."];
		exhaleUtterance.rate = 0.15;
		exhaleUtterance.postUtteranceDelay = 1.3;
		[self.synth speakUtterance:exhaleUtterance];
	}
}

-(NSMutableArray *)nextInstructions
{
	if (!_nextInstructions)
		_nextInstructions = [NSMutableArray new];
	return _nextInstructions;
}

-(AVSpeechSynthesizer *)synth
{
	if (!_synth) {
		_synth = [AVSpeechSynthesizer new];
		_synth.delegate = self;
	}
	return _synth;
}

-(void)pause
{
	[self.synth pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
}

-(void)play
{
	[self.synth continueSpeaking];
}

@end