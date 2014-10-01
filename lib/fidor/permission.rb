module Fidor
  # A Permission defines what a user can do in a given context. In the view of
  # a web app: which actions one can execute within an endpoint
  # Additionally our permissions keep the fields a user is allowed to
  # see.
  # Atm. this class is a tiny helper so one does not need to work with hashes
  class Permission
    include Comparable

    # add locale path to global i18n path
    I18n.load_path += Fidor::Acl.i18n_files

    # @return [String]
    attr_accessor :name
    # @return [String]
    attr_accessor :context

    # @param [String] name of permission, e.g. key of scope hash
    # @param [Hash{String=>String|Array<String>}] opts permission options, see
    # values in scopes json files
    def self.from_hash(opts)
      perm = new
      perm.name = opts['name']
      perm.context = opts['context']
      perm.privileges = opts['privileges']
      perm.fields_r = opts['fields_r']
      perm.fields_rw = opts['fields_rw']
      perm
    end

    def ==(other)
      name == other.name &&
      context == other.context &&
      privileges.sort == other.privileges.sort &&
      fields_r.sort == other.fields_r.sort &&
      fields_rw.sort == other.fields_rw.sort
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
        'fields_r' => fields_r,
        'fields_rw' => fields_rw
      }
    end

    # @return [String]
    def translated_name
      I18n.t(self.name, scope: :permission_names)
    end

    def translated_fields_r
      fields_r.map{|i| I18n.t(i, scope: :permission_field_names) }.sort
    end
    def translated_fields_rw
      fields_rw.map{|i| I18n.t(i, scope: :permission_field_names) }.sort
    end

    def privileges
      @privileges || []
    end

    # @param [Array<String>] privileges list e.g index,show which map to controller actions
    def privileges=(privileges)
      @privileges = privileges
    end

    # @return [Array<String>] all fields r+rw
    def fields
      res = []
      res += fields_r
      res += fields_rw
      res
    end

    # @return [Array<String>] all read-only fields
    def fields_r
      @fields_r || []
    end

    # @return [Array<String>] all read/write fields
    def fields_rw
      @fields_rw || []
    end

    # @param [Array<String>] fields set as read-only
    def fields_r=(fields)
      @fields_r = fields
    end

    # @param [Array<String>] fields set as read/write
    def fields_rw=(fields)
      @fields_rw = fields
    end

  end
end