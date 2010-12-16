require 'test_helper'

class TranslationProcessTest < ActionController::IntegrationTest
  setup :setup_locales

  def test_viewing_all_tranlations
    create_and_visit_pirate_locale
    assert_select "td.translation", 2
    assert_select "a.current", "All Translations"
  end

  def test_viewing_missing_translations
    create_and_visit_pirate_locale
    click_link "Missing Translations"
    assert_select "td.translation", 1
    assert_select "a.current", "Missing Translations"
  end

  def test_viewing_completed_translations
    create_and_visit_pirate_locale
    click_link "Completed Translations"
    assert_select "td.translation", 1
  end

  private

  def create_and_visit_pirate_locale
    @locale_name = "Pirate"
    Tolk::Locale::MAPPING['xx'] = @locale_name
    @locale = add_locale(@locale_name)
    Tolk::Translation.create! :locale => @locale, :phrase => Tolk::Phrase.first, :text => "Dead men don't bite"

    visit tolk_locale_url(@locale)
    assert_contain "All Translations (2)"
    assert_contain "Missing Translations (1)"
    assert_contain "Completed Translations (1)"
  end

end
