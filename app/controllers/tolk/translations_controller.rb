module Tolk
  class TranslationsController < ApplicationController

    def create
      @translation = Translation.create params[:tolk_translation]
      render  :partial => 'tolk/translations/translation', 
              :locals => { :translation => @translation },
              :layout => false
    end

    def update
      @translation = Translation.find(params[:id])
      @translation.update_attributes(params[:tolk_translation])
      render  :partial => 'tolk/translations/translation', 
              :locals => { :translation => @translation },
              :layout => false
    end

  end
end
