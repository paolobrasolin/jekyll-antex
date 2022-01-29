# frozen_string_literal: true

require "jekyll/antex"

describe Jekyll::Antex do
  describe ".allowed_resource?" do
    let(:mock_resource) { Struct.new(:relative_path) }
    it "allows markdown files" do
      resource = mock_resource.new("foo.md")
      expect(subject.allowed_resource?(resource)).to be_truthy
    end

    it "allows HTML files" do
      resource = mock_resource.new("foo.html")
      expect(subject.allowed_resource?(resource)).to be_truthy
    end

    it "rejects CSS files" do
      resource = mock_resource.new("foo.css")
      expect(subject.allowed_resource?(resource)).to be_falsy
    end
  end
end
