# Jekyll Blog

Sample blog website built in Jekyll static site generator, using headless CMS Kentico Cloud as a content repository and
[jekyll-kentico plugin](https://github.com/RadoslavK/jekyll-kentico) for content and data import. 

Find live project [here](https://radoslavk.github.io/jekyll-blog/). **WIP**

## How to run

1. Install [Ruby](https://www.ruby-lang.org/en/downloads/) (v2.6.3+) with DevKit and [RubyGems](https://rubygems.org/pages/download)
2. Clone or download the repository.
3. Create an account on [Kentico Cloud](https://app.kenticocloud.com/).
    1. Optionally you can create a new clean project.
4. Set `PROJECT_ID` and `DELIVERY_API_KEY` environment variables. You can find the keys under **Project settings > API keys** . `DELIVERY_API_KEY` is your primary secure key for content retrieval. It is required only if the secure access toggle is on.
5. Install dependencies: `gem install jekyll jekyll-kentico bundler:2.0.1`
6. Install gems in source folder: `bundle install`
7. Initialize Kentico Cloud sample content
    1. In your KC project open Settings, then Localization. Click `Default project language` and rename codename to `en-US`
    2. Create new language with codename `en-GB` 
    1. [Open KC Template Manager](https://kentico.github.io/cloud-template-manager/import-from-file)
    2. Check 'Publish imported items'
    3. Import `KC_sample_content.zip`
8. Execute `bundle exec jekyll build` to build or `bundle exec jekyll serve` to build and run your site.
