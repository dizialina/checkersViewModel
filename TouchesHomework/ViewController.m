//
//  ViewController.m
//  TouchesHomework
//
//  Created by Admin on 22.11.15.
//  Copyright © 2015 Alina Egorova. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (assign, nonatomic) CGRect bigWhiteRect;
@property (weak, nonatomic) UIView* board;
@property (strong, nonatomic) NSMutableArray* littleRects;
@property (strong, nonatomic) NSMutableArray* rectsCenter;
@property (strong, nonatomic) NSMutableArray* figures;
@property (weak, nonatomic) UIView* draggingView;
@property (assign, nonatomic) CGPoint center;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    CGFloat min = MIN(CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds));
    CGFloat max = MAX(CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds));
    
    self.view.backgroundColor = [UIColor grayColor];
    
    CGRect whiteRect = CGRectMake(0, (max - min) / 2, min, min);
    self.bigWhiteRect = whiteRect;
    
    UIView* bigWhiteRect = [[UIView alloc] initWithFrame:self.bigWhiteRect];
    bigWhiteRect.backgroundColor = [UIColor whiteColor];
    self.board = bigWhiteRect;
    [self.view addSubview:bigWhiteRect];
    
    CGFloat size = CGRectGetWidth(self.bigWhiteRect) / 8;
    
    CGFloat x = 0;
    CGFloat y = 0;
    NSInteger count = 1;
    
    self.littleRects = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 32; i++) {
        
        UIView* littleRect = [[UIView alloc] initWithFrame:CGRectMake(x, y, size, size)];
        littleRect.backgroundColor = [UIColor blackColor];
        [self.littleRects addObject:littleRect];
        x = x + (size * 2);
        
        if (x >= CGRectGetWidth(self.bigWhiteRect)) {
            y = y + size;
            count++;
            if (count%2 == 0) {
                x = 0 + size;
            } else {
                x = 0;}
        }
        
        [self.board addSubview:littleRect];
    }
    
    self.board.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |                                                    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    
    
    self.figures = [[NSMutableArray alloc] init];
    
    [self addFiguresFromRectNumber:1 toNumber:12 withColor:[UIColor blueColor]];
    [self addFiguresFromRectNumber:21 toNumber:32 withColor:[UIColor redColor]];
    
    self.rectsCenter = [[NSMutableArray alloc] init];
    
    for (UIView* rect in self.littleRects) {
        
        CGPoint point = CGPointMake(CGRectGetMidX(rect.frame), CGRectGetMidY(rect.frame));

        [self.rectsCenter addObject:[NSValue valueWithCGPoint:point]];
        
    }
    

    
    
    
}


- (void) touchesBegan:(NSSet<UITouch*>*) touches withEvent:(UIEvent*) event {
    
    UITouch* touch = [touches anyObject];
    CGPoint pointOnMainView = [touch locationInView:self.view];
    UIView* view = [self.view hitTest:pointOnMainView withEvent:event];
    
    
    for (UIView* figure in self.figures) {
            
        if ([view isEqual:figure]) {
            self.draggingView = view;
            [self.view bringSubviewToFront:self.draggingView];
            
            [self.draggingView.layer removeAllAnimations];
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.draggingView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                                 self.draggingView.alpha = 0.5f;
                             }];
            
            self.center = self.draggingView.center;
        }
        
    }
    
    
}

- (void) touchesMoved:(NSSet<UITouch*>*) touches withEvent:(UIEvent*) event {
    
    if (self.draggingView) {
        
        UITouch* touch = [touches anyObject];
        CGPoint pointOnMainView = [touch locationInView:self.board];
        self.draggingView.center = pointOnMainView;
               
    }
    
    
}

- (void) touchesEnded:(NSSet<UITouch*>*) touches withEvent:(UIEvent*) event {
    
    CGPoint newCenter = self.draggingView.center;
    
    CGFloat min = 10000.f;
    CGFloat delta = 0;
    CGFloat newX = 0;
    CGFloat newY = 0;
    
    UITouch* touch = [touches anyObject];
    
    CGPoint pointOnMainView = [touch locationInView:self.view];
    
    UIView* view = [self.view hitTest:pointOnMainView withEvent:event];
    
    if (![view isEqual:self.view]) {
        
        NSMutableArray* figures = [[NSMutableArray alloc] init];
        
        for (UIView* figure in self.figures) {
            
            CGPoint point = CGPointMake(CGRectGetMidX(figure.frame), CGRectGetMidY(figure.frame));
            
            [figures addObject:[NSValue valueWithCGPoint:point]];
            
        }

        
        for (id centers in self.rectsCenter) {
        
            CGPoint p = [centers CGPointValue];
        
            delta = (p.x - newCenter.x) * (p.x - newCenter.x) + (p.y - newCenter.y) * (p.y - newCenter.y);
                    
            if (delta < min) {
                        
                min = delta;
                newX = p.x;
                newY = p.y;
                        
            }
                    
        }
                
        self.draggingView.center = CGPointMake(newX, newY);
        
        for (id figure in figures) {
            
            CGPoint c = [figure CGPointValue];
            
            if (newX == c.x && newY == c.y) {
                self.draggingView.center = self.center;
            }
            
        }
        
    
        
        
        
    } else {
        
        self.draggingView.center = self.center;
        
    }
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.draggingView.transform = CGAffineTransformIdentity;
                         self.draggingView.alpha = 1.f;
                     }];
    
    self.draggingView = nil;
    
    

    
}

- (void) touchesCancelled:(NSSet<UITouch*>*) touches withEvent:(UIEvent*) event {
    
    self.draggingView = nil;
    
}



- (void) addFiguresFromRectNumber:(NSInteger) firstRect toNumber:(NSUInteger) lastRest withColor:(UIColor*) color {
    
    for (int i = (int)firstRect; i <= lastRest; i++) {
        
        UIView* rect = [self.littleRects objectAtIndex:(i - 1)];
        
        UIView* figure = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rect.frame), CGRectGetMinY(rect.frame), CGRectGetWidth(rect.frame), CGRectGetHeight(rect.frame))];
        
        figure.backgroundColor = color;
        figure.layer.cornerRadius = 30.f;
        
        [self.board addSubview:figure];
        [self.figures addObject:figure];
        
    }

}





- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
