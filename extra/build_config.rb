MRuby::CrossBuild.new('wasm32-unknown-gnu') do |conf|
    toolchain :clang

    conf.gembox 'default'
    # ローカルの固定コミットを参照（build_config.rb は deps/mruby/ にコピーされるため ../mruby-onig-regexp）
    conf.gem :path => '../mruby-onig-regexp'
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
