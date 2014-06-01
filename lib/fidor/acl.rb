require 'active_support'
module Fidor
  # Base class with methods to read permissions from scope json files and setup
  # ruby object structures from them
  class Acl

    class << self

      def flat_perms_hash
        init unless @registry
        permissions_hash = Hash.new
        registry.each do |name, permission|
          context = permission['context']
          permissions_hash[context] ||= []
          permission['privileges'].each do |privilege|
            (permissions_hash[context] << privilege) unless permissions_hash[context].include?(privilege)
          end
        end
        permissions_hash
      end

      def registry
        @registry ||= {}
      end
      def object_registry
        @object_registry ||= []
      end

      # Read all scope json files and populate global registry. Second call
      # returns cached registry.
      # @return [Hash]
      def init
        return @registry if @registry
        file_path = File.join( self.scopes_path, '*.json')
        Dir.glob( file_path ).each do |file|
          res = ActiveSupport::JSON.decode( File.open(file, 'r'){|f| f.read} )
          registry.merge!(res)
        end
        registry
      end

      # Initialize all permissions as object structure, instead of .init which
      # uses a plain hash
      # @return [Array<Fidor::Permission>]
      def init_objects
        return @object_registry if @object_registry
        perms = init
        perms.each do |key, val|
          object_registry << Fidor::Permission.from_hash(key, val)
        end
        object_registry
      end

      # @param [String] version which simply maps to a sub-folder name in the
      # /scopes/ directory
      # @return [String]
      def scopes_path(version='v1.0')
        File.expand_path( File.join('../../scopes', version), File.dirname(__FILE__))
      end

      # Tiny helper to generate i18n keys for all permission names and
      # additionally an [xy_name]_info for a longer description
      def i18n_permission_keys
        perms = init
        res = []
        perms.keys.each do |i|
          res << "#{i}:"
          res << "#{i}_info:"
        end
        res.sort
      end
    end
  end
end