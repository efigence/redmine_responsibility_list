# Redmine Responsibility List plugin

Plugin which enables access to responsibility list of redmine projects in HTML & JSON formats.

It also creates a listing of project membership history (saves information about roles which have been added to project members and which were taken away).

# Requirements

Developed and tested on Redmine 2.3.3 & 2.4.3.

# Installation

1. Go to your Redmine installation's plugins/ directory.
2. `git clone http://github.com/efigence/redmine_responsibility_list`
3. Go back to root directory.
4. `rake redmine:plugins:migrate RAILS_ENV=production`
5. Restart Redmine.

# Configuration

Visit Administration -> Plugins. Afterwards, click on `Configure` link next to the plugin name.

Here you must define:

* role titles, which will be seen as headers/keys on responsibility list
* redmine role (or roles) which will be assigned to each title
* optional custom field of boolean type assigned to projects which will be seen on the list
* authorization key which will provide access to list in JSON
* redmine groups, which will have access to responsibility list

The default settings are:


    'Project Manager' => ['Project Manager']
    'Architect'       => ['Application architect']
    'Vice architect'  => ['Vice-Architect']
    'Developers'      => ['Developer']
    'Front End'       => ['Frontend Developer']

    Authorization key: RJwKdAN9

# Usage

To see the responsibility list, simply click on its link located on top menu.

Responsibility list provides separate lists for open, closed & archived projects.

To get responsibility list as JSON, request its URL with HTTP Header 'Authorization' set to the key defined in settings, for example:

`curl --header "Authorization: RJwKdAN9" http://your.host.with.port/responsibility_list.json`

To get the membership history page simply click on the `membership list` tab after visitng the `responsibility list` page.

# License

    Redmine Responsibility List plugin
    Copyright (C) 2014  efigence S.A.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
