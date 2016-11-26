.. _travis-gitpage:

###################################################################
Automatically publish Tinkerer bld output to GitHub with Travis CI
###################################################################

.. author:: default
.. categories:: github, travis-ci
.. tags:: github, travis-ci

*******
Perface
*******

I saw a comment from `a web <https://www.notionsandnotes.org/tech/web-development/pelican-static-blog-setup.html>`_ 
that talks about auto deployment with Travis CI

    As an aside, you can also use GitHub Pages for hosting, which is free, 
    and then integrate it with Travis-CI to automatically publish the blog 
    (basically run pelican to generate the output and push the changes back online) 
    in order to decouple the actual writing of blog posts from the publishing part.

    The above also has the advantage of enabling a history of changes done 
    (both for the articles themselves and the output), as well as simplifying things 
    if you want to have guest posts and so on.
          
That's the place where I start to explore Travis CI.

**********
Travis CI
**********

Travis CI part isn't hard to figure out. I referenced the following articles to get
me started with this great tool, particularly with Sphinx-doc:

    - `learn-travis <https://github.com/dwyl/learn-travis>`_
    - `Sphinx-doc repo .travis.yml <https://github.com/sphinx-doc/sphinx/blob/master/.travis.yml>`_
    - `Have Travis-CI test your Sphinx docs <https://coderwall.com/p/wws2uq/have-travis-ci-test-your-sphinx-docs>`_

The basic idea of Travis CI is quite simple. Once you commit something, it will
trigger Travis CI to clone your repository, and run the command you specified in 
``.travis.yml`` and then it will tell you the result of this commit (i.e. 
Whether you pass all the test specified in ``.travis.yml``)

******************
Work with Tinkerer
******************

.. note::

    Tinkerer is built upon Sphinx-doc. Any Sphinx-doc-ish tool should have similar
    setup when work with Travis CI.

The setup for me is that I don't use ``gh-pages``. Instead, I directly use ``master``
branch as the source for my github page. The reason is that Tinkerer will generate
``index.html`` directly inside root directory of the repo, which will redirect the 
visit to ``index.html`` under ``blog``. ``blog`` is the default output directory.

Here are the tutorials I referenced. However, all of them talk about working with ``gh-pages``:

    - `Auto-deploying built products to gh-pages with Travis <https://gist.github.com/domenic/ec8b0fc8ab45f39403dd>`_
    - `Automatically Publish Javadoc to GitHub Pages with Travis CI <https://benlimmer.com/2013/12/26/automatically-publish-javadoc-to-gh-pages-with-travis-ci/>`_

The first link above offers a framework of how you should get everything working and 
the second link's bottom script offers some intuition.

I'm not going to redo the work. I just want to point out something you need to be careful:

- **DO NOT using personal token.** As mentioned by the first link, using a GitHub personal
  access token offers the full access to all your git repo. That's a very high risk.

- **Be Careful with Public/Private.** You need to use the Travis client to encrypt 
  the *private* ssh key and upload the corresponding *public* ssh key to your repository.

- **Don't put passphrase for your ssh key.** If you do, Travis CI will ask for the passphrase
  during the automation process, which will lead to build hang. If this happens, regenerate
  the ssh key.

********************
Decode the script
********************

============
.travis.yml
============

This is my `.travis.yml <https://github.com/xxks-kkk/blog/blob/master/.travis.yml>`_::

    language: python
    python:
      - "2.7"

    install:
      - pip install tinkerer
      - pip install sphinxjp.themes.tinkerturquoise

    script:
      - tinker -b

    env:
      global:
      - ENCRYPTION_LABEL: "8c1ec1f6b778"
      - COMMIT_AUTHOR_EMAIL: "ferrishu3886@gmail.com"

    after_success:
      - bash ./deploy.sh

    notifications:
      email:
        recipients:
          - ferrishu3886@gmail.com
        on_success: change # option [alway|never|change]
        on_failure: always

- ``install`` section asks Travis CI to install the necessary packages to build our 
  doc.

- ``script`` section contains our doc build command.  

- ``env`` section contains environment variables required for our ``deploy.sh``. They
  are used to authorize a user on Travis CI to make ``git clone``, ``git push``, etc.

- ``after_success`` tells Travis CI what to do once the ``script`` section is done 
  successfully.

- ``notifications`` customize the email notification.

============
deploy.sh
============

For `deploy.sh <https://github.com/xxks-kkk/blog/blob/master/deploy.sh>`_ is easy to
understand if you take a look at the Travis CI log for a build. 

Travis CI first perform basic the environment setup. Then, it clones the git repository.
Next, it builds our doc. If the build is success, it executes our ``deploy.sh``.

Inside ``deploy.sh``, the main idea is to first clone the same repo (i.e. ``travis-dup``) 
and copy the bld output pages (under ``/xxks-kkk/blog/blog``) to the bld directory 
of the same repo we just cloned (i.e. ``travis-dup/blog``). If there is nothing 
changed in the bld output pages, we exit. Else, we commit the changes and 
use the authencation we just added (i.e. ``ssh-add travis``) and push the change to the repo.

To keep it simpler, you can imagine Travis CI is a remote server that you can do anything you
want. Thus, we can let bld result to be pushed to our repo by asking user (i.e. travis) from 
the remote server to do so. 


.. include:: /comments.rst