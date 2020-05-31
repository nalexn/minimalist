Pod::Spec.new do |s|

  s.name = "Minimalist"
  s.version = "1.0.0"
  s.summary = "Minimalist is a library for unit testing SwiftUI views.
               It allows for traversing a view hierarchy at runtime providing direct access to the underlying View structs."
  s.homepage = "https://github.com/nalexn/Minimalist"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Alexey Naumov" => "alexey@naumov.tech" }

  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '12.0'
  s.watchos.deployment_target = '5.0'
  s.framework = 'XCTest'
  s.source = { :git => "https://github.com/nalexn/minimalist.git", :tag => "#{s.version}" }

  s.source_files  = 'Sources/Minimalist/**/*.swift'

  s.test_spec 'Tests' do |unit|
    unit.source_files = 'Tests/MinimalistTests/**/*.swift'
  end

end
