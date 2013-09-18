require 'rom/support/axiom/adapter'
require 'json'

module Axiom::Adapter
  class JSONAdapter < Yaml
    uri_scheme :json

    def read(relation)
      attributes = relation.header.map(&:name).map(&:to_s)
      data[relation.name.to_s].map { |hash| hash.values_at(*attributes) }
    end

    def insert(relation, tuples)
      @data[relation.name] ||= []
      tuples.each do |tuple|
        data[relation.name.to_s] << attributes(relation.header, tuple)
      end
      write
      reload
    end

    def delete(relation, tuples)
      tuples.each do |tuple|
        data[relation.name.to_s].delete(attributes(relation.header, tuple))
      end
      write
      reload
    end

    private
    attr_reader :schema, :data

    def reload
      @data = begin
        if File.exist?(path)
          JSON.parse(File.read(path))
        else
          {}
        end
      end
    end

    def write
      File.open(path, 'wb') do |f|
        f.write JSON.fast_generate(data)
      end
    end
  end
end
