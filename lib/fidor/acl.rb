require 'active_support'
module Fidor
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

      def scopes_path(version='v1.0')
        File.expand_path( File.join('../../scopes', version), File.dirname(__FILE__))
      end

      # Tiny helper to generate i18n keys for all permission names and _info
      # fields
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