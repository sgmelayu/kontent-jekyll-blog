require 'net/http'
require 'json'
require 'date'
require 'fileutils'

POSTS_DIR = '_posts'
PROJECT_ID = '1d0ae542-e596-00a1-b8c0-4a112a8d8c0c'
DELIVERY_URL = "https://deliver.kenticocloud.com/#{PROJECT_ID}/items"

class Post
  attr_reader :id, :date, :author, :title, :content

  def initialize(id, date, author, title, content)
    @id = id
    @date = date
    @author = author
    @title = title
    @content = content
  end
end

def to_post(post)
  "---
layout: post
title: #{post.title}
author: #{post.author}
---
#{post.content}"
end

def get_posts
  uri = URI(DELIVERY_URL)

  response = Net::HTTP.get(uri)
  parsed = JSON.parse(response)
  items = parsed['items']

  posts = []

  items.each do |item|
    id = item['system']['id']
    elements = item['elements']

    date = Date.parse elements['date']['value']
    author = elements['author']['value']
    title = elements['title']['value']
    content = elements['content']['value']

    post = Post.new(id, date, author, title, content)

    posts << post
  end

  posts
end

module Jekyll
  class FetchDataCommand < Jekyll::Command
    class << self
      def init_with_program(program)
        program.command(:kentico) do |c|
          c.syntax 'kentico'
          c.description 'Import data from Kentico Cloud'

          c.action do
            FileUtils.rm_r POSTS_DIR if File.directory? POSTS_DIR
            Dir.mkdir POSTS_DIR

            get_posts.each do |post|
              path = "#{POSTS_DIR}/#{post.date.to_s}-#{post.id}.md"
              raw_post = to_post(post)

              File.open(path, 'w') do |file|
                file.write(raw_post)
              end
            end
            Commands::Build.process({})
          end
        end
      end
    end
  end
end