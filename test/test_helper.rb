ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

require "webrat"

Webrat.configure do |config|
  config.mode = :rails
end

class Hash
  undef :ya2yaml
end

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  fixtures :all

  self.fixture_class_names = {:tolk_locales => 'Tolk::Locale', :tolk_phrases => 'Tolk::Phrase', :tolk_translations => 'Tolk::Translation'}
end


module IntegrationTestHelpers
  protected

  def add_locale(name)
    visit tolk_root_path
    select name
    click_button 'Add'

    Tolk::Locale.find_by_name!(Tolk::Locale::MAPPING.index(name))
  end

  def setup_locales
    Tolk::Locale.delete_all
    Tolk::Translation.delete_all
    Tolk::Phrase.delete_all

    Tolk::Locale.locales_config_path = File.join(Rails.root, "test/locales/sync/")

    I18n.backend.reload!
    I18n.load_path = [Tolk::Locale.locales_config_path + 'en.yml']
    I18n.backend.send :init_translations

    Tolk::Locale.primary_locale(true)

    Tolk::Locale.sync!
  end
end

ActionController::IntegrationTest.send :include, IntegrationTestHelpers
