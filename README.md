# LAMP Vagrant

A LAMP stack with original Ubuntu / CentOS boxes for Vagrant that **just works and easy to customize**.

*Running with vagrant 1.9.1 and VirtualBox 5.1.14 r112924 (Qt5.6.2) Windows | Ubuntu 14.04*

*With example configuration file, Vagrant will install an Ubuntu 14.04 machine which contains Apache 2, PHP 5.6, Postgresql 9.5 and Xdebug*

### 1. Run

**Preparing:**
- Install [Virtualbox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://www.vagrantup.com/downloads.html).
- This Vagrant stack requires `vagrant-vbguest` plugin for fully CentOS supports.
```shell
vagrant plugin install vagrant-vbguest
```
- Clone this repository or download latest version [here](https://codeload.github.com/dumday/lamp-vagrant/zip/master)
```
git clone https://github.com/dumday/lamp-vagrant.git
```
- After clone this repository, rename `config/default.yaml.example` to `config/default.yaml`

**Running:**
```shell
vagrant up
```
Wait for everything loaded then navigate to [http://1.1.0.254](http://1.1.0.254) to see if it works

To restart the VM
```shell
vagrant reload
```
To shut down the VM
```shell
vagrant halt
```

More syntax can be found in their [Vagrant document](https://www.vagrantup.com/docs/cli/).

Available running sites with example configuration file are

- 1.1.0.254 A generic test site, with php info can be found at [http://1.1.0.254/phpinfo.php](http://1.1.0.254/phpinfo.php)
- 1.1.0.100 Site running with source in `html/test` folder and settings in `config/apache2/sites/test.conf`

### 2. Configuration

_**Notice: Each yaml file in `config` folder is used for its own machine. Example: `config/default.yaml` is used for machine named `default`**_

All configuration should be placed in `config/default.yaml` file

**OS and version** are important settings that will be used for provisioning proccess (Example: os: "CentOS", versionL "14")

**Dependencies:** Is a list of packages to be installed, default ones are Apache 2, PHP 5.6 ... A list of available packages can be found in [package list](PACKAGES.md) file.

**Copy:** is a list of file to be copied to VM, all those files should locates in `config/copy` folder. Local file path should represent the actual file path in VM machine. Example: `config/copy/etc/php5/php.ini` in local machine will be copied to `/etc/php5/php.ini` in VM.

**IP settings:**
- ip_prefix: is the first part of ips, `127.0.0.1` has prefix `127.0.0`
- private_network_ips: is a list of second parts of ips, `127.0.0.1` has postfix `1`
- ultilites_ip: is the ip used for ultilites site

**Synced folders:** Is a list of folders from local machine to be synced with VM

### 3. Other settings

-	All sites settings are located in `config/apache2/sites`
-	Custom apache settings should be placed in `config/apache2/lamp-vagrant.conf`
- All provider settings should be edited in `config/Providers.rb`

Other hack-around can be done with a little knowlegde of Vagrant, can be found in their [Vagrant document](https://www.vagrantup.com/docs/).

### 4. Xdebug with netbeans

*Example with running site on 1.1.0.100*

- Config xdebug.remote_host to "1.1.0.100" in local machine `php.ini` file like

```
zend_extension = "path/to/xdebug/dll/or/so"
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_host="1.1.0.100"
xdebug.remote_port=9000
xdebug.max_nesting_level=300
```

- Open project properties in netbeans, in tab `Run Configuration` change **Project URL** to `http://1.1.0.100`
- Click `Advanced`, then `Do not open web browser`, in **server path** fill `/var/www/html/test/`
- Fill `path/to/lamp-vagrant/html/test` in **Project Path**
- Save


Any contributions are welcomed and I am pleased to help you with all of your [issues](https://github.com/dumday/lamp-vagrant/issues).

Best regards,
Hung.

:beer: :beer: :beer:
