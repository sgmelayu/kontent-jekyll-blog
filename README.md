# Jekyll Blog

Sample blog website built in Jekyll static site generator, using headless CMS Kentico Cloud as a content repository and
[jekyll-kentico plugin](https://github.com/RadoslavK/jekyll-kentico) for content and data import. 

Find live project [here](https://radoslavk.github.io/jekyll-blog/). **WIP**

## How to run

1. Create an account on [Kentico Cloud](https://app.kenticocloud.com/).
    1. Optionally you can create a new clean project.

2. Set `PROJECT_ID` and `CM_API_KEY` environment variables.
`CM_API_KEY` is your primary secure key for content retrieval. It is required only if the secure access toggle is on.
You can find the project id and secure access toggle in the project settings under API Keys in Development section.

3. Run `content-initializer/initializer.rb` script to initialize your Kentico Cloud content. 

4. Clone or download the repository.

5. Execute `bundle exec jekyll build` to build or `bundle exec jekyll serve` to build and run your site.
