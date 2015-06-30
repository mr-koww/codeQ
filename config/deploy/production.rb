# server-based syntax
# ======================

server '85.143.216.241', user: 'deployer', roles: %w{app db web}, primary: true

# role-based syntax
# ==================

role :app, %w{deployer@85.143.216.241}
role :web, %w{deployer@85.143.216.241}
role :db, %w{deployer@85.143.216.241}

set :rails_env, :production
set :stage, :production

# Global options
# --------------
set :ssh_options, {
   keys: %w(/Users/mr-koww/.ssh/id_rsa),
   forward_agent: true,
   auth_methods: %w(publickey password),
   port: 5503
}
