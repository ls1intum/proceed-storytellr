Pod::Spec.new do |s|
  s.name             = 'Prototyper'
  s.version          = '1.0'
  s.summary          = 'Framework to mix prototypes and real apps.'

  s.description      = <<-DESC
The Prototyper framework allows you to create a mix between app prototypes and real apps.
                       DESC

  s.homepage         = 'https://www1.in.tum.de'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chair of Applied Software Engineering' => 'ios@in.tum.de' }
  s.source           = { :git => 'https://github.com/ls1intum/proceed-prototyper.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ls1intum'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Prototyper/Classes/**/*'
  s.resources = 'Prototyper/Assets/*' 

  s.dependency 'KeychainSwift'

end
