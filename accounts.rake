namespace :accounts do
  
  desc "Remove accounts where the email was never validated and it is over 30 days old"
  task :remove_unvalidated do
    @people = Person.created_before(Time.now - 30.days).not_validated
    @people.each do |person|
      Rails.logger.info "Removing unvalidated user #{person.email}"
      person.destroy
    end
    Emails.admin_removing_unvalidated_users(Person.admins, @people).deliver
  end
  
end
