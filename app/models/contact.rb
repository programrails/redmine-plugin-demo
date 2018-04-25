# class Contact
class Contact < ActiveRecord::Base
  belongs_to :contactable, polymorphic: true
  has_many :contacts, as: :contactable, class_name: 'Contact'

  acts_as_event datetime: :created_at,
                description: :full_name,
                title: proc { |o| "#{l(:label_full_name_contacts)} ##{o.id} - #{o.full_name}" },
                url: proc { |o| { controller: 'contacts', action: 'index', id: o.id } }

  acts_as_searchable columns: ['full_name']

  def created_at
    # to satisfy acts_as_event
    created_on
  end

  def project
    # to fool around the search index template
  end

  scope :visible, lambda { |*args|
    # /home/test/projects/redmine-3.4.5/lib/plugins/acts_as_searchable/lib/acts_as_searchable.rb
    # line 189
    # a quick-and-dirty work-around to untie the contacts search from projects and
    # thus make the search at least work with contacts
    # (currently neglecting all the access rights)
  }

  acts_as_customizable
end
