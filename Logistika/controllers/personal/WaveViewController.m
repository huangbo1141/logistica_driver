//
//  WaveViewController.m
//  Logistika
//
//  Created by BoHuang on 8/1/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "WaveViewController.h"
#import "CGlobal.h"
#import "NetworkParser.h"
#import "WaveModel.h"
#import "WaveOrderModel.h"
#import "WaveOrderCorModel.h"

@interface WaveViewController ()
@property (nonatomic,strong) LoginResponse*loginResponse;
@property (nonatomic,strong) NSMutableArray* waveOrders;
@property (nonatomic,strong) LoginResponse* truckResponse;

@end

@implementation WaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBase];
    [self get_truck];
    
    CGRect scRect = [UIScreen mainScreen].bounds;
    self.const_SegWidth.constant = scRect.size.width;
}
-(void)initBase{
    self.segControl.tintColor = COLOR_PRIMARY;
    self.segControl.hidden = true;
    self.btnSegment.hidden = true;
    
    UINib* nib = [UINib nibWithNibName:@"WaveTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = false;
    self.title = @"Waves";
    [self getWaves];
}
-(void)getWaves{
    self.pageIndex = 0;
    
    EnvVar * env = [CGlobal sharedId].env;
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    data[@"type"] = @"1";
    if (g_mode == c_PERSONAL) {
        data[@"order_type"] = @"0";
        data[@"employer_id"] = env.user_id;
    }else{
        data[@"order_type"] = @"1";
        data[@"employer_id"] = env.corporate_user_id;
    }
    
    
    [CGlobal showIndicator:self];
    NetworkParser* manager = [NetworkParser sharedManager];
    [manager ontemplateGeneralRequest2:data BasePath:g_URL Path:@"get_wave" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                if ([dict[@"result"] intValue] == 200) {
                    LoginResponse* data = [[LoginResponse alloc] initWithDictionary:dict];
                    if (data.wave.count > 0) {
                        g_waveData = data;
                    }
                    [self initView];
                    if (g_mode == c_PERSONAL) {
                        [self getWavePersonalOrders];
                    }else{
                        [self getWaveCorporateOrders];
                    }
                }else{
                    [CGlobal AlertMessage:@"Fail" Title:nil];
                }
            }
        }else{
            NSLog(@"Error");
        }
        [CGlobal stopIndicator:self];
    } method:@"POST"];
}
-(void)initView{
    [self.segControl setTitle:@"" forSegmentAtIndex:0];
    [self.segControl setTitle:@"" forSegmentAtIndex:1];
    
    if (g_waveData.wave.count == 1) {
        self.segControl.hidden = true;
        self.btnSegment.hidden = false;
        
        WaveModel* model = g_waveData.wave[0];
        [self.btnSegment setTitle:model.name forState:UIControlStateNormal];
        return;
    }else{
        self.segControl.hidden = false;
        self.btnSegment.hidden = true;
        
    }
    
    if (g_waveData.wave.count>=1) {
        WaveModel* model = g_waveData.wave[0];
        [self.segControl setTitle:model.name forSegmentAtIndex:0];
    }
    
    if (g_waveData.wave.count>=2) {
        WaveModel* model = g_waveData.wave[1];
        [self.segControl setTitle:model.name forSegmentAtIndex:1];
    }
    
    if (g_waveData.wave.count>=3) {
        for (int k=2; k<g_waveData.wave.count; k++) {
            WaveModel* model = g_waveData.wave[k];
            NSUInteger index = self.segControl.numberOfSegments;
            [self.segControl insertSegmentWithTitle:model.name atIndex:index animated:false];
        }
    }
    
    [self.segControl addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventValueChanged];
    
    self.segControl.hidden = false;
    
}
-(void)changeSeg:(UISegmentedControl*)segControl{
    NSUInteger segIndex = segControl.selectedSegmentIndex;
    
}
-(void)getWavePersonalOrders{
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    EnvVar* env = [CGlobal sharedId].env;
    data[@"id"] = @"0";
    data[@"employer_id"] = env.user_id;
    data[@"order_type"] = @"0";
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [manager ontemplateGeneralRequest2:data BasePath:g_URL Path:@"get_personal_wave_byid" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                if ([dict[@"result"] intValue] == 200) {
                    LoginResponse* data = [[LoginResponse alloc] initWithDictionaryForWaveOrderModel:dict];
                    if (data.wave.count > 0) {
                        self.loginResponse = data;
                        WaveOrderModel*model =  data.wave[0];
                        [self filterPersonWaves:model.wave_id];
                        [self.tableView reloadData];
                    }
                }else if ([dict[@"result"] intValue] == 400) {
                    self.waveOrders = [[NSMutableArray alloc] init];
                    [self.tableView reloadData];
                    [CGlobal AlertMessage:@"No Orders" Title:nil];
                }
                else{
                    [CGlobal AlertMessage:@"Fail" Title:nil];
                }
            }
        }else{
            NSLog(@"Error");
        }
        
    } method:@"POST"];
}
-(void)getWaveCorporateOrders{
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    EnvVar* env = [CGlobal sharedId].env;
    data[@"id"] = @"0";
    data[@"employer_id"] = env.corporate_user_id;
    data[@"order_type"] = @"1";
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [manager ontemplateGeneralRequest2:data BasePath:g_URL Path:@"get_corporate_wave_byid" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                if ([dict[@"result"] intValue] == 200) {
                    LoginResponse* data = [[LoginResponse alloc] initWithDictionaryForCorWaveOrderModel:dict];
                    if (data.wave.count > 0) {
                        self.loginResponse = data;
                        WaveOrderCorModel*model =  data.wave[0];
                        [self filterCorporateWaves:model.wave_id];
                        [self.tableView reloadData];
                    }
                }else if ([dict[@"result"] intValue] == 400) {
                    self.waveOrders = [[NSMutableArray alloc] init];
                    [self.tableView reloadData];
                    [CGlobal AlertMessage:@"No Orders" Title:nil];
                }
                else{
                    [CGlobal AlertMessage:@"Fail" Title:nil];
                }
            }
        }else{
            NSLog(@"Error");
        }
        
    } method:@"POST"];
}
-(void)filterPersonWaves:(NSString*)wave_id{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (int k=0; k< self.loginResponse.wave.count; k++) {
        WaveOrderModel*item = self.loginResponse.wave[k];
        if ([item.wave_id isEqualToString:wave_id]) {
            [array addObject:item];
        }
    }
    
    [CGlobal sortWaveList:array];
    
    self.waveOrders = array;
}
-(void)filterCorporateWaves:(NSString*)wave_id{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (int k=0; k< self.loginResponse.wave.count; k++) {
        WaveOrderCorModel*item = self.loginResponse.wave[k];
        if ([item.wave_id isEqualToString:wave_id]) {
            [array addObject:item];
        }
    }
    [CGlobal sortWaveList:array];
    self.waveOrders = array;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.waveOrders.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WaveTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell setData:@{@"indexPath":indexPath,@"model":self.waveOrders[indexPath.row],@"aDelegate":self,@"vc":self}];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103;
}
-(void)get_truck{
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [manager ontemplateGeneralRequest2:data BasePath:BASE_DATA_URL Path:@"get_truck" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                if ([dict[@"result"] intValue] == 200) {
                    LoginResponse* data = [[LoginResponse alloc] initWithDictionary:dict];
                    
                    g_truckModels = data;
                    
                }else{
                    //                    [CGlobal AlertMessage:@"Fail" Title:nil];
                }
            }
        }else{
            NSLog(@"Error");
        }
        
    } method:@"POST"];
}
@end
