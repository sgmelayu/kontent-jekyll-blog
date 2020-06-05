[![Build Status](https://api.travis-ci.com/Kentico/kontent-jekyll-blog.svg?branch=master)](https://travis-ci.com/Kentico/kontent-jekyll-blog)
[![Join the chat at https://kentico-community.slack.com](https://img.shields.io/badge/join-slack-E6186D.svg)](https://kentico-community.slack.com)
[![Stack Overflow](https://img.shields.io/badge/Stack%20Overflow-ASK%20NOW-FE7A16.svg?logo=stackoverflow&logoColor=white)](https://stackoverflow.com/tags/kentico-kontent)

# Jekyll Blog

Sample blog website built in Jekyll static site generator, using headless CMS Kentico Kontent as a content repository and
[kontent-jekyll plugin](https://github.com/Kentico/kontent-jekyll) for content and data import. 

Find live sample project [here](https://kentico.github.io/kontent-jekyll-blog/).

## How to run

Steps 1 and 3 require administrator privileges.

1. Install [Ruby](https://www.ruby-lang.org/en/downloads/) (v2.6.3+) with DevKit and [RubyGems](https://rubygems.org/pages/download). You need to have MSYS2 on your system if you are using Windows and it can be installed via DevKit. Choose 3rd option in the DevKit console installer to install MSYS2 and MINGW development toolchain.
2. Clone or download the repository.
3. Install dependencies: `gem install jekyll kontent-jekyll bundler:2.0.1` and confirm overriding the bundler version installed with Ruby env
4. Install gems in source folder: `bundle update`
5. Create an account on [Kentico Kontent](https://app.kenticocloud.com/).
    1. Optionally you can create a new clean project.
6. Go to Project settings > API keys.
7. Activate Management API
8. Set `project_id` in `_config.yml` to your Project ID from API keys page. 
9. Initialize Kentico Kontent sample content
    1. In your KK project open Settings, then Localization. Click `Default project language` and rename codename to `en-US`
    2. Create new language with codename `en-GB` 
    3. [Open KK Template Manager](https://kentico.github.io/kontent-template-manager/import)
    4. Copy your Content Management API key and Project Id
    5. Check 'Publish language variants after import'
    6. Upload `KK_sample_content.zip`
    7. Click on 'Import data'
9. Once the import is finished execute `bundle exec jekyll build` to build or `bundle exec jekyll serve` to build and run your site.

## Custom configuration

You can learn more on the [plugin's wiki](https://github.com/Kentico/kontent-jekyll/wiki).

## Feedback & Contributing

Check out the [contributing](https://github.com/Kentico/kontent-jekyll-blog/blob/master/CONTRIBUTING.md) page to see the best places to file issues, start discussions, and begin contributing.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kontent-Jekyll project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Kentico/kontent-jekyll-blog/blob/master/CODE_OF_CONDUCT.md).

![Analytics](https://kentico-ga-beacon.azurewebsites.net/api/UA-69014260-4/Kentico/kontent-jekyll-blog?pixel)
