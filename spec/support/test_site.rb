require 'fileutils'
require 'tmpdir'

module Retter::TestSite
  class << self
    def tmpdir
      @tmpdir ||= Pathname(Dir.mktmpdir).tap {|dir|
        at_exit do
          FileUtils.remove_entry_secure dir.to_path
        end
      }
    end

    def skels_dir
      @skels_dir ||= tmpdir.join('skels')
    end

    def sites_dir
      @sites_dir ||= tmpdir.join('sites')
    end

    def generate_skel(name)
      FileUtils.mkdir_p skels_dir

      Dir.chdir skels_dir do
        skel_dir = skels_dir.join(name)
        result   = Retter::ExampleHelper.invoke_retter('new', skel_dir, retter_root: '')

        raise result.inspect unless result.status.success?

        Dir.chdir name do
          yield skel_dir if block_given?
        end
      end
    end

    def create(skel_name)
      site_dir = sites_dir.join(skel_name)

      FileUtils.mkdir_p sites_dir
      FileUtils.cp_r skels_dir.join(skel_name), site_dir

      if block_given?
        Dir.chdir site_dir do
          yield site_dir
        end
      else
        site_dir
      end
    ensure
      FileUtils.rm_r site_dir if block_given?
    end
  end
end
