

# Archive repository - NO LONGER FUNCTIONAL WITH CURRENT EMONCMS VERSION 

**Emoncms Vagrant development box config**

Copy `settings.yml.sample` to `settings.yml` and modify the reference to where you have emoncms checked out.

Then run `vagrant up` and voila!

* Based on Ubuntu 14.04 with PHP 5.6
* Accessible on `localhost:8080` on the host machine
* Including xDebug for debugging pre-configured
* Bundled with [composer](https://getcomposer.org/)
* Redis enabled
