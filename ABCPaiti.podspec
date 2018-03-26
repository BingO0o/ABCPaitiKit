Pod::Spec.new do |s|
  s.name             = "ABCPiti"
  s.version          = "0.0.1"
  s.summary          = "ABCPiti."
  s.description      = "ABCPiti of bing"
  s.homepage         = "http://www.abcpen.com"
  s.license          = 'MIT'
  s.author           = { "bing" => "bing@abcpen.com" }
  s.source           = { :git => 'https://github.com/BingO0o/ABCPaitiKit.git' }
  s.platform         = :ios, '9.0'
  s.requires_arc     = true

  s.subspec 'ABCPitiKit' do |sp|
    sp.public_header_files = 'ABCPitiSDK/ABCPaitiKit.framework/Headers/ABCPaitiKit.h'
    sp.source_files        = 'ABCPitiSDK/ABCPaitiKit.framework/Headers/*.{h}'
    sp.vendored_frameworks = 'ABCPitiSDK/ABCPaitiKit.framework'
    # sp.dependency 'AFNetworking', '~> 2.4.1'
    # sp.dependency 'SDWebImage', '~> 3.7.3'
    # sp.dependency 'Reachability', '~> 3.2'
    # sp.dependency 'Cordova', '~> 3.8.0'
    # sp.dependency 'MagicalRecord', :git => 'https://github.com/magicalpanda/MagicalRecord.git', :commit => '11e1dcdeb78261ae6b02304707d5220dc0cf95e8'

    sp.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
  end

end
