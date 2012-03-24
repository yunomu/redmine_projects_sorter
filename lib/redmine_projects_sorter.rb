module Redmine
  module Plugins
    module ProjectsSorter
      module ProjectsHelperPatch
        def self.included(base)
          base.send(:include, InstanceMethods)
          base.class_eval do
            alias_method_chain :render_project_hierarchy, :sort
          end
        end

        module InstanceMethods
          include Redmine::Plugins::ProjectsSorter

          def render_project_hierarchy_with_sort(projects)
            #render_project_hierarchy_without_sort(projects)
            out(sortTree(construct(projects), :ord)).html_safe
          end

          private
          def out(ts, depth = 0)
            return "" if ts.size == 0
            s = ""
            s << "<ul class='projects #{ depth == 0 ? 'root' : nil}'>\n"
            ts.each {|t|
              project = t[0]
              classes = (depth == 0 ? 'root' : 'child')
              s << "<li class='#{classes}'><div class='#{classes}'>" +
                    link_to_project(project, {}, :class => "project #{User.current.member_of?(project) ? 'my-project' : nil}")
              s << "<div class='wiki description'>#{textilizable(project.short_description, :project => project)}</div>" unless project.description.blank?
              s << "</div></li>\n"
              s << out(t[1], depth + 1)
            }
            return s + "</ul>\n"
          end
        end
      end

      module ProjectPatch
        module ClassMethods
          include Redmine::Plugins::ProjectsSorter

          private
          def flatten(ts, d = 0)
            return [] if ts.size == 0
            n, cs = ts.shift
            [[n, d]] + flatten(cs, d+1) + flatten(ts, d)
          end
        end
      end

      private
      def subset?(p, c)
        p.lft < c.lft && c.rgt < p.rgt
      end

      def construct(projects)
        return [] if projects.size == 0
        ret = []
        p = projects.shift
        as = projects.select {|c| subset?(p, c) }
        bs = projects.select {|c| !subset?(p, c) }
        ret << [p, construct(as)]
        ret + construct(bs)
      end

      def sortTree(ts, key)
        (ts.map {|t|
          [t[0], sortTree(t[1], key)]
        }).sort {|a, b|
          a[0].send(key) <=> b[0].send(key)
        }
      end
    end
  end
end
