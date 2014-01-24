worker_processes 4

working_directory "/var/www/top5" # available in 0.94.0+

listen "/var/www/top5/tmp/unicorn.top5.sock", :backlog => 64
listen 8080, :tcp_nopush => true

timeout 30

pid "/var/www/top5/tmp/pids/unicorn.top5.pid"

stderr_path "/var/www/top5/log/unicorn.stderr.log"
stdout_path "/var/www/top5/log/unicorn.stdout.log"

preload_app true

user 'nginx'
