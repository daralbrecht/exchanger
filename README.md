# Leadfeeder job interview assignment

# Installation
* Clone the repo: `git clone https://github.com/daralbrecht/exchanger`
* Install Ruby 2.4.2
* Install Bundler and dependencies:
```
cd exchanger
gem install bundler
bundle install
```
* Create database and run migrations:
```
rake db:create db:migrate
```

# Usage
For tests you can run standard
```
rspec
```
which will also generate coverage data under `/coverage` directory.

For development you can use guard tool:
```
guard
```
It will run rubocop inspections whenever you update some file. Also it will run specs on file changes.
Additional it will run `bundle` whenever you modify something in Gemfile.

To start console run:
```
bin/console
```
There you can use classes, for example:
```
ConvertUsdToEur.call(80, '2017-10-11')
```

Rake task for automatically updating rates in database:
```
rake ecb:import_rates
```
