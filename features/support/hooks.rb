Before do
  FileUtils.rm_rf(TEST_DIR) if File.exist?(TEST_DIR)
  FileUtils.mkdir_p TEST_DIR
  Dir.chdir TEST_DIR
  @original_stderr = $stderr
  @original_stdout = $stdout
  # $stderr = File.open(File::NULL, 'w')
  # $stdout = File.open(File::NULL, 'w')
end

After do
  $stderr = @original_stderr
  $stdout = @original_stdout
  FileUtils.rm_rf(TEST_DIR) if File.exist?(TEST_DIR)
  Dir.chdir Dir.tmpdir
end


