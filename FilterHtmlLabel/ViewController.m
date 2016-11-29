//
//  ViewController.m
//  FilterHtmlLabel
//
//  Created by James on 16/11/29.
//  Copyright © 2016年 James. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"
@interface ViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    UIWebView *theWebView;
}
@property(nonatomic,strong)NSArray *webImgArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initWebView];
    [self loadUrl];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initWebView
{
    CGRect webViewRect = self.view.bounds;
    theWebView = [[UIWebView alloc] initWithFrame:webViewRect];
    theWebView.delegate = self;
    theWebView.scalesPageToFit = NO;
    theWebView.scrollView.scrollsToTop = YES;
    theWebView.scrollView.alwaysBounceHorizontal = NO;
    theWebView.scrollView.alwaysBounceVertical = NO;
    theWebView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:theWebView];
    
    
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewTap:)];
    aTap.delegate = self;
    [theWebView addGestureRecognizer:aTap];
}

-(void)loadUrl
{
    NSString *weburl = @"http://c.m.163.com/news/a/C71IAAB2000181TJ.html?spss=newsapp&spsw=1";
    //NSString *weburl = @"https://www.126.com/";
    [theWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weburl]]];
}
//在页面中查找img标签
-(NSArray*)filterImgInHtmlString:(NSString*)htmlContent
{
    TFHpple *doc = [[TFHpple alloc] initWithHTMLString:htmlContent];
    NSArray *images = [doc searchWithXPathQuery:@"//img"];
    NSString *imgUrl = nil;
    NSMutableArray *imgUrlArray = [NSMutableArray array];
    for (int i = 0; i < [images count]; i++)
    {
        imgUrl = [[images objectAtIndex:i] objectForKey:@"src"];
        [imgUrlArray addObject:imgUrl];
    }
    return imgUrlArray;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognize
{
    [self webViewTap:gestureRecognize];
    return YES;
}
-(void)webViewTap:(UIGestureRecognizer*)sender
{
    //  <Find HTML tag which was clicked by user>
    //  <If tag is IMG, then get image URL and start show>
    CGPoint pt = [sender locationInView:theWebView];
    NSLog(@"handleSingleTap!pointx:%f,y:%f",pt.x,pt.y);
    
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", pt.x, pt.y];
    NSString * tagName = [theWebView stringByEvaluatingJavaScriptFromString:js];
    if ([tagName length] > 0 && [[tagName lowercaseString] isEqualToString:@"img"])
    {
        NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
        NSString *urlYouTap = [theWebView stringByEvaluatingJavaScriptFromString:imgURL];
        NSLog(@"你点击的图片地址是:%@",urlYouTap);
    }
   
}

// =====================================================================================================================
#pragma mark - delegate
// =====================================================================================================================
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *allJs = @"document.documentElement.innerHTML";
    NSString *allHtmlContent = [webView stringByEvaluatingJavaScriptFromString:allJs];
    NSLog(@"%@",allHtmlContent);
    
    self.webImgArray = [self filterImgInHtmlString:allHtmlContent];
    
    NSLog(@"\n\nimgArray:\n\n %@",self.webImgArray);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}




@end



/*
获取html:
thisURL = document.URL;

thisHREF = document.location.href;

thisSLoc = self.location.href;

thisDLoc = document.location;

thisTLoc = top.location.href;

thisPLoc = parent.document.location;

thisTHost = top.location.hostname;

thisHost = location.hostname;

thisTitle = document.title;

thisProtocol = document.location.protocol;

thisPort = document.location.port;

thisHash = document.location.hash;

thisSearch = document.location.search;

thisPathname = document.location.pathname;

thisHtml = document.documentElement.innerHTML;
*/
