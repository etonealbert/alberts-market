//
//  ThemeButton.m

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton
#define OBJ_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#pragma mark -
#pragma mark - initialization Methods

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self _init];
    }
    return self;
}

- (void)_init {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeNotification:) name:ThemeManagerDidChangeThemes object:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self applyTheme];
}

- (void)dealloc {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    @catch (NSException *exception) {
        // do nothing, only unregistering self from notifications
    }
}


#pragma mark -
#pragma mark - Apply Theme to Controll

- (void)applyTheme {

    //set Font
    UIFont *font = nil;
    if(_type == 0 || _type == 1 || _type == 2 || _type == 9 ||  _type == 13) {
        font = [[ThemeManager sharedManager] fontForKey:@"font0" withSizeKey:@"fSize3"];
    }
    
    else if ( _type == 7 || _type == 8 || _type == 11 || _type == 12 || _type == 17) {
        font = [[ThemeManager sharedManager] fontForKey:@"font1" withSizeKey:@"fSize2"];
    }
    self.titleLabel.font = font;
   
    //set text color
    UIColor *textColor = nil;
    if (_type == 0 || _type == 9 || _type == 17) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"color5"];
    }
    else if (_type == 1 || _type == 2 || _type == 11 || _type == 12) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"Primary_Default_Color"];
    }
    else if (_type == 7) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"color7"];
    }
    else if (_type == 8) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"color8"];
    }
    else if (_type == 13) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"Secondary_Color1"];
    }
    else {
        textColor = [[ThemeManager sharedManager] colorForKey:@"Secondary_Color1"];
    }
    [self setTitleColor:textColor forState:UIControlStateNormal];
    
    //set background color
    UIColor *backgroundColor, *primaryTintColor = nil;
    if (_type == 0) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"Primary_Default_Color"];
        if (OBJ_IPAD) {
            self.layer.cornerRadius = 30.0;
        }else {
            self.layer.cornerRadius = 25.0;
        }
        self.layer.shadowColor = [[[ThemeManager sharedManager] colorForKey:@"Primary_Default_Color"] CGColor];
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 3.0;
        self.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    }
    else if ( _type == 1) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"color5"];
        if (OBJ_IPAD) {
            self.layer.cornerRadius = 30.0;
        }else {
            self.layer.cornerRadius = 25.0;
        }
        self.layer.borderColor = [[[ThemeManager sharedManager] colorForKey:@"Primary_Default_Color"]CGColor];
        self.layer.borderWidth = 1;
    }
    else if(_type == 3) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"color6"];
    }
    else if (_type == 4) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"color7"];
    }
    else if (_type == 5) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"color8"];
    }
    else if (_type == 9 || _type == 17) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"Primary_Default_Color"];
    }
    else if (_type == 12) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"color5"];
        if (OBJ_IPAD) {
            self.layer.cornerRadius = 25.0;
        }else {
            self.layer.cornerRadius = 20.0;
        }
        self.layer.borderColor = [[[ThemeManager sharedManager] colorForKey:@"Primary_Default_Color"]CGColor];
        self.layer.borderWidth = 1;
    }
    else if ( _type == 13) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"color5"];
        if (OBJ_IPAD) {
            self.layer.cornerRadius = 30.0;
        }else {
            self.layer.cornerRadius = 25.0;
        }
        self.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
        self.layer.borderWidth = 1;
    }
    
    self.backgroundColor = backgroundColor;
    
    if (_type == 3 || _type == 4 || _type == 5) {
        primaryTintColor = [[ThemeManager sharedManager] colorForKey:@"color5"];
        if (OBJ_IPAD) {
            self.layer.cornerRadius = 25.0;
        }else {
            self.layer.cornerRadius = 20.0;
        }
        [self setImage:[self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:self.state];
        [self setTintColor:primaryTintColor];
    }
    else if (_type == 6) {
        primaryTintColor = [[ThemeManager sharedManager] colorForKey:@"Secondary_Color2"];
        
        UIImage *img = self.imageView.image;
        NSString *curruntLan = [[NSUserDefaults standardUserDefaults] stringForKey:@"language"];
        
        if ([curruntLan isEqualToString:@"ar"]) {
            img = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationUpMirrored];
        }
        
        [self setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:self.state];
        [self setTintColor:primaryTintColor];
    }
    else if (_type == 7) {
        primaryTintColor = [[ThemeManager sharedManager] colorForKey:@"color9"];
        [self setImage:[self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:self.state];
        [self setTintColor:primaryTintColor];
    }
    else if (_type == 10) {
        primaryTintColor = [[ThemeManager sharedManager] colorForKey:@"Primary_Default_Color"];
        [self setImage:[self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:self.state];
        [self setTintColor:primaryTintColor];
    }
    
    else if (_type == 1) {
        primaryTintColor = [[ThemeManager sharedManager] colorForKey:@"color4"];
        [self setImage:[self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:self.state];
        [self setTintColor:primaryTintColor];
    }
    else if (_type == 15) {
        primaryTintColor = [[ThemeManager sharedManager] colorForKey:@"Secondary_Color1"];
        UIImage *img = self.imageView.image;
        NSString *curruntLan = [[NSUserDefaults standardUserDefaults] stringForKey:@"language"];
        
        if ([curruntLan isEqualToString:@"ar"]) {
            img = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationUpMirrored];
        }
        
        [self setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:self.state];
        [self setTintColor:primaryTintColor];
    }
    else if (_type == 16) {
        primaryTintColor = [[ThemeManager sharedManager] colorForKey:@"color16"];
        [self setImage:[self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:self.state];
        [self setTintColor:primaryTintColor];
    }
}

+ (UIButton *)setButtonTintColor:(UIButton *)button imageName:(NSString *)imageName state:(UIControlState)state tintColor:(UIColor *)color {
    [button setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:state];
    [button setTintColor:color];
    return button;
}


#pragma mark -
#pragma mark - set observer for change theme

- (void)themeDidChangeNotification:(NSNotification *)notification {
    [self applyTheme];
}

@end
