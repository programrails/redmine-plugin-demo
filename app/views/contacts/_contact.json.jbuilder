json.extract! contact, :id, :ctype, :company_website, :company_tax_id,
              :company_info, :person_name, :person_surname,
              :person_phone, :created_at, :updated_at
json.url contact_url(contact, format: :json)
