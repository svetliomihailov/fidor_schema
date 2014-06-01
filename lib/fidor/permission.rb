module Fidor
  # A Permission defines what a user can do in a given context. In the view of
  # a web app: which actions one can execute within an endpoint
  # Additionally our permissions keep the fields a user is allowed to
  # see.
  # Atm. this class is a tiny helper so one does not need to work with hashes
  class Permission
    # add locale path to global i18n path
    I18n.load_path += Dir.glob( File.dirname(__FILE__) + '/../locales/*.{rb,yml}' )

    # @return [String]
    attr_accessor :name
    # @return [String]
    attr_accessor :context
    # @return [Array<String>]
    attr_accessor :privileges
    # @return [Array<String>]
    attr_accessor :fields


    # @param [String] name of permission, e.g. key of scope hash
    # @param [Hash{String=>String|Array<String>}] opts permission options, see
    # values in scopes json files
    def self.from_hash(name, opts)
      perm = new
      perm.name = name
      perm.context = opts['context']
      perm.privileges = opts['privileges']
      perm.fields = opts['fields']
      perm
    end

    def to_s
      self.name
    end

    # @return [String]
    def translated_name
      I18n.t(self.name, scope: :permission_names)
    end

  end
end