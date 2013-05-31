![Built in Manchester](http://i.imgur.com/qxeqjiF.png)

## Roll out a "Built in" for your own city
After being inspired by [Built in London](http://www.builtinlondon.co) to design a website to showcase great local companies, I wanted to create a version for [Manchester](http://www.manchester.gov.uk) - it's called [Built in Manchester](http://builtinmcr.com). Now I have open sourced the engine behind it (aka **Built in** engine) so you can quickly roll one for your own city in a few minutes.

### Getting started
The software is designed using [Ruby on Rails](http://rubyonrails.org) with [MySQL](http://www.mysql.com) as a database. You'll need Ruby (preferably 1.9.3), Ruby on Rails (preferably 3.2), [Bundler](http://gembundler.com), MySQL and an [Amazon Web Services](http://aws.amazon.com) account (it uses S3 for image hosting).

It's really simple to get your own version of **Built in** setup:

First of all, download this repository and navigate to the `builtin` folder.
```
$ git clone git://github.com/bih/builtin.git
```

Second, edit the Rails database file with your MySQL database information.
```
/config/database.yml
```

Thirdly, you'll need to download all dependencies using [Bundler](http://gembundler.com).
```
$ bundle install
```

Before you continue, you'll need two things. One is to have your [access keys](https://console.aws.amazon.com/iam/home?#security_credential) for Amazon Web Services. Second is to decide what the username/password combination will be to access your admin panel.

Fourthly, use Rake and Rails Migration to install your database. Note how we've prepended `S3_KEY`, `S3_SECRET`, `ADMIN_USERNAME` and `ADMIN_PASSWORD`. **Please fill these in**. This tells Rails information it needs to run.
```
$ S3_KEY="" S3_SECRET="" ADMIN_USERNAME="test" ADMIN_PASSWORD="test" rake db:migrate
```

Now you're all setup. Just prepend those keys to any Rails-like commands (i.e. `server`) and it should be fine. When deploying to [Heroku](http://www.heroku.com) or any other cloud hosting provider, these are also known as environment variables. I would **not** recommend hard coding the keys in your codebase for security reasons.
```
$ S3_KEY="" S3_SECRET="" ADMIN_USERNAME="test" ADMIN_PASSWORD="test" bundle exec rails server
```
### Post-installation
Once you have completed the installation above, you're ready to go live. The admin panel for your website can be found at [http://localhost:3000/admin](http://localhost:3000/admin) once you run the `rails server` command.

If you'd like to add startups manually, you will need to submit and approve it through the admin panel manually. I won't go through the admin panel as I have designed it to be intuitive. You're free to open a issue through GitHub if you're having problems.

### Contributing
I would love to see **Built in** used to showcase many exciting startups across many cities worldwide. As a small weekend hack, I know the software has plenty of room for improvement and I would happily accept any pull requests.
