//
//  OptionsViewController.m
//  Ônibus Rio
//
//  Created by Vinicius Bittencourt on 28/05/14.
//  Copyright (c) 2014 Vinicius Bittencourt. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController ()
@property (strong, nonatomic) IBOutlet UIButton *buttonClose;

@property (strong, nonatomic) IBOutlet UISegmentedControl *tupo;
@property (strong, nonatomic) IBOutlet UISwitch *traf;
@property (strong, nonatomic) IBOutlet UIButton *fbbutton;

@end

@implementation OptionsViewController
@synthesize buttonClose;
@synthesize tupo;
@synthesize traf;
@synthesize fbbutton;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   NSInteger myInt = [prefs integerForKey:@"Tipo"];
    if (myInt == nil){
        tupo.selectedSegmentIndex = 0;
    }
    else if (myInt == 0){
        tupo.selectedSegmentIndex = 0;
    }else{
        tupo.selectedSegmentIndex = 1;
    }
    
        
    BOOL trafego = [prefs boolForKey:@"Transito"];
    if (trafego == nil)
        trafego = NO;
    traf.on = trafego;
    

    buttonClose.layer.cornerRadius = 10;
    fbbutton.layer.cornerRadius = 10;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fb:(id)sender {
    NSURL *url = [NSURL URLWithString:@"fb://profile/1408367169433222"];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


- (IBAction)fechar:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if([tupo selectedSegmentIndex] == 0){
      [prefs setInteger:0 forKey:@"Tipo"];
    }
    else if([tupo selectedSegmentIndex] == 1){
      [prefs setInteger:1 forKey:@"Tipo"];
    }
    
    [prefs setBool:traf.on forKey:@"Transito"];
    // – setBool:forKey:
    // – setFloat:forKey:
    // in your case

    
    [self dismissViewControllerAnimated:YES completion:NO];
}
*/
@end
