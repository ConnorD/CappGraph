
@import <AppKit/CPWebView.j>


@implementation Graph : CPWebView
{
    DOMWindow domWin;
    @outlet id delegate @accessors(property=delegate);
    @accessors CPArray plots;
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

- (void) setDelegate:(id) theDelegate {
    delegate = theDelegate;
}

- (void)webView:(CPWebView)aWebView didFinishLoadForFrame:(id)aFrame {
    domWin = [self DOMWindow];

    if (delegate && [delegate respondsToSelector:@selector(graphViewDidFinishLoading:)]) {
        [delegate graphViewDidFinishLoading:self];
    }
}

- (void) addPlot:(CPDictionary) options {
    plots.push(options);
}

- (void) removePlotWithLabel:(CPString) label {
    for (var i; i < plots.length; i++) {
        if (plot[i].label == label) {
            plots.splice(i, 1);
        }
    }
}

- (void) removePlotWithIndex:(int)index {
    plots.splice(index, 1);
}

// call this when you're ready to plot or re-plot everything
- (void) refreshGraph {
    //domWin.jQuery.plot(domWin.jQuery('#graph'), plots);
    domWin.jQuery.plot.setData(plots);
    domWin.jQuery.setupGrid();
    domWin.jQuery.plot.draw();
}

@end
