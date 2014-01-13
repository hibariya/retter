module Retter
  module StaticSite
    module App
      module ApplicationHelper
        DISQUS_FORM = Haml::Engine.new(<<-HAML)
#disqus_thread
  :javascript
    var disqus_shortname = '\#{disqus_shortname}';
    (function() {
      var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
      dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
      (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
        HAML

        def render_disqus_comment_form
          DISQUS_FORM.render(binding, disqus_shortname: App.config.disqus_shortname)
        end
      end

      module CompatibilityHelper
        def config
          App.config
        end

        def article_path(article, options = {})
          entry_article_path(article.entry, article, options)
        end

        def content
          raise 'Please replace s/content/yield/'
        end
      end
    end
  end
end
