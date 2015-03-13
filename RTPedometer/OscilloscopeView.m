#import "OscilloscopeView.h"

@implementation OscilloscopeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    CGPoint* points = new CGPoint[[self.amplitudes count]];
    for (int i=0; i<[self.amplitudes count]; ++i) {
        double amplitude = [[self.amplitudes objectAtIndex:i]doubleValue];
        points[i].x = i*2;
        points[i].y = -amplitude*50 + self.frame.size.height;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    CGContextAddLines(context, points, [self.amplitudes count]);
    CGContextStrokePath(context);
    delete[] points;
}

@end
