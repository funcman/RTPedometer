#import "ViewController.h"
#import <UIKit/UIAccelerometer.h>
#include <list>
#import "OscilloscopeView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet OscilloscopeView* screenView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation ViewController

std::list<double> amplitudes;
std::list<double>::iterator amplitudes_itr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    amplitudes_itr = amplitudes.end();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start:(id)sender {
    static UIAccelerometer* accelerometer;
    static NSTimer* timer;
    static BOOL isRunning = NO;
    isRunning = !isRunning;
    if (isRunning) {
        [self.startBtn setTitle:@"Stop" forState:UIControlStateNormal];
        accelerometer = [UIAccelerometer sharedAccelerometer];
        accelerometer.delegate = self;
        accelerometer.updateInterval = 0.1;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showAmplitudes) userInfo:nil repeats:YES];
    }else {
        amplitudes.erase(amplitudes_itr, amplitudes.end());
        [self.startBtn setTitle:@"Start" forState:UIControlStateNormal];
        accelerometer.delegate = nil;
        [timer invalidate];
    }
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
    double amplitude = sqrt(acceleration.x*acceleration.x + acceleration.y*acceleration.y + acceleration.z*acceleration.z);
    amplitudes.push_front(amplitude);
}

- (void)showAmplitudes {
    NSMutableArray* amplitudeArray = [[NSMutableArray alloc]init];
    std::list<double>::iterator itr = amplitudes.begin();
    for (int i=0; i<self.screenView.frame.size.width/2 && itr!=amplitudes.end(); ++i, ++itr) {
        [amplitudeArray addObject:[NSNumber numberWithDouble:*itr]];
    }
    amplitudes_itr = itr;
    self.screenView.amplitudes = amplitudeArray;
    [self.screenView setNeedsDisplay];
}

@end
