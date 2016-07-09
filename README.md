What's ?
===============
chef で使用する Nginx の cookbook です。

Usage
-----
cookbook なので berkshelf で取ってきて使いましょう。

* Berksfile
```ruby
çsource "https://supermarket.chef.io"

cookbook "nginx", git: "https://github.com/bageljp/cookbook-nginx.git"
```

```
berks vendor
```

#### Role and Environment attributes

* sample_role.rb
```ruby
override_attributes(
  "nginx" => {
    "user" => "nginx",
    "group" => {
      "add" => "nginx"
    },
    "log_rotate" => "31",
    "conf" => {
      "template_dir" => "conf_" + Chef::Config[:node_name].gsub(/[0-9]*$/, '')
    },
    "ssl" => {
      "enable" => true,
      "link_dir" => "2014",
      "server_key" => "",
      "server_crt" => ""
    }
  }
)
```

Recipes
----------

#### nginx::default
nginx のインストールとサービス起動の設定など。

#### nginx::conf
nginx の各種設定ファイル用レシピ。  
ちょっと特殊で、 ``templates/default/['nginx']['conf']['template_dir']`` にある設定ファイル一式を適用します。  
こうなってる理由は案件毎にそもそも設定ファイルの数が違うので一々レシピに手を入れる必要が生じたため。

#### nginx::htpasswd
htpasswd の作成。

Attributes
----------

主要なやつのみ。

#### nginx::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>['nginx']['install_flavor']</tt></td>
    <td>yum or rpm</td>
    <td>通常はyumで、rpmbuild済みのrpmを入れたい場合はrpmを使用。</td>
  </tr>
  <tr>
    <td><tt>['nginx']['user']</tt></td>
    <td>string</td>
    <td>nginx の起動ユーザ。</td>
  </tr>
  <tr>
    <td><tt>['nginx']['group']['add']</tt></td>
    <td>array string</td>
    <td>nginx の起動ユーザをグループのメンバに含める。起動ユーザとデプロイユーザが異なる場合とかに。</td>
  </tr>
  <tr>
    <td><tt>['nginx']['ssl']['link_dir']</tt></td>
    <td>string</td>
    <td>sslの鍵や証明書ファイルのシンボリックリンク先。2014、2015などssl更新タイミングで切り替えると良い。</td>
  </tr>
</table>

