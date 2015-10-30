Pod::Spec.new do |s|
  s.name     = 'TRCropViewController'
  s.version  = '1.0.9'
  s.license  =  { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'A view controller that allows users to crop UIImage objects.'
  s.homepage = 'https://github.com/TimOliver/TOCropViewController'
  s.author   = 'Tim Oliver'
  s.source   = { :git => 'https://github.com/TimOliver/TOCropViewController.git', :tag => '1.0.9' }
  s.platform = :ios, '7.0'

  s.source_files = ['TOCropViewController/**/*.{h,m}']
  s.resource_bundles = {
    'TOCropViewControllerBundle' => ['TOCropViewController/**/*.lproj']
  }
  s.resources = ['Images/*.png']
  s.requires_arc = true
  s.dependency "Masonry", "~> 0.6.2"
end
