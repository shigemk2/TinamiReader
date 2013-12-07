# -*- coding: utf-8 -*-

class TinamiViewController < UITableViewController
  def viewDidLoad
    super

    @feed = nil
    @items = []
    self.view.backgroundColor = UIColor.whiteColor

    @refreshControl = UIRefreshControl.alloc.init
    # 更新アクションを設定
    @refreshControl.addTarget(self,
                             action:"onRefresh",
                             forControlEvents:UIControlEventValueChanged)
    self.refreshControl = @refreshControl

    @searchBar = UISearchBar.alloc.initWithFrame(CGRectMake(0, 0, 0, 0))
    @searchBar.delegate = self
    @searchBar.showsCancelButton = true
    @searchBar.sizeToFit
    self.view.dataSource = view.delegate = self
    self.navigationItem.titleView = @searchBar
    # @searchBar.text = 'マナりつ'
    @searchBar.text = ''

    self.getItems(@feed, @searchBar)
    self.buildRefreshBtn
    searchBarCancelButtonClicked(@searchBar)
  end

  def getItems(feed, searchBar)
    query = searchBar.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    url = "http://133.242.188.88:3000/server?p1=#{query}"
    @items.clear

    BW::HTTP.get(url) do |response|
      if response.ok?
        @feed = BW::JSON.parse(response.body.to_str)
        for row in @feed['rsp']['contents']['content']
          if row.nil?
            break
          end
          @items << row
        end
        view.reloadData
      else
        App.alert(response.error_message)
      end
    end

    return @items
  end

  def tableView(tableView, numberOfRowsInSection:section)
    if @items.nil?
      return 0
    else
      # @items.size
      15
    end
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    40
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('cell') || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'cell')
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator

    if @items == []
      return cell
    end

    # title
    cell.textLabel.frame = CGRectMake(200, 200, 20, 30)
    cell.textLabel.text = @items[indexPath.row]['title']
    cell.textLabel.font = UIFont.boldSystemFontOfSize(14)
    cell.textLabel.textAlignment = UITextAlignmentRight

    # thumbnail
    image_path = @items[indexPath.row]['thumbnails']['thumbnail_150x150']['url']
    image_src = NSData.dataWithContentsOfURL(NSURL.URLWithString(image_path))
    image = UIImage.imageWithData(image_src)

    image_view = UIImageView.alloc.initWithImage(image)
    image_view.frame = CGRectMake(5, 5, 30, 30)
    cell.addSubview(image_view)
    return cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    WebViewController.new.tap do |c|
      c.item = @items[indexPath.row]
      self.navigationController.pushViewController(c, animated:true)
    end
  end

  # 更新ボタンを生成
  def buildRefreshBtn
    btn = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh,
                                                            target:self,
                                                            action:"eventRefreshBtn:")
    btn.tintColor = UIColor.redColor
    self.setToolbarItems(arrayWithObjects:"btn", animated:true)
    self.navigationItem.leftBarButtonItem = btn
  end

  # 処理中のイベント
  def eventActivityIndicator
    self.getItems(@feed, @searchBar)

    # 処理中を、更新ボタンに切り替える
    self.buildRefreshBtn
  end

  # 更新ボタンのイベント
  def eventRefreshBtn(sender)
    # 更新ボタンを、処理中に切り替える
    self.buildActivityIndicator
  end

  # 処理中を生成
  def buildActivityIndicator
    activityIndicator = UIActivityIndicatorView.alloc.initWithFrame(CGRectMake(0, 0, 30, 20))
    activityIndicator.startAnimating

    btn = UIBarButtonItem.alloc.initWithCustomView(activityIndicator)
    self.setToolbarItems(arrayWithObjects:"btn", animated:true)
    self.navigationItem.leftBarButtonItem = btn
    self.performSelector("eventActivityIndicator", withObject:nil, afterDelay:0.1)
  end

  def searchBarSearchButtonClicked(searchBar)
    @searchBar.resignFirstResponder
    self.getItems(@feed, @searchBar)
  end

  def searchBarCancelButtonClicked(searchBar)
    searchBar.resignFirstResponder
  end

  def onRefresh
    # 更新開始
    self.refreshControl.beginRefreshing

    view.reloadData
    @searchBar.resignFirstResponder

    self.getItems(@feed, @searchBar)

    # 更新終了
    self.refreshControl.endRefreshing
  end
end
