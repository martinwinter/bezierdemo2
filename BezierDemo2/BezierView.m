//
//  BezierView.m
//  BezierDemo2
//
//  Created by Martin Winter on 28.09.14.
//  Copyright (c) 2014 Martin Winter. All rights reserved.
//

#import "BezierView.h"


@implementation BezierView


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSGraphicsContext *graphicsContext = [NSGraphicsContext currentContext];
    CGContextRef context = [graphicsContext graphicsPort];
    
    NSString *string = @"a";
    NSString *fontName = @"MinionPro-Regular";
    CGFloat fontSize = 1000.0;
    
    CFMutableAttributedStringRef attributedString = CFAttributedStringCreateMutable(NULL, 1); // Length 1.
    
    CFAttributedStringBeginEditing(attributedString);
    
    // Set string.
    CFAttributedStringReplaceString(attributedString, 
                                    CFRangeMake(0, 0), 
                                    (CFStringRef)string);
    
    CFRange range = CFRangeMake(0, CFAttributedStringGetLength(attributedString));
    
    // Set font (family, weight and size).
    CTFontRef font = CTFontCreateWithName((CFStringRef)fontName, fontSize, NULL);
    
    CFAttributedStringSetAttribute(attributedString, 
                                   range, 
                                   kCTFontAttributeName, 
                                   font);
    
    CFAttributedStringEndEditing(attributedString);

    // Use a typesetter to obtain a bezier path for the glyph.
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CTLineRef line = CTTypesetterCreateLine(typesetter, range);
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    CTRunRef run = CFArrayGetValueAtIndex(runs, 0); // Should contain only one run.
    CGGlyph buffer[range.length];
    CTRunGetGlyphs(run, range, buffer);
    CGGlyph glyph = buffer[0]; // Should contain only one glyph.
    CGPathRef CGPath = CTFontCreatePathForGlyph(font, glyph, NULL);


    CGContextAddPath(context, CGPath);
    CGContextClip(context);

    
    NSImage *image = [NSImage imageNamed:@"IMG_6211 small.jpg"];
    CGImageRef CGImage = [image CGImageForProposedRect:NULL context:graphicsContext hints:nil];
    CGRect rect = [self bounds];
    CGContextDrawImage(context, rect, CGImage);
    
    
    CGContextAddPath(context, CGPath);
    CGContextSetLineWidth(context, 3);
    CGContextStrokePath(context);


    // Clean up.
    CFRelease(CGPath);
    CFRelease(line);
    CFRelease(typesetter);
    CFRelease(font);
    CFRelease(attributedString);
}


@end
