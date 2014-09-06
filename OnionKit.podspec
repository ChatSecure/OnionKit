Pod::Spec.new do |s|
  s.name            = "OnionKit"
  s.version         = "1.0.0"
  s.summary         = "OnionKit is an Objective-C wrapper around Tor."
  s.author          = "Chris Ballinger <chris@chatsecure.org>"

  s.homepage        = "https://chatsecure.org"
  s.license         = 'LGPLv2.1+ & MPL 2.0'
  s.source          = { :git => "https://github.com/ChatSecure/OnionKit.git", :branch => "master"}
  s.prepare_command = <<-CMD
    bash build-all.sh
  CMD

  s.platform     = :ios, "6.0"
  s.source_files = "OnionKit/*.{h,m}", "dependencies/include/**/*.h"
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/Headers/OnionKit"'}
  s.preserve_paths = "dependencies/include/**/*.h"
  s.header_mappings_dir = "dependencies/include"
  s.vendored_libraries  = "dependencies/lib/*.a"
  s.library     = 'crypto', 'curve25519_donna', 'event_core', 'event_extra', 'event_openssl',
                  'event_pthreads', 'event', 'or-crypto', 'or-event', 'or', 'ssl', 'tor', 'z'
  s.requires_arc = true
end