
#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,assign) CGFloat lasContentOffset;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.scrollView.delegate = self;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.lasContentOffset = scrollView.contentOffset.y;
    if (self.lasContentOffset < self.webView.scrollView.contentOffset.y )
        self.urlTextField.alpha = 0.0;
    else
        self.urlTextField.alpha = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}
- (IBAction)onPlusButtonPressed:(id)sender {
    UIAlertView *alertView =[[UIAlertView alloc] init];
    alertView.title = @"Coming soon!";
    alertView.message=@"It's comming...!";
    [alertView addButtonWithTitle:@"OK"];
    [alertView show];
}

- (NSString *)verifyURLPrefix {
    NSString *urlOriginal = self.urlTextField.text;
    NSString *urlFinal =@"";
    if (![urlOriginal hasPrefix:@"http://"])
        urlFinal = [NSString stringWithFormat:@"%@%@", @"http://",urlOriginal];
    return urlFinal;
}

- (void)loadPage {
    NSString *urlFinal;
    urlFinal = [self verifyURLPrefix];
    NSURL *url = [NSURL URLWithString: urlFinal];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self loadPage];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.webView stopLoading];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    self.urlTextField.text = self.webView.request.URL.absoluteString;
    
    //Methods to verify if it's possible to go back or forward
    [self updateBackButton];
    [self updateForwardButton];
    self.titleLabel.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)updateBackButton {
    if (self.webView.canGoBack)
        self.backButton.enabled= YES;
    else
        self.backButton.enabled=NO;
}

- (void)updateForwardButton {
    if (self.webView.canGoForward)
        self.forwardButton.enabled= YES;
    else
        self.forwardButton.enabled=NO;
}

- (IBAction)onBackButtonPressed:(id)sender {
    [self.webView goBack];
}

- (IBAction)onForwardButtonPressed:(id)sender {
    [self.webView goForward];
}

@end