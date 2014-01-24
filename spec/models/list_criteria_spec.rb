require 'spec_helper'

describe ListCriteria do

  it "should have fields" do
    should have_attribute(:name)
    should have_attribute(:criteria)
  end

  it "should validate precence of" do
    should validate_presence_of :name
    should validate_presence_of :criteria
  end

  it "should validate uniqueness of" do
    should validate_uniqueness_of(:name)
  end

  describe "Create list criteria using ruby code" do
    describe "Newest List" do
      def generate_newest_list(method=nil)
        Timecop.freeze(Time.local(1990)) do
          5.times do
            list = Fabricate(:list)
            list.send(method.to_sym) if method and list.respond_to? method.to_sym
          end
        end
        10.times do
          list = Fabricate(:list)
            list.send(method.to_sym) if method and list.respond_to? method.to_sym
        end
        List.count.should eql(15)
        @list_criteria = ListCriteria.create(name: :newest_lists, criteria: "List.where(:state => 'approved').order('created_at DESC').limit(10)")
      end

      it "should not return 10 newest lists if list state is pending" do
        generate_newest_list
        @list_criteria.count.should eql(0)
      end

      it "should not return 10 newest lists if list state is rejected" do
        generate_newest_list(:reject!)
        @list_criteria.count.should eql(0)
      end

      it "should return 10 newest lists if list state is approved" do
        generate_newest_list(:approve!)
        @list_criteria.count.should eql(10)
      end
    end
  end

end
