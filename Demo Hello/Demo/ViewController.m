//
//  ViewController.m
//  Demo
//
//  Created by Ravi on 14/08/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

#import "ViewController.h"




@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailIdText;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (nonatomic, strong) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) NSString *name;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)UIEvent{
    [self.view endEditing:YES];
}
- (IBAction)loginbuttonpressed:(id)sender {
    _name= [self.textFieldName text];
    _name= [NSString stringWithFormat:@"%s%@", "Hello   ", _name];
    [self.notificationLabel setText:_name];
}

@end

