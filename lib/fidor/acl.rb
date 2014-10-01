require 'active_support'
module Fidor
  # Base class with methods to read permissions from scope json files and setup
  # ruby object structures from them
  class Acl

    class << self

      # Collect all contexts with their privileges.
      #
      #   {
      #     'accounts': ['index', 'show'],
      #     'transfers': ['index', 'show', 'create']
      #   }
      # Can be used in controller filter to check if someone can access a
      # controller and the given action. Simply check if the controller name is
      # present in the keys and than if the array includes the current controller
      # action.
      # @return [Hash{String=>Array<String>}]
      def flat_perms_hash
        init
        permissions_hash = {}
        registry.each do |permission|
          context = permission['context']
          permissions_hash[context] ||= []
          permission['privileges'].present? && permission['privileges'].each do |privilege|
            (permissions_hash[context] << privilege) unless permissions_hash[context].include?(privilege)
          end
        end
        permissions_hash
      end

      def registry
        @registry ||= []
      end
      def object_registry
        @object_registry ||= []
      end

      # Get a permission hash by permission name from the registry
      #     Fidor::Acl['read_account_number']
      # @param [String] name of permission to get from registry
      def [](name)
        init
        registry.detect{|permission| permission['name'] == name}
      end

      # Read all scope json files and populate global registry. Second call
      # returns cached registry.
      # @return [Hash]
      def init
        return @registry if @registry
        file_path = File.join( self.scopes_path, '*.json')
        Dir.glob( file_path ).each do |file|
          res = ActiveSupport::JSON.decode( File.open(file, 'r'){|f| f.read} )
          registry.push(*res)
        end
        registry
      end

      # Initialize all permissions as object structure, instead of .init which
      # uses a plain hash
      # @return [Array<Fidor::Permission>]
      def init_objects
        return @object_registry if @object_registry
        perms = init
        perms.each do |perm|
          object_registry << Fidor::Permission.from_hash(perm)
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
        perms.flat_map{|i| [ "#{i['name']}:", "#{i['name']}_info:" ] }.sort
      end

      # Helper to generate i18n keys for all permission names and
      # additionally an [xy_name]_info for a longer description
      def i18n_field_keys
        perms = init
        perms.flat_map{|i| [*i['fields_r'], *i['fields_rw']] }.uniq.sort.map{|i| "#{i}:"}
      end
    end
  end
end