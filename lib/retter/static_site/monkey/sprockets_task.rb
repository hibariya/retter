require 'rake/sprocketstask'

class Rake::SprocketsTask
  private

  # avoid logging to stderr
  def with_logger
    yield
  end
end
