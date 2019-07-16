# Jekyll Blog

Sample blog website built in Jekyll static site generator, using headless CMS Kentico Cloud as a content repository and
[jekyll-kentico plugin](https://github.com/RadoslavK/jekyll-kentico) for content and data import. 

Find live project [here](https://radoslavk.github.io/jekyll-blog/en-US/posts). **WIP**

## How to run

Steps 1 and 3 require administrator privileges.

1. Install [Ruby](https://www.ruby-lang.org/en/downloads/) (v2.6.3+) with DevKit and [RubyGems](https://rubygems.org/pages/download). You need to have MSYS2 on your system if you are using Windows and it can be installed via DevKit.
2. Clone or download the repository.
3. Install dependencies: `gem install jekyll jekyll-kentico bundler:2.0.1`
4. Install gems in source folder: `bundle install`
5. Create an account on [Kentico Cloud](https://app.kenticocloud.com/).
    1. Optionally you can create a new clean project.
6. Go to Project settings > API keys.
7. Set `project_id` in `_config.yml` to your Project ID from API keys page. 
8. Initialize Kentico Cloud sample content
    1. In your KC project open Settings, then Localization. Click `Default project language` and rename codename to `en-US`
    2. Create new language with codename `en-GB` 
    3. [Open KC Template Manager](https://kentico.github.io/cloud-template-manager/import-from-file)
    4. Copy your Content Management API key and Project Id
    5. Check 'Publish imported items'
    6. Import `KC_sample_content.zip`
9. Once the import is finished execute `bundle exec jekyll build` to build or `bundle exec jekyll serve` to build and run your site.

## Custom configuration

You can learn more on the [plugin's wiki](https://github.com/RadoslavK/jekyll-kentico/wiki).
