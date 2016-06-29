module Jekyll
  class LevelCloud < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      level_array = []
      site = context.registers[:site]
      site.posts.docs.each do |post|
        if !post.data['level'].nil? &&  !level_array.include?(post.data['level'])
          level_array.push(post.data['level'])
        end
      end

      tagcloud = "<ul>"
      level_array.each do |level|
        tagcloud << "<li><a href='#{site.baseurl}/level_list/#{level}/index.html'>#{level}</a></li>"
      end
      tagcloud << "</ul>"
      "#{tagcloud}"
    end
  end

  class LevelItem < Liquid::Block

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      level_array = []
      site = context.registers[:site]
      site.posts.docs.each do |post|
        if !post.data['level'].nil? &&  !level_array.include?(post.data['level'])
          level_array.push(post.data['level'])
        end
      end
      context['levels'] = level_array
      return super
    end
  end

  class LevelCloudPage < Page
    def initialize(site, base, dir)
      @site = site
      @base = base
      @dir  = dir
      @name = 'index.html'
      self.process(name)
      self.read_yaml(File.join(base, '_layouts'), 'level_list.html')
      self.data['title'] = "レベル一覧"
      self.data['posts'] = site.documents
    end
  end

  class LevelCloudPageGenerator < Generator
    safe true
    def generate(site)
      site.pages << LevelCloudPage.new(site, site.source, 'level_list')
    end
  end

  class LevelPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir  = dir
      @name = 'index.html'
      self.process(name)

      level_list = []
      site.posts.docs.each do |post|
        if post.data['level'] == tag
          level_list.push(post)
        end
      end

      self.read_yaml(File.join(base, '_layouts'), 'tag.html')
      self.data['title'] = "Tag:#{tag}"
      self.data['posts'] = level_list
      self.data['title_detail'] = 'レベル「' + tag + '」' + 'がつけられた記事'
    end
  end

  class LevelPageGenerator < Generator

    safe true

    def generate(site)
      level_array = []
      site.posts.docs.each do |post|
        if !post.data['level'].nil? &&  !level_array.include?(post.data['level'])
          level_array.push(post.data['level'])
        end
      end
      level_array.each do |level|
        site.pages << LevelPage.new(site, site.source, File.join('level_list', level), level)
      end
    end
  end
end

Liquid::Template.register_tag('level_list', Jekyll::LevelCloud)
Liquid::Template.register_tag('levelitem', Jekyll::LevelItem)
