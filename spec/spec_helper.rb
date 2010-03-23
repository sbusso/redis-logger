class Redis; attr_reader :host, :port, :db end
$DEBUG = ENV["DEBUG"] === "true"