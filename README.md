Product Management API
==
CRUD operations for any kind of products on an online store.
​
Architecture
==
Ruby on Rails, Postgres database,
deployable on Heroku.
​
Installation
==
git clone git@github.com:saurabhsg83/product_management.git
cd product_management
bundle install
heroku create ()
​
Deployment
==
On heroku:
1. ./deploy.sh
2. heroku run rake db:seed (only for the first time)
