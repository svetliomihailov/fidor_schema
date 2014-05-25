# Rights
class Scopes

  PERMISSSIONS = {
    # a single permission
    read_user_email:  {                               #<=  permission name    A Permission defines the privileges that somebody has in a given context
      context: :users,                                     # controller == context
      privileges: [:current, :show],                        # actions   == privileges
      fields: [:email]                                      # available fields  == other constrains
    },
    read_customer_name:  {
      context: :customers,
      privilege: [:current, :show],
      fields: [:title, firstname, lastname]
    },
    read_customer_nick:  {
      context: :customers,
      privilege: [:current, :show],
      fields: [:nick]
    },
    read_customer_phone:  {
      context: :customers,
      privileges: [:current, :show],
      fields: [:adr_phone, :adr_mobile, :adr_businessphone]
    },
    read_customer_address:  {
      context: :customers,
      privilege: [:current, :show],
      fields: [:adr_street, :adr_street_number, :adr_city, :adr_country]
    },
    create_transfers:  {
      context: 'transfers',
      privileges: [:create,:show, :index],
      fields: [:subject, :amount, :external_ref, :remote_holder, :remote_iban, :remote_bic]
    },

    read_transaction_full:  {
      description: 'Kontoumsätze mit allen Details',
      context: 'transactions',
      privileges: [:show, :index],
      fields: [:_all],
    },
    read_transaction_subject:  {
      description: 'Verwendungzwecke von Kontoumsätzen',
      context: 'transactions',
      privileges: [:show, :index],
      fields: [:subject],
    },

  }
=begin
#   in controller

  class SomeController

    before_filter :access_control

    def access_control
      #current_customer.permissions + current_user.permissions + current_app.permissions
      #=> current_user.effective_permissions
      #=> {transfers: [:show, :index, :create], customers: [:current], .. }
      allowed_to?( :action_name, :controller_name)
      allowed_to?(:create,:transactions)
      #=> effective_permissions.has_key?(:transactions) && effective_permissions[:transactions].includes?(:create)
    end

    def index
      objects = current_customer.transfers.find(params)
      # convert to schema hash with allowed fields
      allowed_fields = current_app.fields_for(:transfers)
      objects.each do
        res << obj.to_hash_from_schema(fields: allowed_fields)
      end

    end

=end


end