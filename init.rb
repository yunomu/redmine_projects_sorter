require 'redmine'
require 'dispatcher'

require File.dirname(__FILE__) + '/lib/redmine_projects_sorter'

Dispatcher.to_prepare :redmine_projects_sorter do
  require_dependency 'projects_helper'
  ProjectsHelper.send(:include, Redmine::Plugins::ProjectsSorter) 
end

Redmine::Plugin.register :redmine_projects_sorter do
  name 'Redmine Projects Sort plugin'
  author 'Yusuke Nomura'
  description 'This is a plugin for sorting projects of Redmine'
  version '0.0.1'
  url 'http://yunomu.hatenablog.jp/'
  author_url 'https://github.com/yunomu'
end
