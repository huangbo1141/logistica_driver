//
//  SelectItemTableViewCell.m
//  Logistika
//
//  Created by BoHuang on 4/26/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "SelectItemTableViewCell.h"
#import "CGlobal.h"
@implementation SelectItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //    [self.cbWeight setDelegate:self];
    //    [self.cbQuantity setDelegate:self];
    
    //    self.cbWeight.entries = c_weight;
    //    self.cbQuantity.entries = c_quantity;
    
    //    self.cbWeight.font = [UIFont systemFontOfSize:15];
    //    self.cbQuantity.font = [UIFont systemFontOfSize:15];
    
    _txtWeight.font = [UIFont systemFontOfSize:15];
    _txtQuantity.font = [UIFont systemFontOfSize:15];
    
    self.pkWeight = [[UIPickerView alloc] init];
    UIToolbar* tb_weight = [[UIToolbar alloc] init];
    tb_weight.barStyle = UIBarStyleDefault;
    tb_weight.translucent = true;
    tb_weight.tintColor = [UIColor darkGrayColor];
    [tb_weight sizeToFit];
    UIBarButtonItem *temp1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done1 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    [tb_weight setItems:@[temp1,done1]];
    tb_weight.userInteractionEnabled = true;
    done1.tag = 200;
    
    _txtWeight.inputView = self.pkWeight;
    _txtWeight.inputAccessoryView = tb_weight;
    
    self.pkQuantity = [[UIPickerView alloc] init];
    UIToolbar* tb_quantity = [[UIToolbar alloc] init];
    tb_quantity.barStyle = UIBarStyleDefault;
    tb_quantity.translucent = true;
    tb_quantity.tintColor = [UIColor darkGrayColor];
    [tb_quantity sizeToFit];
    UIBarButtonItem *temp2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    [tb_quantity setItems:@[temp2,done2]];
    tb_quantity.userInteractionEnabled = true;
    done2.tag = 201;
    
    _txtQuantity.inputView = self.pkQuantity;
    _txtQuantity.inputAccessoryView = tb_quantity;
    
    [self.txtWeight addTarget:self action:@selector(doneEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.txtQuantity addTarget:self action:@selector(doneEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.pkWeight.delegate = self;
    self.pkWeight.dataSource = self;
    
    self.pkQuantity.delegate = self;
    self.pkQuantity.dataSource = self;
    
    [_txtItem addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventValueChanged];
}
-(void)textChanged:(UITextField*)textField{
    if (self.data!=nil) {
        if (textField == self.txtItem) {
            self.data.title = textField.text;
        }else if(textField == self.txtL){
            self.data.dimension1 = self.txtL.text;
        }else if(textField == self.txtB){
            self.data.dimension2 = self.txtB.text;
        }else if(textField == self.txtH){
            self.data.dimension3 = self.txtH.text;
        }
    }
}
-(void)done:(UIView*)sender{
    NSLog(@"done");
    int tag = (int)sender.tag;
    if (tag == 200) {
        // weight
        [self.pkWeight removeFromSuperview];
        [self.txtWeight resignFirstResponder];
        NSInteger row = [self.pkWeight selectedRowInComponent:0];
        _txtWeight.text = c_weight[row];
        
        self.data.weight = c_weight[row];
        self.data.weight_value = [c_weight_value[row] intValue];
        if (self.aDelegate!=nil) {
            [self.aDelegate didSubmit:@{@"action":@"select"} View:self];
        }
    }else{
        //quantity
        [self.pkQuantity removeFromSuperview];
        [self.txtQuantity resignFirstResponder];
        NSInteger row = [self.pkQuantity selectedRowInComponent:0];
        _txtQuantity.text = c_quantity[row];
        
        self.data.quantity = c_quantity[row];
    }
    
}
-(void)doneEdit:(UITextField*)textField{
    if (textField == self.txtWeight) {
        
    }else{
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)initMe:(ItemModel*)model{
    self.backgroundColor = [UIColor whiteColor];
    _txtItem.text = model.title;
    _txtL.text = model.dimension1;
    _txtB.text = model.dimension2;
    _txtH.text = model.dimension3;
    
    self.data = model;
    
    [self.btnRemove addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    self.btnRemove.tag = 100;
}
-(void)clickView:(UIView*)sender{
    int tag = (int)sender.tag;
    switch (tag) {
        case 100:
        {
            if (self.aDelegate!=nil) {
                [self.aDelegate didSubmit:@{@"action":@"remove"} View:self];
            }
            break;
        }
        default:
            break;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == self.pkQuantity) {
        return c_quantity.count;
    }else{
        return c_weight.count;
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == self.pkQuantity) {
        return c_quantity[row];
    }else{
        return c_weight[row];
    }
}
@end
