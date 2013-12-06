# -*- coding: utf-8 -*-
class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # url =  NSURL.alloc.initWithString(url)
    # feed_parser = BW::RSSParser.new(url)
    # p feed_parser
    # parser = Hpple.XML(open(url))

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds).tap do |window|
      window.rootViewController = UINavigationController.alloc.initWithRootViewController(TinamiViewController.new)
      window.makeKeyAndVisible
    end
    true
  end
end
