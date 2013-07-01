namespace :db do

  desc 'drop tables in database'
  task :drop_tables => :environment do
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table table
    end
  end

  desc 'drop tables, run migrations, load seeds'
  task :rebuild => [:drop, :create, :migrate, :seed]

  namespace :fixtures do
    desc 'Dumps all models into fixtures.'
    task :dump => :environment do
      models = Dir.glob("#{Rails.root}/app/models/**.rb").map do |s|
        Pathname.new(s).basename.to_s.gsub(/\.rb$/,'').camelize
      end
 
      puts "Found models: " + models.join(', ')
 
      models.each do |m|
        model = m.constantize
        next unless model.ancestors.include?(ActiveRecord::Base)
 
        puts "Dumping model: " + m
        entries = model.find(:all, :order => 'id ASC')
 
        increment = 1
 
        model_file = "#{Rails.root}/test/fixtures/#{m.underscore.pluralize}.yml"
        File.open(model_file, 'w') do |f|
          entries.each do |a|
            attrs = a.attributes
            attrs.delete_if{|k,v| v.blank?}
 
            output = {m + '_' + increment.to_s => attrs}
            f << output.to_yaml.gsub(/^--- \n/,'') + "\n"
 
            increment += 1
          end
        end
      end
    end
  end
end
