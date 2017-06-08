//
//  KMZViewController.m
//  ExampleProject
//
//  Created by Kentaro Matsumae on 2014/09/07.
//  Copyright (c) 2014年 kenmaz.net. All rights reserved.
//

#import "KMZViewController.h"
#import "KMZDrawView.h"

@interface KMZViewController () <KMZDrawViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *penSelector;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoButtonItem;
@property (weak, nonatomic) IBOutlet KMZDrawView *drawView;
@end

@implementation KMZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.drawView.delegate = self;
    self.drawView.penWidth = 5;
    [self _updateUndoRedoButton];
}

- (IBAction)touchUndoButton:(id)sender {
    [self.drawView undo];
    [self _updateUndoRedoButton];
}

- (IBAction)touchRedoButton:(id)sender {
    [self.drawView redo];
    [self _updateUndoRedoButton];
}

- (IBAction)touchPenSelector:(id)sender {
    NSInteger idx = self.penSelector.selectedSegmentIndex;
    if (idx == 0) {
        self.drawView.penMode = KMZLinePenModePencil;
    } else {
        
        self.drawView.penMode = KMZLinePenModeEraser;
    }
}

- (void)_updateUndoRedoButton {
    self.undoButtonItem.enabled = [self.drawView isUndoable];
    self.redoButtonItem.enabled = [self.drawView isRedoable];
}
- (IBAction)clear:(id)sender {
    [self.drawView clear];
}
- (IBAction)pickSign:(id)sender {
    if (self.drawView.image !=nil) {
        self.imageView.image = self.drawView.image;
        [self.navigationController popViewControllerAnimated:true];
    }
}

#pragma mark KMZDrawViewDelegate

- (void)drawView:(KMZDrawView*)drawView finishDrawLine:(KMZLine*)line {
    [self _updateUndoRedoButton];
}

@end
