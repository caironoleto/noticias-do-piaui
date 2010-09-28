# Notícias do Piauí

This project is a way to find and show news in a different way.

# How to run

First, you need install the following gems:

  - rails (2.3.8);
  - delayed_job;
  - feedzirra;
  - nokogiri
  - will_paginate.

Second, the basic:

    rake db:migrate

And finally:

    ruby script/server

# Explain

Notícias do Piauí works basically on find news from feeds, and updates the content using nokogiri accessing the urls from the feed.

To fetch news, you need run *script/runner "Domain.all.each{|d| d.process}"* and *script/delayed_job start"

Finally, you can start the websocket run *ruby lib/websocket.rb start*

# How to contribute

If you find what looks like a bug:

1. Check the GitHub issue tracker to see if anyone else has had the same issue. http://github.com/caironoleto/noticias-do-piaui/issues/;

2. If you don’t see anything, create an issue with information on how to reproduce it.

If you want to contribute an enhancement or a fix:

1. Fork the project on github.
http://github.com/caironoleto/noticias-do-piaui/

2. Make your changes with *tests*.

3. Commit the changes without making changes to the Rakefile, VERSION, or any other files that aren’t related to your enhancement or fix

4. Send a pull request.