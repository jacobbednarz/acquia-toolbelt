require_relative "./helper"

describe "databases" do
  it "response should be an array" do
    VCR.use_cassette("databases/all_databases") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/dbs", "GET", {}, false
      expect(response.status).to eq 200
      JSON.parse(response.body).should be_an_instance_of Array
    end
  end

  it "should return fields that are used for a basic listing" do
    VCR.use_cassette("databases/all_databases") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/dbs", "GET", {}, false
      expect(response.status).to eq 200
      response.body.should include "name"
    end
  end

  it "should include all required fields for a single database instance" do
    database = use_existing_database

    VCR.use_cassette("databases/view_database_instance_details", :erb => { :database => "#{database}" }) do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/dbs/#{database}", "GET", {}, false
      expect(response.status).to eq 200
      response.body.should include("username", "password", "host", "db_cluster", "instance_name")
    end
  end

  it "should be able to create a new database" do
    VCR.use_cassette("databases/create_a_new_database") do
      database = generate_unique_database_name
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/dbs", "POST", { :db => "#{database}" }, false
      expect(response.status).to eq 200
      response.body.should include "id"
    end
  end

  it "should copy a database from dev to stage" do
    database = use_existing_database

    VCR.use_cassette("databases/copy_database_from_dev_to_stage", :erb => { :database => "#{database}" }) do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/dbs/#{database}/db-copy/dev/test", "POST", {}, false
      expect(response.status).to eq 200
      response.body.should include "id"
    end
  end

  it "should delete a database from the dev environment" do
    database = use_existing_database

    VCR.use_cassette("databases/delete_a_database", :erb => { :database => "#{database}" }) do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/dbs/#{database}", "DELETE", {}, false
      expect(response.status).to eq 200
      response.body.should include "id"
    end
  end

  it "should generate a database backup" do
    database = use_existing_database

    VCR.use_cassette("databases/create_a_database_backup", :erb => { :database => "#{database}"} ) do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/dbs/#{database}/backups", "POST", {}, false
      expect(response.status).to eq 200
      response.body.should include "id"
    end
  end

  it "should list all available database backups" do
    database = use_existing_database

    VCR.use_cassette("databases/list_all_database_backups", :erb => { :database => "#{database}"}) do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/dbs/#{database}/backups", "GET", {}, false
      expect(response.status).to eq 200
      response.body.should include("id", "path", "link")
    end
  end
end
