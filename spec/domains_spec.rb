require_relative "./helper"

describe "domains" do
  it "response should be an array" do
    VCR.use_cassette("domains/list_all_dev_domains") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/domains", "GET", {}, false
      expect(response.status).to eq 200
      JSON.parse(response.body).should be_an_instance_of Array
    end
  end

  it "should return fields that are used" do
    VCR.use_cassette("domains/list_all_dev_domains") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/domains", "GET", {}, false
      expect(response.status).to eq 200
      response.body.should include "name"
    end
  end

  it "should create a new domain" do
    domain = generate_unique_domain_name

    VCR.use_cassette("domains/create_new_domain", :erb => { :domain => "#{domain}" }) do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/domains/#{domain}", "POST", {}, false
      expect(response.status).to eq 200
      response.body.should include "id"
    end
  end

  it "should delete a new domain" do
    domain = use_existing_domain

    VCR.use_cassette("domains/delete_a_domain", :erb => { :domain => "#{domain}" }) do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/domains/#{domain}", "DELETE", {}, false
      expect(response.status).to eq 200
      response.body.should include "id"
    end
  end

  it "should purge a varnish cache for a domain" do
    domain = use_existing_domain

    VCR.use_cassette("domains/purge_varnish_cache", :erb => { :domain => "#{domain}" }) do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/domains/#{domain}/cache", "DELETE", {}, false
      expect(response.status).to eq 200
      response.body.should include "id"
    end
  end

  it "should move a domain from dev to stage" do
    domain = use_existing_domain

    VCR.use_cassette("domains/move_from_dev_to_stage", :erb => { :domain => "#{domain}" }) do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/domain-move/dev/test", "POST", { :domains => "#{domain}" }, false
      expect(response.status).to eq 200
      response.body.should include "id"
    end
  end
end
