//
//  AppDelegate.m
//  calculator
//
//  Created by skytoup on 14-2-10.
//  Copyright (c) 2014年 skytoup. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate (private)
+(float)resultForExpression:(NSString*)str{
    NSString* oper;
    float result;
    BOOL isFirst=YES;
    NSArray *array;
    
    if((array=[str componentsSeparatedByString:@"+"]).count!=1){
        oper=@"+";
    }else if((array=[str componentsSeparatedByString:@"-"]).count!=1){
        oper=@"-";
    }else if((array=[str componentsSeparatedByString:@"*"]).count!=1){
        oper=@"*";
    }else if((array=[str componentsSeparatedByString:@"/"]).count!=1){
        oper=@"/";
    }else{
        return [str floatValue];
    }
    
    for(NSString* tmp in array){
        if(isFirst){
            result=[self resultForExpression:tmp];
            isFirst=NO;
            continue;
        }
        
        if([oper isEqualToString:@"+"]){
            result+=[self resultForExpression:tmp];
        }else if([oper isEqualToString:@"-"]){
            result-=[self resultForExpression:tmp];
        }else if([oper isEqualToString:@"*"]){
            result*=[self resultForExpression:tmp];
        }else if([oper isEqualToString:@"/"]){
            result/=[self resultForExpression:tmp];
        }
    }
    return result;
}

+(NSString*)calculatorResultForExpression:(NSString*)str{
    return [[NSNumber numberWithFloat:[self resultForExpression:str]] description];
}
@end

@implementation AppDelegate

typedef NS_ENUM(NSInteger,CalculatorStart){
    CalculatorStartNumber=0,
    CalculatorStartEqual=1,
    CalculatorStartOperator=2,
    CalculatorStartEmpty=3
};
CalculatorStart calculatorStart;
UILabel * result,*expression;
BOOL isHavePoint;
NSPredicate *regex1,*regex2;

- (void)dealloc
{
    [regex1 release];
    [regex2 release];
    [result release];
    [expression release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    calculatorStart=CalculatorStartEmpty;
    isHavePoint=NO;
    regex1=[[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@".+\\.[0-9]+"] retain];
    regex2=[[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[-/+*]"] retain];
    
    NSArray* btsTitle=@[@"7",@"8",@"9",@"/",
                        @"4",@"5",@"6",@"*",
                        @"1",@"2",@"3",@"-",
                        @"0",@".",@"=",@"+"];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = [[[UIViewController alloc] init] autorelease];  // 解决现在的Xcode会报错，以前用5.X的没问题
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
    imageView.image=[UIImage imageNamed:@"bg.png"];
    [self.window addSubview:imageView];
    [imageView release];
    
    imageView=[[UIImageView alloc] initWithFrame:CGRectMake(8, 30, 302, 141)];
    imageView.image=[UIImage imageNamed:@"label.png"];
    [self.window addSubview:imageView];
    [imageView release];
    
    result = [[UILabel alloc] init];
    result.frame=CGRectMake(8, 30, 302, 68);
    result.backgroundColor=[UIColor clearColor];
    result.adjustsFontSizeToFitWidth=YES;
    result.minimumScaleFactor=0.3;
    result.textAlignment=NSTextAlignmentRight;
    result.lineBreakMode=NSLineBreakByTruncatingHead;
    result.font=[UIFont systemFontOfSize:55];
    result.text=@"";
    [self.window addSubview:result];
    expression= [[UILabel alloc] init];
    expression.frame=CGRectMake(8, 103, 302, 68);
    expression.backgroundColor=[UIColor clearColor];
    expression.adjustsFontSizeToFitWidth=YES;
    expression.minimumScaleFactor=0.6;
    expression.textAlignment=NSTextAlignmentRight;
    expression.lineBreakMode=NSLineBreakByTruncatingHead;
    expression.font=[UIFont systemFontOfSize:55];
    expression.text=@"";
    [self.window addSubview:expression];
    
    [self creatButton:8 y:180 width:148 hight:52 title:@"C"];
    [self creatButton:164 y:180 width:148 hight:52 title:@"DEL"];
    
    for(int i=0,y=240;i<4;i++,y+=60){
        for(int j=0,x=8;j<4;j++,x+=78){
            [self creatButton:x y:y width:70 hight:52 title:[btsTitle objectAtIndex:i*4+j]];
        }
    }
    
    
    return YES;
}

-(void)creatButton:(int)x y:(int)y width:(int)width hight:(int)hight title:(NSString*)title{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(x, y, width, hight);
    [bt setTitle:title forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
    [bt setBackgroundImage:[UIImage imageNamed:@"bt.png"] forState:UIControlStateNormal];
    [self.window addSubview:bt];
}

-(void)numClick :(UIButton*)bt{
    NSString *title=[bt titleForState:UIControlStateNormal];
    if([title isEqualToString:@"DEL"]){
        NSString *tmp=expression.text;
        if(tmp.length!=0){
            NSString *text=[tmp substringToIndex:tmp.length-1];
            expression.text=text;
            tmp=[tmp substringFromIndex:tmp.length-1];
            if(text.length==0){
                calculatorStart=CalculatorStartEmpty;
            }else if([tmp isEqualToString:@"."]){
                isHavePoint=NO;
                calculatorStart=CalculatorStartNumber;
            }else if([regex2 evaluateWithObject:tmp]){
                if([regex1 evaluateWithObject:text]){
                    isHavePoint=YES;
                }else{
                    isHavePoint=NO;
                }
                calculatorStart=CalculatorStartNumber;
            }else if([regex2 evaluateWithObject:[text substringFromIndex:text.length-1]]){
                calculatorStart=CalculatorStartOperator;
            }
        }
    }else if([title isEqualToString:@"C"]){
        expression.text=@"";
        isHavePoint=NO;
        calculatorStart=CalculatorStartEmpty;
    }else if([title isEqualToString:@"="]){
        if(calculatorStart==CalculatorStartNumber){
            isHavePoint=NO;
            calculatorStart=CalculatorStartEqual;
            NSString *calResult=[AppDelegate calculatorResultForExpression:expression.text];
            result.text=[NSString stringWithFormat:@"%@=%@",expression.text,calResult];
            expression.text=calResult;
        }
    }else{
        if([title isEqualToString:@"."]){
            if(isHavePoint||calculatorStart!=CalculatorStartNumber){
                return;
            }
            isHavePoint=YES;
            calculatorStart=CalculatorStartOperator;
        }else if ([regex2 evaluateWithObject:title]){
            if(calculatorStart!=CalculatorStartNumber&&calculatorStart!=CalculatorStartEqual){
                return;
            }
            isHavePoint=NO;
            calculatorStart=CalculatorStartOperator;
        }else{
            if(calculatorStart==CalculatorStartEqual){
                expression.text=@"";
            }
            calculatorStart=CalculatorStartNumber;
        }
        expression.text=[NSString stringWithFormat:@"%@%@",expression.text,title];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
