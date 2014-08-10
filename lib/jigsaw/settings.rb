module Jigsaw
  class Settings

    CONFIG_FILE = '/data/pugaipadam/jigsaw.yml'

    def self.method_missing(name, *args, &block)
      @config ||= YAML.load File.open(CONFIG_FILE)
      @config[name.to_s] || super(name, args, block)
    end

  end
end