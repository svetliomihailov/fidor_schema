# encoding: utf-8
module Fidor
  class Schema
    # Get the path to schema files delivered by this gem. 
    # @example
    # 	Fidor::Schema.path   # => /home/me/gems/.../fidor_schema/schema
    #
    # @param [String] version folder name to use
    def self.path(version='v1.0')
      File.expand_path( File.join('../../schema', version), File.dirname(__FILE__))
    end
  end
end
