MRuby::Build.new do |conf|
    toolchain :gcc
    conf.gembox 'default'
end

MRuby::CrossBuild.new('wasm32-unknown-gnu') do |conf|
    toolchain :clang

    conf.gembox 'default'
    # onig-regexp を mruby 2.x 互換コミットで先に宣言して上書き
    conf.gem :github => 'mattn/mruby-onig-regexp',
             :checksum_hash => '08decdc7c0fbbf873568a44b1a83b9a72d640d8a'
    conf.gem :github => 'pulsejet/mruby-marshal'
    conf.gem :github => 'monochromegane/mruby-time-strftime'
    conf.gem :core => 'mruby-eval'

    conf.cc.command = 'emcc'
    conf.cc.flags = %W(-O3 -g0)
    conf.cxx.command = 'em++'
    conf.cxx.flags = %W(-O3 -g0 -std=c++14)
    conf.linker.command = 'emcc'
    conf.archiver.command = 'emar'
end
