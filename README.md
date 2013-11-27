# Redmine Responsibility List plugin

Plugin which enables access to responsibility list of all projects in redmine in HTML & in JSON.

# Requirements

Developed & tested on Redmine 2.3.3.

# Installation

1. Go to your Redmine installation's plugins/ directory.
2. `git clone http://github.com/efigence/redmine_landing_page`
3. Go back to root directory.
4. Restart Redmine.

# Configuration

Visit Administration -> Plugins. Afterwards, click on `Configure` link next to the plugin name.

Here you should define:

* role titles, which will be seen as headers/keys on responsibility list
* redmine roles which will be assigned to each title
* custom field of boolean type assigned to projects which will be seen on the list
* authorization key which will provide access to list in JSON
* redmine groups, which will have access to responsibility list

The default settings are:


    'Project Manager' => ['Project Manager']
    'Architect'       => ['Application architect']
    'Vice architect'  => ['Vice-Architect']
    'Developers'      => ['Developer']
    'Front End'       => ['Frontend Developer']

    Authorization key: 123456

# Usage

To see the responsibility list, simply click on its link seen on top menu.

Responsibility list provides separate lists for open, closed & archived projects.

To get responsibility list in JSON, request its URL with HTTP Header 'Authorization' set to the key defined in settings, for example:

    curl --header "Authorization: 123456" http://your.host.with.port/responsibility_list.json


