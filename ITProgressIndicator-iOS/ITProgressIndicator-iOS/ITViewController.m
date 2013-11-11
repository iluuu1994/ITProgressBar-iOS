//
//  ITViewController.m
//  ITProgressIndicator-iOS
//
//  Created by Ilija Tovilo on 08/11/13.
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
