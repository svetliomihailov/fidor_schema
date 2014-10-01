require 'fidor_acl'

# custom tasks
namespace :i18n do
  desc "add new keys to the translation files"
  task :add do
    Fidor::Acl.i18n_add_missing
    puts "translation files updated\n"
  end
end