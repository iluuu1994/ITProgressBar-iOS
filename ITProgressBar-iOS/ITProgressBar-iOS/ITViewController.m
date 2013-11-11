//
//  ITViewController.m
//  ITProgressBar-iOS
//
//  Created by Ilija Tovilo on 11/11/13.
//  Copyright (c) 2013 Ilija Tovilo. All rights reserved.
//

#import "ITViewController.h"

@interface ITViewController ()

@end

@implementation ITViewController

- (IBAction)setProgress:(UISlider *)sender {
    self.progressBar.progress = [sender value];
}

- (IBAction)toggleAnimates:(id)sender {
    self.progressBar.animates = !self.progressBar.animates;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
