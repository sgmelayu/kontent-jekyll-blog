# Jekyll Blog

Sample blog website built in Jekyll static site generator, using headless CMS Kentico Cloud as a content repository and
[jekyll-kentico plugin](https://github.com/RadoslavK/jekyll-kentico) for content and data import. 

Find live project [here](https://radoslavk.github.io/jekyll-blog/). **WIP**

## How to run

1. Install [Ruby](https://www.ruby-lang.org/en/downloads/) (v2.6.3+) with DevKit and [RubyGems](https://rubygems.org/pages/download)
2. Clone or download the repository.
3. Create an account on [Kentico Cloud](https://app.kenticocloud.com/).
    1. Optionally you can create a new clean project.
4. Set `PROJECT_ID`, `CM_API_KEY` and `DELIVERY_API_KEY` environment variables. You can find the keys under **Project settings > API keys** . `DELIVERY_API_KEY (Content Management API)` is your primary secure key for content retrieval. It is required only if the secure access toggle is on. `CM_API_KEY (Content Management API)` is used for initializing the sample content for your project.
5. Install dependencies: `gem install jekyll jekyll-kentico bundler:2.0.1`
6. Install gems in source folder: `bundle install`
7. Initialize Kentico Cloud sample content: `ruby sample-content/initializer.rb`.
8. Execute `bundle exec jekyll build` to build or `bundle exec jekyll serve` to build and run your site.
