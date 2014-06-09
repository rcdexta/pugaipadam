require 'lib/jigsaw/connection'

namespace :pugaipadam do
  desc "Sync consultant details from Jigsaw"

  task :jigsaw_sync => :environment do

    puts "Pulling Consultant Details from Jigsaw..."

    jsaw_cons = Jigsaw::Connection.fetch_consultants
    jsaw_cons.each do |con|
      consultant = Consultant.find_or_create_by(employee_id: con[:employee_id])
      unless consultant.encrypted_password.present?
        consultant.password = con[:employee_id].to_s
        consultant.password_confirmation = con[:employee_id].to_s
      end
      consultant.update_attributes! con
    end

    puts "Done!"

    puts "Pulling Project Details from Jigsaw..."

    projects = Jigsaw::Connection.fetch_projects
    projects.each do |proj|
      jigsaw_id = proj.delete(:jigsaw_id)
      project = Project.find_or_create_by(project_id: proj[:project_id])
      project.update_attributes! proj
      consultant = Consultant.find_by jigsaw_id: jigsaw_id
      consultant.update_attributes! project: project
    end

    puts "Done!"
  end

end
