require 'active_support'
module Fidor
  class Acl

    def self.registry
      @registry ||= {}
    end

    def self.read
      return @registry if @registry
      file_path = File.join( self.scopes_path, '*.json')
      Dir.glob( file_path ).each do |file|
        res = ActiveSupport::JSON.decode( File.open(file, 'r'){|f| f.read} )
        registry.merge!(res)
      end
      registry
    end

    def self.scopes_path(version='v1.0')
      File.expand_path( File.join('../../scopes', version), File.dirname(__FILE__))
    end
  end
end