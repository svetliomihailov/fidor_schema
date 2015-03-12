require 'spec_helper'

describe Fidor::Schema do

  context 'path' do
    it 'should provide path to schema files' do
      expect(Fidor::Schema.path).to eq(File.expand_path( File.join('../schema/v1.0'), File.dirname(__FILE__)))
    end
  end

  context 'read schemata' do

    it 'should read all json files' do
      SchemaTools.schema_path = Fidor::Schema.path
      SchemaTools::Reader.read_all
      expect(SchemaTools::Reader.registry).to_not be_empty
    end

  end

  context 'resolves $refs' do

    it 'in single schema' do
      SchemaTools.schema_path = Fidor::Schema.path
      schema = SchemaTools::Reader.read('account').to_h
      expect(schema['properties']['customers']['items']['properties']['id']['type']).to eq 'string'
    end

    it 'should resolve all' do
      SchemaTools.schema_path = Fidor::Schema.path
      SchemaTools::Reader.read_all
      out = []
      SchemaTools::Reader.registry.each{|n, i|
        out << "#{i.to_h}"
      }
      expect(out).to_not include('$ref')
    end

  end
end