Pod::Spec.new do |s|
  s.name         = "ITProgressBar-iOS"
  s.version      = "0.0.1"
  s.summary      = "ITProgressBar is a very lightweight progress bar replacement for iOS."
  s.description  = <<-DESC
                   `ITProgressBar` is a very lightweight progress bar replacement for iOS.
                   DESC
  s.homepage     = "https://github.com/iluuu1994/ITProgressBar-iOS"
  s.license      = { :type => "MIT", :file => "README.md" }
  s.author       = { "Ilija Tovilo" => "support@ilijatovilo.ch" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/iluuu1994/ITProgressBar-iOS", :tag => '0.0.1' }
  s.source_files = "ITProgressBar-iOS/Classes/*{h,m}"
  s.frameworks   = "QuartzCore"
  s.requires_arc = true
end
