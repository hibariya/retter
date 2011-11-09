# coding: utf-8

module Retter::Page
  module ViewHelper
    include Retter::Stationery

    def entry_path(*args)
      case args.first
      when Date, Time
        entry_path_by_date(*args)
      when Retter::Entry
        entry_path_by_entry(args.first)
      else
        raise TypeError, "wrong argument type #{args.first.class} (expected Date, Time or Retter::Entry)"
      end
    end

    def article_path(*args)
      case args.first
      when Date, Time
        article_path_by_date_and_id(*args)
      when Retter::Entry::Article
        article_path_by_article(args.first)
      else
        raise TypeError, "wrong argument type #{args.first.class} (expected Date, Time or Retter::Entry::Article)"
      end
    end

    def render_disqus_comment_form(disqus_shortname = config.disqus_shortname)
      Haml::Engine.new(<<-HAML).render
#disqus_thread
  :javascript
    var disqus_shortname = '#{disqus_shortname}';

    (function() {
      var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
      dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
      (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
      HAML
    end

    def article_path_by_date_and_id(date, id)
      date.strftime("/entries/%Y%m%d/#{id}.html")
    end

    def article_path_by_article(article)
      article_path(article.entry.date, article.id)
    end

    def entry_path_by_date(date, id = nil)
      date.strftime('/entries/%Y%m%d.html') + (id ? "##{id}" : '')
    end

    def entry_path_by_entry(entry)
      entry_path(entry.date)
    end
  end
end
