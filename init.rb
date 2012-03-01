require 'redmine'
require 'dispatcher'

require File.dirname(__FILE__) + '/lib/redmine_projects_sorter'

Dispatcher.to_prepare :redmine_projects_sorter do
  require_dependency 'projects_helper'
  ProjectsHelper.send(:include, Redmine::Plugins::ProjectsSorter::ProjectsHelperPatch)
end

class << Project
  include Redmine::Plugins::ProjectsSorter::ProjectPatch::ClassMethods

  def project_tree(projects, &block)
    flatten(sortTree(construct(projects), :name)).each do |p, l|
      yield p, l
    end
  end
end

Redmine::Plugin.register :redmine_projects_sorter do
  name 'Redmine Projects Sort plugin'
  author 'Yusuke Nomura'
  description 'This is a plugin for sorting projects of Redmine'
  version '0.0.2'
  url 'https://github.com/yunomu/redmine_projects_sorter'
  author_url 'https://github.com/yunomu'
end
