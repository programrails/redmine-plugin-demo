# class ContactsHookListener
class ContactsHookListener < Redmine::Hook::ViewListener
  render_on :view_issues_form_details_bottom, partial: 'contacts/index'
  render_on :view_issues_show_description_bottom, partial: 'contacts/index'
end
