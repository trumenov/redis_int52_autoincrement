Gem::Specification.new do |s|
  s.name = 'redis_int52_autoincrement'
  s.version = '1.0.1'
  s.summary = "Int64 (UInt52) autoincrement via redis-servers"
  s.description = <<-EOF
Int64 (UInt52) autoincrement via redis-servers with timestamp in microseconds, autoincerent via redis key.
Support 1-5 redis servers in one system (1 - timestamp + 4 servers - autoincrementers).
EOF

  s.authors << 'Trumenov' << 'Chaky'
  s.email = 'chaky22222222@gmail.com'
  s.homepage = 'http://github.com/trumenov/redis_int52_autoincrement'
  s.license = 'MIT'

  s.files = Dir['{bin,test,lib,docs}/**/*'] + ['README.rdoc', 'MIT-LICENSE', 'Rakefile', 'CHANGELOG', 'redis_int52_autoincrement.gemspec']

  s.rdoc_options << '--main' << 'README.rdoc' << '--title' <<  'Int64 UInt52 redis autoincrementer' << '--line-numbers'
                       '--webcvs' << 'http://github.com/trumenov/redis_int52_autoincrement'
  s.extra_rdoc_files = ['README.rdoc', 'MIT-LICENSE']
end
