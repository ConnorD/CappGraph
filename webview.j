
@import <AppKit/CPWebView.j>


@implementation Graph : CPWebView
{
    DOMWindow domWin;
    @outlet id delegate @accessors(property=delegate);
    CPArray plots;
}

- (id)initWithFrame:(CGRect)aFrame
{
    plots = [];

    if (self = [super initWithFrame:aFrame]) {
        [self setFrameLoadDelegate:self];
        [self setMainFrameURL:[[CPBundle mainBundle] pathForResource:@"graph.html"]];
    }

    return self;
}

- (void)webView:(CPWebView)aWebView didFinishLoadForFrame:(id)aFrame {
    domWin = [self DOMWindow];

    if (delegate && [delegate respondsToSelector:@selector(graphViewDidFinishLoading:)]) {
        [delegate graphViewDidFinishLoading:self];
    }
}

- (void) addPlot:(CPString) label data:(CPArray) data {
    plots.push({ label: label, data: data});
}

// call this when you're ready to plot or re-plot everything
- (void) refreshGraph {
    domWin.jQuery.plot(domWin.jQuery('#graph'), plots);
}

@end
