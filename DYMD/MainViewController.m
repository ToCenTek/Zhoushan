//
//  MainViewController.m
//  DYMD
//
//  Created by 蒋华阳 on 14-10-1.
//  Copyright (c) 2014年 蒋华阳. All rights reserved.
//

#import "MainViewController.h"
#import "RightView.h"
#import "Message.h"
#import "RightView.h"
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize dic;
@synthesize innerSubType = _innerSubType;
@synthesize playBtn;
@synthesize stopBtn;
@synthesize compu1;
@synthesize compu2;
@synthesize compu3;
@synthesize compu4;
@synthesize pro1;
@synthesize pro2;
@synthesize pro3;
@synthesize pro4;
@synthesize pro5;
@synthesize pro6;
@synthesize pro7;
@synthesize pro8;
@synthesize powerBtn;
@synthesize powerOnBtn;
@synthesize powerOffBtn;
@synthesize type;


@synthesize addressDic;
@synthesize message;
@synthesize TCpaddress;
-(IBAction)changeZhanTing:(UIButton*)sender{
    self.type = (int)sender.tag;
    [self ZhanTingInfo];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}
- (void)ZhanTingInfo{
    
    [self.playBtn setHidden:YES];
    [self.stopBtn setHidden:YES];
    [self.powerOnBtn setHidden:YES];
    [self.powerOffBtn setHidden:YES];
    self.rightView =  (RightView*)[self.view viewWithTag:100];
    [self.rightView setInfos:[self.dic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]]];
    
    NSLog(@"展厅ID=%@",[NSString stringWithFormat:@"%d",self.type]);
    
    NSDictionary *exhibitionHallDic = [self.dic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]];
    NSLog(@"展项ID=%d",self.innerSubType-1);
    NSDictionary *exhibitionItemDic =[exhibitionHallDic objectForKey:[NSString stringWithFormat:@"展项%d",self.innerSubType]];
    NSDictionary *computersDic = [exhibitionItemDic objectForKey:@"computers"];
    NSDictionary *projectorsDic = [exhibitionItemDic objectForKey:@"projectors"];
    int computerCount = (int)[[computersDic objectForKey:@"count"] integerValue];
    int projectorCount = (int)[[projectorsDic objectForKey:@"count"] integerValue];
    
    if(computerCount > 4) {
        computerCount = 4;
    }
    if(projectorCount > 8) {
        projectorCount = 8;
    }
    
    for (int i=1; i<=computerCount; i++) {
        NSDictionary *computer = [computersDic objectForKey:[NSString stringWithFormat:@"computer%i",i]];
        UIButton *btn = (UIButton*)[self.view viewWithTag:i+20];
        [btn setTitle:[computer objectForKey:@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipad界面单个-13.png"]] forState:UIControlStateNormal];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0,0, 5, 0);
        [btn setHidden:NO];
    }
    for(int i=computerCount+1;i<=4;i++) {
        UIButton *btn = (UIButton*)[self.view viewWithTag:i+20];
        [btn setHidden:YES];
    }
    for (int i=1; i<=projectorCount; i++) {
        NSDictionary *projector = [projectorsDic objectForKey:[NSString stringWithFormat:@"projector%i",i]];
        UIButton *btn = (UIButton*)[self.view viewWithTag:i+30];
        [btn setTitle:[projector objectForKey:@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipad界面单个-06.png"]] forState:UIControlStateNormal];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0,0, 5, 0);
        [btn setHidden:NO];
    }
    for(int i=projectorCount+1;i<=8;i++) {
        UIButton *btn = (UIButton*)[self.view viewWithTag:i+30];
        [btn setHidden:YES];
    }
    
    [self initMessage];
}

- (void)setInnerSubType:(int)innerSubType{
    _innerSubType = innerSubType;
    [self ZhanTingInfo];
}
- (void)setRightView{
    RightView *rightView = [[[NSBundle mainBundle] loadNibNamed:@"RightView" owner:self options:nil] objectAtIndex:0];
    CGRect rect = rightView.frame;
    rect.origin.x = 818;
    rect.origin.y = 153;
    [rightView setFrame:rect];
    [rightView setTag:100];
    
    [rightView setInfos:[self.dic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]]];
    rightView.controller = self;
    [self.view addSubview:rightView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"conf.plist" ofType:nil]];
    [self setRightView];
    type = (int)[[self.dic objectForKey:@"currentSelect"] integerValue];
    _innerSubType = 1;
    allSwitch = 0;
    [self ZhanTingInfo];
    
    NSDictionary *centerControllerConfigDic = [dic objectForKey:@"centerController"];
    NSString *ip = [centerControllerConfigDic objectForKey:@"ip"];
    int port = (int)[[centerControllerConfigDic objectForKey:@"port"] integerValue];
    
    self.message = [[Message alloc] initWithAddress:ip port:port];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)touchDown:(UIButton *)sender {

    UIButton *btn =(UIButton*)[self.view viewWithTag:[sender tag]];
    switch ([sender tag]) {
        case 50:
            [btn setImage:[UIImage imageNamed:@"ipad界面单个2-28.png"] forState:UIControlStateNormal];
            break;
        case 51:
            [btn setImage:[UIImage imageNamed:@"ipad界面单个2-29.png"] forState:UIControlStateNormal];
            break;
        case 52:
            [btn setImage:[UIImage imageNamed:@"ipad界面单个2-30.png"] forState:UIControlStateNormal];
            break;
        case 53:
            [btn setImage:[UIImage imageNamed:@"ipad界面单个2-31.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    //NSLog(@"%i",[sender tag]);
}
- (IBAction)touchCancel:(UIButton *)sender {

    UIButton *btn =(UIButton*)[self.view viewWithTag:[sender tag]];
    switch ([sender tag]) {
        case 50:
            [btn setImage:[UIImage imageNamed:@"ipad界面单个-07.png"] forState:UIControlStateNormal];
            break;
        case 51:
            [btn setImage:[UIImage imageNamed:@"ipad界面单个-08.png"] forState:UIControlStateNormal];
            break;
        case 52:
            [btn setImage:[UIImage imageNamed:@"ipad界面单个-09.png"] forState:UIControlStateNormal];
            break;
        case 53:
            [btn setImage:[UIImage imageNamed:@"ipad界面单个-10.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(IBAction)swtichPress:(UIButton*)sender{
    
    
    NSString *command = [NSString stringWithFormat:@"/%@/power",self.TCpaddress];
    
    UIButton *btn =(UIButton*)[self.view viewWithTag:[sender tag]];
    switch ([sender tag]) {
        case 50:
            [btn setImage:[UIImage imageNamed:@"ipad界面单个-07.png"] forState:UIControlStateNormal];
            command = [command stringByAppendingString:@"on"];
            [self.message sendMessage:command Float:1.0000];
            break;
        case 51:
            [btn setImage:[UIImage imageNamed:@"ipad界面单个-08.png"] forState:UIControlStateNormal];
            command = [command stringByAppendingString:@"off"];
            [self.message sendMessage:command Float:1.0000];
        default:
            break;
    }
    NSLog(@"%@",command);
}
-(IBAction)playAction:(UIButton*)sender{
    NSString *command = [NSString stringWithFormat:@"/%@/video",self.TCpaddress];
    
    UIButton *btn =(UIButton*)[self.view viewWithTag:[sender tag]];
    switch ([sender tag]) {
        case 52:
            [btn setImage:[UIImage imageNamed:@"ipad界面单个-09.png"] forState:UIControlStateNormal];
            command = [command stringByAppendingString:@"/play"];
            [self.message sendMessage:command Float:1.0000];
            break;
        case 53:
            [btn setImage:[UIImage imageNamed:@"ipad界面单个-10.png"] forState:UIControlStateNormal];
            command = [command stringByAppendingString:@"/stop"];
            [self.message sendMessage:command Float:1.0000];
        default:
            break;
    }
    NSLog(@"%@",command);
}
-(IBAction)projectPressed:(UIButton*)sender{
    
}
-(IBAction)videoPressed:(UIButton*)sender{
    
}
-(IBAction)showLeftView:(UIButton*)sender{
    //    for (int index = 1; index<=12; index++) {
    //         [[self.view viewWithTag:index] setHidden:![self.view viewWithTag:index].hidden];
    //    }
}
-(BOOL)isHideVolumeBtn{
    /*
     NSDictionary *dic = [self.dic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]];
     NSLog(@"%d",self.subType-1);
     NSDictionary *infoDic =[dic objectForKey:[NSString stringWithFormat:@"展项%d",self.subType]];
     NSLog(@"%@",infoDic);
     NSArray *compArr = [infoDic objectForKey:@"comp"];
     return [[compArr objectAtIndex:comType-21] componentsSeparatedByString:@";"].count;*/
    return true;
}
-(NSString*)getAddress{
    
    NSDictionary *exhibitionHallDic = [self.dic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]];
    NSDictionary *exhibitionItemDic =[exhibitionHallDic objectForKey:[NSString stringWithFormat:@"展项%d",self.innerSubType]];
    NSDictionary *computersDic = [exhibitionItemDic objectForKey:@"computers"];
    NSDictionary *projectorsDic = [exhibitionItemDic objectForKey:@"projectors"];
    
    if(comType > 0) {
        NSDictionary *computer = [computersDic objectForKey:[NSString stringWithFormat:@"computer%i",comType-20]];
        NSLog(@"%@",[computer objectForKey:@"ip"]);
        return [computer objectForKey:@"ip"];
    } else if(proType > 0) {
        NSDictionary *projector = [projectorsDic objectForKey:[NSString stringWithFormat:@"projector%i",proType-30]];
        NSLog(@"%@",[projector objectForKey:@"ip"]);
        return [projector objectForKey:@"ip"];
    } else{
        return nil;
    }
    
}
-(IBAction)showRightView:(UIButton*)sender{
    self.rightView.hidden = ! self.rightView.hidden;
}
-(void)initMessage{
    //    NSString *address = [self.addressDic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]];
    
}
//声音调节
-(void)sendVolumeCommomd{
    //  /layer1/clip1/connect
    //[self.message sendMessage:@"/layer1/audio/volume/values" Float:volume];
}
// 播放影片
-(void)sendPlayCommomd{
    //
    //[self.message sendMessage:@"/layer1/clip1/connect" Int:playFlag];
}

-(void)sendMessage:(int)type{
    
}

-(void)changeComIcon{
    NSDictionary *exhibitionHallDic = [self.dic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]];
    NSDictionary *exhibitionItemDic =[exhibitionHallDic objectForKey:[NSString stringWithFormat:@"展项%d",self.innerSubType]];
    NSDictionary *computersDic = [exhibitionItemDic objectForKey:@"computers"];
    NSDictionary *projectorsDic = [exhibitionItemDic objectForKey:@"projectors"];
    
    int computerCount = (int)[[computersDic objectForKey:@"count"] integerValue];
    int projectorCount = (int)[[projectorsDic objectForKey:@"count"] integerValue];
    
    if(comType > 0) {
        NSDictionary *computer = [computersDic objectForKey:[NSString stringWithFormat:@"computer%i",comType-20]];
        NSLog(@"%@",[computer objectForKey:@"ip"]);
        BOOL canPoweOn = (BOOL)[[computer objectForKey:@"canpoweron"] boolValue];
        BOOL canPoweOff = (BOOL)[[computer objectForKey:@"canpoweroff"] boolValue];
        BOOL canPlay = (BOOL)[[computer objectForKey:@"canplay"] boolValue];
        BOOL canStop = (BOOL)[[computer objectForKey:@"canstop"] boolValue];
        BOOL canControlVol = (BOOL)[computer objectForKey:@"cancontrolvol"];
        
        for (int i=1; i<=computerCount; i++) {
            
            UIButton *btn =(UIButton*)[self.view viewWithTag:i+20];
            if(i+20==comType){
                [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipad界面单个2-13.png"]] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                if(canPoweOn) {
                    [self.powerOnBtn setHidden:NO];
                } else {
                    [self.powerOnBtn setHidden:YES];
                }
                if(canPoweOff) {
                    [self.powerOffBtn setHidden:NO];
                } else {
                    [self.powerOffBtn setHidden:YES];
                }
                if(canPlay) {
                    [self.playBtn setHidden:NO];
                } else {
                    [self.playBtn setHidden:YES];
                }
                if(canStop) {
                    [self.stopBtn setHidden:NO];
                } else {
                    [self.stopBtn setHidden:YES];
                }
                if(canControlVol) {
                }
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipad界面单个-13.png"]] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    
    for (int i=1; i<=projectorCount; i++) {
        UIButton *btn =(UIButton*)[self.view viewWithTag:i+30];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipad界面单个-06.png"]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    self.TCpaddress = [self getAddress];//@"192.168.199.193";//海洋输电中控IP：192.168.0.6
    
}
-(void)changeProIcon{
    NSDictionary *exhibitionHallDic = [self.dic objectForKey:[NSString stringWithFormat:@"展厅%d",self.type]];
    NSDictionary *exhibitionItemDic =[exhibitionHallDic objectForKey:[NSString stringWithFormat:@"展项%d",self.innerSubType]];
    NSDictionary *computersDic = [exhibitionItemDic objectForKey:@"computers"];
    NSDictionary *projectorsDic = [exhibitionItemDic objectForKey:@"projectors"];
    int computerCount = (int)[[computersDic objectForKey:@"count"] integerValue];
    int projectorCount = (int)[[projectorsDic objectForKey:@"count"] integerValue];
    
    if(proType > 0) {
        
        NSDictionary *projector = [projectorsDic objectForKey:[NSString stringWithFormat:@"projector%i",proType-30]];
        NSLog(@"%@",[projectorsDic objectForKey:@"ip"]);
        
        BOOL canPoweOn = (BOOL)[[projector objectForKey:@"canpoweron"] boolValue];
        BOOL canPoweOff = (BOOL)[[projector objectForKey:@"canpoweroff"] boolValue];
        
        for (int i=1; i<=projectorCount; i++) {
            
            UIButton *btn =(UIButton*)[self.view viewWithTag:i+30];
            if(i+30==proType){
                [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipad界面单个2-26.png"]] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                if(canPoweOn) {
                    [self.powerOnBtn setHidden:NO];
                } else {
                    [self.powerOnBtn setHidden:YES];
                }
                if(canPoweOff) {
                    [self.powerOffBtn setHidden:NO];
                } else {
                    [self.powerOffBtn setHidden:YES];
                }
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipad界面单个-06.png"]] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    
    
    for (int i=1; i<=computerCount; i++) {
        UIButton *btn =(UIButton*)[self.view viewWithTag:i+20];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipad界面单个-13.png"]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    [self.playBtn setHidden:YES];
    [self.stopBtn setHidden:YES];
    self.TCpaddress = [self getAddress];
    
}

-(void)changeSize:(int)j
{
    //    UIButton * btn=(UIButton*)[self.view viewWithTag:j];
    //    CGSize size=btn.frame.size;
    //    size.width*=1.1;
    //    size.height*=1.1;
    //    [btn setFrame:CGRectMake(btn.center.x-size.width/2, btn.center.y-size.height/2, size.width, size.height)];
}

-(IBAction)compu:(UIButton*)sender{
    
    comType = (int)sender.tag;
    proType = 0;
    [self.powerOnBtn setHidden:FALSE];
    [self.powerOffBtn setHidden:FALSE];
    [self.playBtn setHidden:FALSE];
    [self.stopBtn setHidden:FALSE];
    
    //    [self changeSize:comType];
    
    [self changeComIcon];
}
-(IBAction)pro:(UIButton*)sender{
    proType = (int)sender.tag;
    comType = 0;
    [self.powerOnBtn setHidden:FALSE];
    [self.powerOffBtn setHidden:FALSE];
    
    
    [self changeProIcon];
}
-(IBAction)Allswitch:(UIButton*)sender{
    //    allSwitch = (allSwitch+1)%2;
    //    NSString *command = [NSString stringWithFormat:@"/all/power"];
    //    NSLog(@"%@",command);
    //    if (allSwitch==1) {
    //        [self.message sendMessage:command Float:1.0000];
    //        [self.powerBtn setBackgroundImage:[UIImage imageNamed:@"all-on.png" ]forState:UIControlStateNormal];
    //    }
    //    else{
    //        [self.message sendMessage:command Float:0.0000];
    //        [self.powerBtn setBackgroundImage:[UIImage imageNamed:@"all-off.png" ]forState:UIControlStateNormal];
    //    }
    
    int i=(int)[sender tag];
    
    NSString * command=[NSString stringWithFormat:@"/all/power"];
    
    switch (i) {
        case 40:
            command = [command stringByAppendingString:@"on"];
            [self.message sendMessage:command Float:1.0000];
            break;
        case 41:
            command = [command stringByAppendingString:@"off"];
            [self.message sendMessage:command Float:1.0000];
        default:
            break;
    }
    NSLog(@"%@",command);
}
- (void)dealloc {
    [compu1 release];
    [compu2 release];
    [compu3 release];
    [compu4 release];
    [pro1 release];
    [pro2 release];
    [pro3 release];
    [pro4 release];
    [pro5 release];
    [pro6 release];
    [pro7 release];
    [pro8 release];
    [powerBtn release];
    [powerOnBtn release];
    [powerOffBtn release];
    [playBtn release];
    [stopBtn release];
    [super dealloc];
}
@end
