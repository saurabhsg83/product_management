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
git clone git@github.com:saurabhsg83/product_management.git <br>
cd product_management <br>
bundle install <br>
heroku create
​
Deployment
==
On heroku: <br>
1. ./deploy.sh <br>
2. heroku run rake db:seed (only for the first time)
