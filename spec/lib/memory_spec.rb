require 'spec_helper'

describe 'ROM' do
  before(:each) do
    @env = ROM::Environment.setup(memory: 'memory://test')

    @env.schema do
      base_relation :users do
        repository :memory

        attribute :id,   Integer
        attribute :name, String

        key :id
      end
    end

    @env.mapping do
      users do
        map :id, :name
        model User
      end
    end
  end

  it "creates new models" do
    @env.session do |s|
      s[:users].count.should == 0

      user = s[:users].new(id: 1, name: 'jane')
      user.id.should == 1
      user.name.should == 'jane'
      user.should be_a(User)

      s[:users].should be_tracking(user)
      s[:users].state(user).should be_transient

      s[:users].save(user)
      s[:users].state(user).should be_created
      s.flush
      s[:users].state(user).should be_persisted

      s[:users].count.should == 1
    end
  end

  it "can accept models created outside the session" do
    @env.session do |s|
      s[:users].count.should == 0

      user = User.new(id: 2, name: 'jane')
      s[:users].should_not be_tracking(user)
      s[:users].track(user)
      s[:users].should be_tracking(user)
      s[:users].save(user)
      s.flush

      s[:users].count.should == 1
    end
  end
end
