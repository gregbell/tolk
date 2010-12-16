module Tolk
  class LocalesController < Tolk::ApplicationController
    before_filter :find_locale, :only => [:show, :all, :update, :updated]
    before_filter :ensure_no_primary_locale, :only => [:all, :update, :show, :updated]

    def index
      @locales = Tolk::Locale.secondary_locales
    end
  
    def show
      @filter_by = resolve_submitted_filter
      @phrases = case @filter_by
                 when Tolk::Locale::ALL
                  Tolk::Phrase.paginate(:page => params[:page] || 1, :order => "key ASC")
                 when Tolk::Locale::MISSING
                  @locale.phrases_without_translation(params[:page])
                 when Tolk::Locale::COMPLETED
                  @locale.phrases_with_translation(params[:page])
                 end
      respond_to do |format|
        format.html 
        format.atom { @phrases = @locale.phrases_without_translation(params[:page], :per_page => 50) }
        format.yml { render :text => @locale.to_hash.ya2yaml(:syck_compatible => true) }
      end
    end

    def resolve_submitted_filter
      Tolk::Locale::FILTERS.include?(params[:filter]) ? params[:filter] : Tolk::Locale::ALL
    end

    def update
      @locale.translations_attributes = params[:translations]
      @locale.save
      redirect_to request.referrer
    end

    def all
      @phrases = @locale.phrases_with_translation(params[:page])
    end

    def updated
      @phrases = @locale.phrases_with_updated_translation(params[:page])
      render :all
    end

    def create
      Tolk::Locale.create!(params[:tolk_locale])
      redirect_to :action => :index
    end

    private

    def find_locale
      @locale = Tolk::Locale.find_by_name!(params[:id])
    end
  end
end
