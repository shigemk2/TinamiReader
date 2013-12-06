class WebViewController < UIViewController
  attr_accessor :item

  def viewDidLoad
    super
    self.navigationItem.title = self.item['title']
    @webview = UIWebView.new.tap do |v|
      scrollwindow = UIScrollView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
      scrollwindow.scrollEnabled = true
      scrollwindow.delegate = self

      v.frame = self.view.bounds
      v.scalesPageToFit = true
      url = self.item['thumbnails']['thumbnail_150x150']['url']
      image_src = NSData.dataWithContentsOfURL(NSURL.URLWithString(url))

      image = UIImage.imageWithData(image_src)
      @image_view = UIImageView.alloc.initWithImage(image)
      @image_view.frame = CGRectMake(0, 0, image.size.width, image.size.height)
      scrollwindow.addSubview(@image_view)
      scrollwindow.contentSize = @image_view.size
      v.delegate = self
      view.addSubview(scrollwindow)

      # pinch
      pinchGesture = UIPinchGestureRecognizer.alloc.initWithTarget(self, action:'handlePinchGesture:')
      view.addGestureRecognizer(pinchGesture)
    end
  end

  # selector
  def handlePinchGesture(sender)
    factor = sender.scale
    @image_view.transform = CGAffineTransformMakeScale(factor, factor)
  end
end
