# coding: utf-8

module Retter
  module Page
    class Profile
      include Base

      def path
        config.retter_home.join('profile.html')
      end

      def template_path
        Page.find_template_path('profile')
      end
    end
  end
end
