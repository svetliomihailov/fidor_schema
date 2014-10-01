# FidorAcl

This gem holds the available permissions for Fidor apps. Permissions are 
referenced as scopes during oAuth app registration.

If you are not using Ruby, take a look into the /scopes folder, where you can 
find the raw json files with the definitions.

## Installation

Add this line to your application's Gemfile:

    gem 'fidor_acl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fidor_acl

## Usage

Initialize & read the global acl registry as plain ruby hash
    
    Fidor::Acl.init         # reads the json definitions
    Fidor::Acl.registry     # returns array of ruby hashes

Init permissions as objects

    Fidor::Acl.init_objects       # reads the json definitions
    Fidor::Acl.object_registry    # return array of Permission objects
    
Work with permissions objects    

    permission = Fidor::Acl.object_registry.first
    permission.name
    permission.context
    permission.privileges
    permission.fields_r
    permission.fields_rw

Compare permissions

    perm1 = Fidor::Acl.object_registry[0]
    perm2 = Fidor::Acl.object_registry[1]
    # a permission equals another if name, context, privileges and fields are the same
    perm1 == perm2

Convert a permission to & from hash

  p = Permission.new
  p.context = 'accounts'
  p.name = 'read_accounts'
  p.to_hash
  
  p1 = Fidor::Acl::Permission.from_hash( 'context'=> 'users', 'name' => 'read users' )
  p1.context => 'users'
  
Translations are kept in lib/locales and there are helper methods for a permission to use them:

    permission.translated_name
    permission.translated_fields_r   #=> read-only fields sorted in the current language 
    permission.translated_fields_rw  #=> read/write fields  

Update language files with new permissions names or fields:

    rake i18n:add 
    # or manually
    # => show new keys
    Fidor::Acl.i18n_find_missing 
    # write file with new keys
    Fidor::Acl.i18n_add_missing
  
## Contributing

1. Fork it ( http://github.com/<my-github-username>/fidor_acl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
