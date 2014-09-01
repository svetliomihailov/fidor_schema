module Fidor
  # A Permission defines what a user can do in a given context. In the view of
  # a web app: which actions one can execute within an endpoint
  # Additionally our permissions keep the fields a user is allowed to
  # see.
  # Atm. this class is a tiny helper so one does not need to work with hashes
  class Permission
    include Comparable

    # add locale path to global i18n path
    I18n.load_path += Dir.glob( File.dirname(__FILE__) + '/../locales/*.{rb,yml}' )

    # @return [String]
    attr_accessor :name
    # @return [String]
    attr_accessor :context

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

    def ==(other)
      name == other.name &&
      context == other.context &&
      privileges.sort == other.privileges.sort &&
      fields.sort == other.fields.sort
    end

    def <=>(other)
      if self.name == other.name
        return 0
      elsif self.name.nil?
        return -1
      elsif other.name.nil?
        return 1
      else
        return self.name <=> other.name
      end
    end

    def to_s
      self.name
    end

    def to_hash
      {
        'name' => name,
        'context' => context,
        'privileges' => privileges,
        'fields' => fields
      }
    end
    # @return [String]
    def translated_name
      I18n.t(self.name, scope: :permission_names)
    end

    def translated_fields
      fields.map{|i| I18n.t(i, scope: :permission_field_names) }.sort
    end

    def privileges
      @privileges || []
    end

    def fields
      @fields || []
    end

    def privileges=(privileges)
      @privileges = privileges
    end

    def fields=(fields)
      @fields = fields
    end
  end
end