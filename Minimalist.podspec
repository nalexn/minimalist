Pod::Spec.new do |s|

  s.name = "Minimalist"
  s.version = "1.0.0"
  s.summary = "Dead simple Observable Property and Signal"
  s.homepage = "https://github.com/nalexn/Minimalist"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Alexey Naumov" => "alexey@naumov.tech" }

  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '12.0'
  s.framework = 'XCTest'
  s.swift_versions = '5.1'
  s.source = { :git => "https://github.com/nalexn/minimalist.git", :tag => "#{s.version}" }

  s.source_files  = 'Sources/Minimalist/**/*.swift'

  s.test_spec 'Tests' do |unit|
    unit.source_files = 'Tests/MinimalistTests/**/*.swift'
  end

end
