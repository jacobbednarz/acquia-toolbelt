require_relative "./helper"

describe "databases" do
  it "response should be an array" do
    VCR.use_cassette("databases/all_databases") do
      response = AcquiaToolbelt::CLI::API.request "sites/devcloud:acquiatoolbeltdev/dbs", "GET", {}, false
      (response.status).should eq 200
      JSON.parse(response.body).should be_an_instance_of Array
    end
  end

  it "should return fields that are used for a basic listing" do
    VCR.use_cassette("databases/all_databases") do
      response = AcquiaToolbelt::CLI::API.request "sites/devcloud:acquiatoolbeltdev/dbs", "GET", {}, false
      (response.status).should eq 200
      response.body.should include "name"
    end
  end

  it "should include all required fields for a single database instance" do
    VCR.use_cassette("databases/view_database_instance_details") do
      response = AcquiaToolbelt::CLI::API.request "sites/devcloud:acquiatoolbeltdev/envs/dev/dbs/example-db", "GET", {}, false
      (response.status).should eq 200
      response.body.should include("username", "password", "host", "db_cluster", "instance_name")
    end
  end

  it "should be able to create a new database" do
    VCR.use_cassette("databases/create_a_new_database") do
      database = "test-suite-db-#{8.times.map { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join}"
      response = AcquiaToolbelt::CLI::API.request "sites/devcloud:acquiatoolbeltdev/dbs", "POST", {:db => "#{database}"}, false
      (response.status).should eq 200
      response.body.should include "id"
    end
  end

  it "should copy a database from dev to stage" do
    VCR.use_cassette("databases/copy_database_from_dev_to_stage") do
      response = AcquiaToolbelt::CLI::API.request "sites/devcloud:acquiatoolbeltdev/dbs/example-db/db-copy/dev/test", "POST", {}, false
      (response.status).should eq 200
      response.body.should include "id"
    end
  end

  it "should delete a database from the dev environment" do
    VCR.use_cassette("databases/delete_a_database") do
      # Create a database to delete.
      database = "test-suite-db-7b9bf6"
      AcquiaToolbelt::CLI::API.request "sites/devcloud:acquiatoolbeltdev/dbs", "POST", {:db => "#{database}"}

      response = AcquiaToolbelt::CLI::API.request "sites/devcloud:acquiatoolbeltdev/dbs/#{database}", "DELETE", {}, false
      (response.status).should eq 200
      response.body.should include "id"
    end
  end

  it "should generate a database backup" do
    VCR.use_cassette("databases/create_a_database_backup") do
      response = AcquiaToolbelt::CLI::API.request "sites/devcloud:acquiatoolbeltdev/envs/dev/dbs/example-db/backups", "POST", {}, false
      (response.status).should eq 200
      response.body.should include "id"
    end
  end

  it "should list all available database backups" do
    VCR.use_cassette("databases/list_all_database_backups") do
      response = AcquiaToolbelt::CLI::API.request "sites/devcloud:acquiatoolbeltdev/envs/dev/dbs/example-db/backups", "GET", {}, false
      (response.status).should eq 200
      response.body.should include("id", "path", "link")
    end
  end
end
