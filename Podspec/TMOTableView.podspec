
Pod::Spec.new do |s|

  s.name         = "TMOTableView"
  s.version      = "1.1.0"
  s.summary      = "TMOTableView includes RefreshControl LoadMoreControl FirstLoadControl, and you can customize it."

  s.description  = <<-DESC
                   TMOTableView includes RefreshControl LoadMoreControl FirstLoadControl, and you can customize it. 
                   It support iOS5+, support UIViewController & UITableViewController.
                   TMOTableView是一个包含下拉刷新、上拉加载、首次加载三个常用功能的UITableView子类，支持iOS5+
                   DESC

  s.homepage     = "https://github.com/duowan/TMOTableView"

  s.license      = "MIT"

  s.author       = { "PonyCui" => "cuis@vip.qq.com" }

  s.platform     = :ios, "5.0"

  s.source       = { :git => "https://github.com/duowan/TMOTableView.git", :tag => "1.1.0" }

  s.source_files  = "Src", "Src/*.{h,m}"
  
  s.requires_arc = true

end
