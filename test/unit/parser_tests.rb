require 'open-uri'
require 'mocha'
require File.dirname(__FILE__) + '/../../lib/robotstxtparser'

describe "RobotsTxtParser init" do
  it "should use file.open for files" do
    filename = File.dirname(__FILE__) + '/../data/robots1.txt'
    File.should_receive(:open).with(filename)
    p = RobotsTxtParser.new()
    p.read(filename)
  end

  it "should not fail with missing file" do
    p = RobotsTxtParser.new()
    p.read("omg")
  end

  it "should use Uri.open for urls" do
    address = "http://google.com/"
    OpenURI.should_receive(:open_uri).with(URI.parse(address))
    p = RobotsTxtParser.new()
    p.read(address)
  end
end

describe "RobotsTxtParser" do
  before do
    path = File.dirname(__FILE__) + '/../data/robots1.txt'

    #@p.should_receive(:open).with("http://www.google.com").and_raise(SocketError)
    @p = RobotsTxtParser.new()
    @p.read(path)
  end

  it "should parse user agents" do
    @p.user_agents.should include('Google')
    @p.user_agents.should include('Yahoo')
  end

  it "should parse disallows" do
    @p.user_agents['*'].should include('/logs')
    @p.user_agents['Google'].should include('/google-dir')
    @p.user_agents['Yahoo'].should include('/yahoo-dir')
  end

  it "should include wildcard disallows" do
    @p.user_agents['Yahoo'].should include('/logs')
    @p.user_agents['Google'].should include('/logs')
  end
end
