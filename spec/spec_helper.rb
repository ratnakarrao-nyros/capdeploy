require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] = 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each{ |f| require File.expand_path(f) }

  if defined?(CarrierWave)
    CarrierWave::Uploader::Base.descendants.each do |klass|
      next if klass.anonymous?
      klass.class_eval do
        def store_dir
          "#{Rails.root}/spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
        end

        def cache_dir
          "#{Rails.root}/spec/support/uploads/tmp"
        end
      end
    end
  end

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rspec
    config.mock_with :rspec

    # RSpec configuration options
    config.include(RSpec::Rails::Matchers)
    config.include(Devise::TestHelpers, :type => :controller)
    config.include(DeviseControllerMacros)
    config.include(MailerMacros)
    config.include(Capybara::DSL)

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # enable :focus tag for each describe block
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    config.before(:suite) do
      # some config here before suite
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:transaction)
    end

    config.after(:suite) do
      # some config here after suite
    end

    config.before(:all) do
      # some config here before all
      #DatabaseCleaner.start
      #reset_email
      #Timecop.return
    end

    config.before(:each) do
      # some config here before each test
      DatabaseCleaner.start
      reset_email
      Timecop.return
    end

    config.around :each, :type => :request do |example|
      DatabaseCleaner.strategy = :truncation
      example.run
      DatabaseCleaner.strategy = :transaction
    end

    config.after(:each) do
      # some config here after each test
      DatabaseCleaner.clean
      Capybara.reset_sessions!
      Capybara.use_default_driver
      Timecop.return
    end

    config.after(:all) do
      # some config here after all
      #DatabaseCleaner.clean
      #Capybara.reset_sessions!
      #Capybara.use_default_driver
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
  end

end # Spork.prefork


Spork.each_run do
  Fabrication.clear_definitions
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
end
