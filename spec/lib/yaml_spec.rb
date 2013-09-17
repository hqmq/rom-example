require 'spec_helper'
require 'fileutils'

describe 'YAML Adapter' do
  let(:fixture_file){ 'spec/fixtures/users.yml' }
  let(:env) do
    env = ROM::Environment.setup(yaml: "yaml://#{fixture_file}")

    env.schema do
      base_relation :users do
        repository :yaml

        attribute :id,   Integer
        attribute :name, String

        key :id
      end
    end

    env.mapping do
      users do
        model User
        map :id, :name
      end
    end
    env
  end

  it "finds users" do
    env.session do |s|
      s[:users].count.should == 2
      john = s[:users].restrict(id: 1).one
      john.name.should == 'John'
      john.id.should == 1
    end
  end

  it "can insert new user" do
    original_path = fixture_file.clone
    fixture_file['.yml'] = '.tmp.yml'
    FileUtils.copy(original_path, fixture_file)
    env.session do |s|
      johnny = User.new(name: "Johnny Appleseed", id: 3)
      s[:users].insert(johnny)
      s.flush
    end

    content = File.read(fixture_file)
    content.should include("Johnny Appleseed")
  end
end
