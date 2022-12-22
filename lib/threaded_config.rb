class ThreadedConfig
  extend ActiveSupport::PerThreadRegistry

  attr_accessor :silent

  def is_silent?
    silent
  end
end

# Silence blockchain writes, notifications & analytics throughout the app
ThreadedConfig.silent = false