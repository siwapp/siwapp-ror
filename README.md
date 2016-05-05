#Siwapp

[![Build Status](https://travis-ci.org/siwapp/siwapp.svg?branch=master)](https://travis-ci.org/siwapp/siwapp)

Online Invoice Management

## Howto Install on Heroku
First create a new App in your [heroku](http://www.heroku.com) account.
Create a directory on your local computer and log in to your heroku account:

    $ heroku login

Now clone the siwapp repository:

    $ git clone git@github.com:siwapp/siwapp.git
    $ cd siwapp

Add a remote repository:

    $ heroku git:remote -a your-app-name

Probably you should remove first the postgresql addon, and then create a mysql:

    $ heroku addons:destroy heroku-postgresql
    $ heroku addons:create cleardb:ignite
    $ heroku config | grep CLEARDB_DATABASE_URL

The last commands gives you the DATABASE_URL, which you should set with the following command.
Notice you must change mysql to mysql2

    $ heroku config:set DATABASE_URL='mysql2://adffdadf2341:adf4234@us-cdbr-east.cleardb.com/heroku_db?reconnect=true'

Push the code to heroku:

    $ git push heroku master

Setup database:

    $ heroku run rake db:setup

Create an user to log in:

    $ heroku run rake siwapp:user:create['myuser','myemail@mydomain.com','mypassword']

Finally if you want the recurring invoices to be generated automatically, you have to setup the heroku scheduler addon:

    $ heroku addons:create scheduler:standard
    $ heroku addons:open scheduler

Add a new job, and put "rake siwapp:generate_invoices"

That's it! You can enjoy siwapp now entering on your heroku app url.
