require 'test_helper'

class TranslationProcessTest < ActionController::IntegrationTest
  setup :setup_locales

  def test_adding_locale
    assert_difference('Tolk::Locale.count') { add_locale 'German' }
  end

  def test_adding_missing_translations_and_updating_translations
    Tolk::Locale::MAPPING['xx'] = "Pirate"
    
    locale = add_locale("Pirate")
    assert locale.translations.empty?

    # Adding a new translation
    pirate_url = tolk_locale_url(locale)
    visit pirate_url
    fill_in 'translations[][text]', :with => "Dead men don't bite"
    click_button 'Save changes'

    assert_equal current_url, pirate_url
    assert_equal 1, locale.translations.count

    # Updating the translation added above
    click_link 'See completed translations'
    assert_contain "Dead men don't bite"

    fill_in 'translations[][text]', :with => "Arrrr!"
    click_button 'Save changes'

    assert_equal current_url, all_tolk_locale_url(locale)
    assert_equal 1, locale.translations.count
    assert_equal 'Arrrr!', locale.translations(true).first.text
  end

end
