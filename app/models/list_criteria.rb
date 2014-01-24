class ListCriteria < ActiveRecord::Base
  include Enumerable

  validates_presence_of :criteria, :name
  validates_uniqueness_of :name

  def each(&block)
    results = eval(self.criteria)
    raise "not an #Enumerable value" unless results.respond_to? "each"
    results.each(&block)
  end

  def all
    eval(self.criteria)
  end
end
