require_dependency 'contacts_hook_listener'

# UsersHelperContacts helper module
module UsersHelperContacts
  # class Includer
  class Includer
    include UsersHelper
  end

  def user_settings_tabs
    tabs = Includer.new.user_settings_tabs
    @contacts = Contact.where(contactable_type: 'User',
                              contactable_id: @user.id)
    tabs.insert tabs.count, name: 'contacts', partial: 'contacts/index',
                            locals: { contacts: @contacts, user: @user },
                            label: :contacts
    tabs
  end
end

UsersHelper.prepend UsersHelperContacts

require 'user'
# class User
class User
  has_many :contacts, as: :contactable
  # This class reopening causes the constant-reinitialization warnings
  # in the console window.
  # This problem needs more time to investigate.
end

require 'project'
# class Project
class Project
  has_many :contacts, as: :contactable
end

CustomFieldsHelper::CUSTOM_FIELDS_TABS <<
  { name: 'ContactCustomField', partial: 'custom_fields/index',
    label: :label_contact_plural }

Redmine::Plugin.register :contacts do
  name 'Contacts plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  permission :global_view_contacts, contacts: :index

  project_module :contacts do
    permission :view_contacts, contacts: :index
  end

  # Local menu
  menu :project_menu, :contacts,
       { controller: 'contacts', action: 'index' },
       caption: 'Contacts', after: :activity, param: :project_id

  # Global menu
  # menu :application_menu, :contacts,
  # { controller: 'contacts', action: 'index' }, caption: 'Contacts'
  menu :top_menu, :contacts,
       { controller: 'contacts', action: 'index' },
       caption: 'Contacts'
end

Redmine::Search.available_search_types << 'contacts'
