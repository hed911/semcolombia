web: bundle exec puma -C config/puma.rb
worker: env TERM_CHILD=1 RESQUE_TM_TIMEOUT=7 QUEUE=* bundle exec rake resque:work
