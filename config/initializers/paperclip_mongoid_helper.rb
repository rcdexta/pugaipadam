module Paperclip
  module Helpers

    # Find all instances of the given Active Record model +klass+ with attachment +name+.
    # This method is used by the refresh rake tasks.
    def each_instance_with_attachment(klass, name)
      class_for(klass).unscoped.ne("#{name}_file_name" => nil).each do |instance|
        yield(instance)
      end
    end

  end
end