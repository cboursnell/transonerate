require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

Rake::TestTask.new do |t|
  t.name = :exonerate
  t.libs << 'test'
  t.test_files = ['test/test_exonerate.rb']
end

Rake::TestTask.new do |t|
  t.name = :tophat
  t.libs << 'test'
  t.test_files = ['test/test_tophat.rb']
end

Rake::TestTask.new do |t|
  t.name = :gtf
  t.libs << 'test'
  t.test_files = ['test/test_gtf.rb']
end

Rake::TestTask.new do |t|
  t.name = :trans
  t.libs << 'test'
  t.test_files = ['test/test_transonerate.rb']
end


desc "Run tests"
task :default => :test
