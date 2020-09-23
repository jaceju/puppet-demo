# Puppet 練習

## 需求

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

以上套件在 Mac 上可以用 `brew cask install vagrant virtualbox` 來安裝。

## 步驟

### 用 Vagrant 建立 Server 與 Agent

首先在專案目錄下執行：

```bash
$ git clone https://github.com/jaceju/puppet-demo-with-vagrant.git puppet-demo
$ cd puppet-demo
$ vagrant up
```

這樣會建立 `server` 與 `agent` 兩台虛擬機；它們分別可以用以下指令來登入：

```
$ vagrant ssh server
$ vagrant ssh agent
```

建議開兩個 terminal 視窗來分別登入，以利進行後面的步驟。

登入到 server ，執行以下指令來查看要求 CA 的 agent 有哪些：

```bash
$ sudo /opt/puppetlabs/bin/puppetserver ca list
Requested Certificates:
    puppet-agent.example.com       (SHA256)  63:A9:54:DD:40:98:70:08:48:81:D1:22:33:4E:F3:DB:CE:C9:74:AB:0C:AB:E0:53:15:2C:3A:93:40:01:53:03
```

對所有的 request 做簽證：

```bash
$ sudo /opt/puppetlabs/bin/puppetserver ca sign --all
```

接下來登入 agent ，執行下列指令以確認 server 已經能和 agent 溝通：

```
$ sudo /opt/puppetlabs/bin/puppet agent --test
Info: csr_attributes file loading from /etc/puppetlabs/puppet/csr_attributes.yaml
Info: Creating a new SSL certificate request for puppet-agent.example.com
Info: Certificate Request fingerprint (SHA256): 63:A9:54:DD:40:98:70:08:48:81:D1:22:33:4E:F3:DB:CE:C9:74:AB:0C:AB:E0:53:15:2C:3A:93:40:01:53:03
Info: Downloaded certificate for puppet-agent.example.com from https://puppet-server.example.com:8140/puppet-ca/v1
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for puppet-agent.example.com
Info: Applying configuration version '1600831730'
Notice: Applied catalog in 0.02 seconds
```

要注意的是， agent 要啟動才會發 CA request 給 server 。

### 測試 Agent

接下來要驗證我們的 server 和 agent ，這裡用安裝 apache 來做例子。

在 server 端執行：

```bash
$ sudo /opt/puppetlabs/bin/puppet module install puppetlabs-apache
Notice: Preparing to install into /etc/puppetlabs/code/environments/production/modules ...
Notice: Downloading from https://forgeapi.puppet.com ...
Notice: Installing -- do not interrupt ...
/etc/puppetlabs/code/environments/production/modules
└─┬ puppetlabs-apache (v5.5.0)
  ├─┬ puppetlabs-concat (v6.2.0)
  │ └── puppetlabs-translate (v2.2.0)
  └── puppetlabs-stdlib (v6.4.0)
```

然後執行以下指令來新增 manifest 檔案：

```bash
$ echo "node 'puppet-agent.example.com' {
  class { 'apache': }             # use apache module
  apache::vhost { 'puppet-agent.example.com':  # define vhost resource
    port    => '80',
    docroot => '/var/www/html'
  }
}
" | sudo tee /etc/puppetlabs/code/environments/production/manifests/site.pp
```

回到 agent ，再測試一次：

```bash
$ sudo /opt/puppetlabs/bin/puppet agent --test
```

應該會出現一大串跟 Apache 有關的資訊，這麼一來就 puppet agent 的驗證就完成了。

最後你可以參考[《 Puppet 從入門就放棄》](https://shazi7804.gitbooks.io/puppet-manage-guide/)的介紹來進一步學習 Puppet 。

## 踩雷

### Server 記憶體問題

因為分配給 server 的記憶體只有 `1G` ，所以 puupetserver 的記憶體分配不能太高，但也不能太低，避免跑不起來，例如 `512m` 。

```ini
JAVA_ARGS="-Xms512m -Xmx512m -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger"
```

### hostname 問題

執行 `sudo /opt/puppetlabs/bin/puppetserver ca list` 出現以下錯誤：

```
Fatal error when running action 'list'
  Error: Failed connecting to https://puppet:8140/puppet-ca/v1/certificate_statuses/any_key
  Root cause: Failed to open TCP connection to puppet:8140 (getaddrinfo: Temporary failure in name resolution)
```

這是因為 puppetserver 在本地端是用 `puppet` 這個 hostname 來打 API ，所以要在 `/etc/hosts` 內加入 `puppet` ：

```
192.168.0.103   puppet-server.example.com puppet
```

## 參考文章：

- [[教學] 使用 Vagrant 練習環境佈署](http://gogojimmy.net/2013/05/26/vagrant-tutorial/) 。
- [PUPPET 6.0.2 : INSTALL ON UBUNTU 18.04 (BIONIC)](https://www.bogotobogo.com/DevOps/Puppet/Puppet6-Install-on-Ubuntu18.0.4.php)
- [How To Install Puppet 6.x On Ubuntu 18.04 / Ubuntu 16.04 & Debian 9](https://www.itzgeek.com/how-tos/linux/ubuntu-how-tos/how-to-install-puppet-on-ubuntu-16-04.html)
- [How to Install Puppet Master and Client on Ubuntu 16.04](https://medium.com/@Alibaba_Cloud/how-to-install-puppet-master-and-client-on-ubuntu-16-04-9f8c241125df)
- [Puppet 簡單入門 - 安裝篇](https://pylixm.cc/posts/2019-11-26-Puppet-tutorial-two.html)
- [Puppet Master Server 安裝](https://shazi7804.gitbooks.io/puppet-manage-guide/content/basic/install-master-server.html)
