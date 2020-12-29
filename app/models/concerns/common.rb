module Common
  extend ActiveSupport::Concern

  module ClassMethods
    def full_name
      "#{self.first_name} #{self.second_name} #{self.first_surname} #{self.second_surname}"
    end
  end
end