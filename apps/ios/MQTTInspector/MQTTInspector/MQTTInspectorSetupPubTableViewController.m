//
//  MQTTInspectorSetupPubTableViewController.m
//  MQTTInspector
//
//  Created by Christoph Krey on 14.11.13.
//  Copyright © 2013-2016 Christoph Krey. All rights reserved.
//

#import "MQTTInspectorSetupPubTableViewController.h"
#import "MQTTInspectorDetailViewController.h"
#import "MQTTInspectorDataViewController.h"

#import "Model.h"

@interface MQTTInspectorSetupPubTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *topicText;
@property (weak, nonatomic) IBOutlet UITextField *dataText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *qosSegment;
@property (weak, nonatomic) IBOutlet UISwitch *retainSwitch;

@end

@implementation MQTTInspectorSetupPubTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = self.pub.name;
    
    self.nameText.text = self.pub.name;
    self.topicText.text = self.pub.topic;
    self.dataText.text = [[NSString alloc] initWithData:self.pub.data encoding:NSUTF8StringEncoding];
    self.qosSegment.selectedSegmentIndex = [self.pub.qos intValue];
    self.retainSwitch.on = [self.pub.retained boolValue];
    self.nameText.delegate = self;
    self.topicText.delegate = self;
    self.dataText.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)nameChanged:(UITextField *)sender {
    NSString *newName = sender.text;
    
    Publication *existingPub = [Publication existsPublicationWithName:newName
                                                             session:self.pub.belongsTo
                                              inManagedObjectContext:self.pub.managedObjectContext];
    if (!existingPub || (existingPub == self.pub)) {
        self.pub.name = newName;
        self.title = self.pub.name;

    } else {
        [MQTTInspectorDetailViewController alert:@"Duplicate PUB"];
    }

}
- (IBAction)topicChanged:(UITextField *)sender {
    self.pub.topic = sender.text;
}
- (IBAction)dataChanged:(UITextField *)sender {
    self.pub.data = [sender.text dataUsingEncoding:NSUTF8StringEncoding];
}
- (IBAction)qosChanged:(UISegmentedControl *)sender {
    self.pub.qos = @(sender.selectedSegmentIndex);
}
- (IBAction)retainChanged:(UISwitch *)sender {
    self.pub.retained = @(sender.on);
}


@end
