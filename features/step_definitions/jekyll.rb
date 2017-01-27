
# Like "I have a foo file" but gives a yaml front matter so jekyll actually processes it
Given(/^I have an? "(.*)" page(?: with (.*) "(.*)")? that contains "(.*)"$/) do |file, key, value, text|
  File.open(file, 'w') do |f|
    f.write <<EOF
---
#{key || 'layout'}: #{value || 'nil'}
---
#{text}
EOF
    f.close
  end
end

Given(/^I have an? "(.*)" file that contains "(.*)"$/) do |file, text|
  File.open(file, 'w') do |f|
    f.write(text)
    f.close
  end
end

Given(/^I have a configuration file with "(.*)" set to "(.*)"$/) do |key, value|
  File.open('_config.yml', 'a') do |f|
    f.write("#{key}: #{value}\n")
    f.close
  end
end

Given(/^The configuration file is"([^"]*)"$/) do |content|
  File.open('_config.yml', 'w') do |file|
    file.write(content)
  end
end

When(/^I run jekyll$/) do
  run_jekyll
end

Then(/^the (.*) directory should exist$/) do |dir|
  # assert File.directory?(dir)
  expect(File).to be_directory(dir)
end

Then(/^I should see "(.*)" in "(.*)"$/) do |pattern, file|
  text = File.open(file).readlines.join

  assert_match Regexp.new(pattern), text,
    "Pattern /#{pattern}/ not found in: #{text}"
end

Then(/^I should not see "(.*)" in "(.*)"$/) do |pattern, file|
  text = File.open(file).readlines.join

  assert !text.match(Regexp.new(pattern)),
    "Did not exptect /#{pattern}/ in: #{text}"
end

Then(/^the (file|dir) "(.*)" (should not exist|should exist)$/) do |type, path, condition|
  full_path = File.expand_path(path)
  type_class = Module.const_get(type.capitalize)
  condition_sym = condition.include?('not') ? :to_not : :to
  expect(type_class).send condition_sym, exist(full_path)
end

# Then(/^the "(.*)" file should not exist$/) do |file|
  # assert !File.exists?(file)
# end
