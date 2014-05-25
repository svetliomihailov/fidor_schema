require 'king_auth/guard'
module Fidor::Auth
  # Controller Mixin to allow role-based access to restricted controller/method
  # combinations. Your controller gains the following instance variable:
  #   @access_guard
  # (call it through access_guard method though)
  # Your Controller MUST respond(define) to the follwing methods
  # - curent_user
  # - permission_denied
  module Controller
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      # make :allowed_to? available as ActionView helper methods.
      base.send :helper_method, :allowed_to? if base.respond_to? :helper_method
    end

    module ClassMethods
      # for testing filter_access is skipped by default. To prevent skipping set
      # class var to anything BUT nil
      attr_accessor :skip_access_filter
      def skip_access_filter?
         !@skip_access_filter.nil?
      end
    end

    module InstanceMethods
      # Method called from helpers, and controllers to check if someone is allowed
      # to enter a method
      # === Parameter
      # privilege<Symbol|String>:: The privilege to look for
      # context<Symbol<String>:: The context in which to lookup the privilege
      def allowed_to?(privilege, context)
        allowed = true
        allowed = access_guard.check(privilege.to_sym, context.to_sym) unless self.class.skip_access_filter?
        allowed
      end

      # Method called from controller to add permissions on specific level.
      #
      #    add_perms 1, :company_permissions
      #    add_perms 2, :app_permissions
      #    add_perms 3, :team_permissions
      #    add_perms 3, :user_permissions
      #
      #    def company_permissions
      #      {:contacts => [:index, :show, :edit, :new, :update]}
      #    end
      #
      #    def app_permissions
      #      {}
      #    end
      #
      #    def team_permissions
      #      ...
      #    ...
      #
      # In this example company permissions take precedence over
      # application permissions. Team and user permissions are
      # on the same level, which means, either will be allowed,
      # with no precedence. They filter available permissions
      # from higher levels (app and company in this example)
      #
      # == Params
      # level<Integer>:: on which level the permissions are to be instert
      # perms<Symbol>:: method name to be called
      # TODO perms<Hash>:: directly add perms
      def add_perms(level, perms)
        gotten_permissions = perms.is_a?(Symbol) ? self.send(perms) : perms
        access_guard.add_permissions(level, gotten_permissions)
      end

      protected
      # The controllers before filter method
      #
      # filter access to controllers and actions only IF
      #   - we are not in testing mode
      #   - a user is present
      #   - the user has roles
      def filter_access
        return if self.class.skip_access_filter?
        allowed = true
        if current_user && access_guard
          # check with nested controller name 'admin/settings' , 'api/clients' OR 'clients'
          allowed = access_guard.check(action_name.to_sym, self.class.controller_path.to_sym)
        end
        # kick out if check failed
        allowed || permission_denied
      end

      # Initalize the controller instance var @access_guard which receives
      # the allowed_to? and filter_access calls.
      # Roles are checked by their array index, starting with the first one
      # === Returns
      # Object<KingAuth::Guard>
      # false:: if no roles are available
      def access_guard
        @access_guard ||= KingAuth::Guard.new
      end

    end # Module InstanceMethods
  end # Module Controller
end # Module KingAuth
