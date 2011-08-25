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

<%def name="head(title='File Browser', toolbar=True, section=False)">
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
    <link rel="stylesheet" type="text/css" href="/filebrowser/static/css/filebrowser2.css" />
    <link rel="stylesheet" type="text/css" href="/static/oocss/Button.css" />
    <link rel="stylesheet" type="text/css" href="/static/oocss/Bar.css" />
    <link rel="stylesheet" type="text/css" href="/static/oocss/Bar.Paginator.css" />
    <link rel="stylesheet" type="text/css" href="/static/oocss/Grid.css" />
    <link rel="stylesheet" type="text/css" href="/static/oocss/Icon.css" />
   </head>
  </head>
  <body class="hue-shared jframe-shared filebrowser">
</%def>

<%def name="foot()">
  <script type="text/javascript" src="/depender/build?client=true&require=filebrowser/Hue.FileBrowser"></script>
  <script type="text/javascript">
  window.addEvent('domready', function () {
    Behavior.instance = new Behavior();
    Behavior.instance.apply(document.documentElement);
  });
  </script>
  </body>
</html>
</%def>


