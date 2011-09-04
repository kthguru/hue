## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
##
## no spaces in this method please; we're declaring a CSS class, and ART uses this value for stuff, and it splits on spaces, and
## multiple spaces and line breaks cause issues
<%!
def is_selected(section, matcher):
  if section == matcher:
    return "selected"
  else:
    return ""
%>

<%def name="head(title='Beeswax for Hive', toolbar=True, section=False)">
<html>
  <head>
    <meta http-equiv="x-ua-compatible" content="IE=8">
    <title>${title}</title>
    <link rel="stylesheet" type="text/css" href="/static/css/shared.css"/>
    <link rel="stylesheet" type="text/css" href="/static/css/reset.css"/>
    <link rel="stylesheet" type="text/css" href="/static/css/windows.css"/>
    <!--
    <link rel="stylesheet" type="text/css" href="/static/css/desktop.css"/>
    -->
    <link rel="stylesheet" type="text/css" href="/static/css/hue-deprecated.css"/>
    <link rel="stylesheet" type="text/css" href="/static/js/ThirdParty/jframe/Assets/jframe.css"/>
    <link rel="stylesheet" type="text/css" href="/static/css/app-common.css" />
    <link rel="stylesheet" type="text/css" href="/beeswax/static/css/beeswax2.css" />
    <link rel="stylesheet" type="text/css" href="/static/oocss/Button.css" />
    <link rel="stylesheet" type="text/css" href="/static/oocss/Bar.css" />
    <link rel="stylesheet" type="text/css" href="/static/oocss/Bar.Paginator.css" />
    <link rel="stylesheet" type="text/css" href="/static/oocss/Grid.css" />
    <link rel="stylesheet" type="text/css" href="/static/oocss/Icon.css" />
   </head>
  </head>
  <body class="hue-shared jframe-shared beeswax">
  <div class="toolbar">
    <a href="${ url('beeswax.views.index') }"><img src="/beeswax/static/art/beeswax-logo.png" width="55" height="55" alt="Beeswax" class="beeswax_logo"></a>
    % if toolbar:
    <span class="Bar">
      <a href="${ url('beeswax.views.execute_query') }"
        class="Button roundLeft ${is_selected(section, 'query')}"><span class="bw-query_nav nav_icon">Query Editor</span></a>
      <a href="${ url('beeswax.views.my_queries') }"
        class="Button ${is_selected(section, 'my queries')}"><span class="bw-my_queries_nav nav_icon">My Queries</span></a>
      <a href="${ url('beeswax.views.list_designs') }"
        class="Button ${is_selected(section, 'saved queries')}"><span class="bw-queries_nav nav_icon">Saved Queries</span></a>
    ## <a href="${ url('beeswax.views.edit_report') }" class="nav_icon bw-new_report_gen_nav ${is_selected(section, 'report generator')}">Report Generator</a>
      <a href="${ url('beeswax.views.list_query_history') }"
        class="Button ${is_selected(section, 'history')}"><span class="bw-history_nav nav_icon">History</span></a>
      <a href="${ url('beeswax.views.show_tables') }"
        class="Button ${is_selected(section, 'tables')}"><span class="bw-tables_nav nav_icon">Tables</span></a>
      <a href="${ url('beeswax.views.configuration') }"
        class="Button ${is_selected(section, 'hive configuration')}"><span class="bw-config_nav nav_icon">Settings</span></a>
      <a class="Button roundRight jframe-refresh"><span class="bw-refresh_icon">Refresh</span></a>
    </ul>
    % endif
  </div>
  <hr class="jframe-hidden"/>
</%def>

<%def name="foot()">
  <script type="text/javascript" src="/depender/build?client=true&require=beeswax/Hue.Beeswax"></script>
  <script type="text/javascript">

  window.addEvent('domready', function () {
    var options = {
      element: document.body
    }
    new Hue.Beeswax(window.location.href, options);
  });

  </script>
  </body>
</html>
</%def>


