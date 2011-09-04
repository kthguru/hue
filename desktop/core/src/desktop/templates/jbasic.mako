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
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=8" />
  <title>Hue</title>
  <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/smoothness/jquery-ui.css"></link>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.js"></script>
  <script src="http://www.wizzud.com/jqDock/jquery.jqDock.min.js"></script>
  <style>
    .ui-dialog .ui-dialog-content {
      padding: 0;
    }
  </style>
  <script type="text/javascript">

    function onClose(e){
      $("iframe", $(this)).attr('src', "about:blank");
    }

    function onResize(e){
      var width = $(this).innerWidth();
      var height = $(this).innerHeight();
      $("iframe", $(this)).width(width - 10);
      $("iframe", $(this)).height(height - 10);
    }

    function onDragStart(e){
      $("iframe").not($("iframe", $(this))).css("visiblility", "hidden");
    }

    function onDragStop(){
      $("iframe").not($("iframe", $(this))).css("visiblility", "visible");
    }

    function loadApp2(url, name){
      var $div = $("#appTemplate").clone();
      $("iframe", $div)
      .attr("src", url)
      .css("width", "800px").css("height", "750px").css("display", "block");

      $div.css("width", "800px").css("height", "750px")
      .dialog({
        title: name,
        width: 810,
        height: 800,
        resize: onResize,
        close: onClose,
        dragStart: onDragStart,
        dragStop: onDragStop,
        modal: false
      });
    }

    function onDockImageClick(e) {
      var url = $(this).attr("href");
      var name = $(".jqDockLabelText", $(this)).html();

      loadApp2(url, name);
      e.preventDefault();
      e.stopPropagation();
      return false;
    }

    jQuery( function($) {

      $("#dock a").click(onDockImageClick);

      var dockOptions = {};
      $("#dock").jqDock(dockOptions);
    });
  </script>
</head>
<body>
  <div id="appTemplate"><iframe style="display: none"></iframe><div class="overlay"></div></div>

  <div id="dock">
    <a href="/beeswax/" title="Beeswax" alt=""><img src="/beeswax/static/art/beeswax-logo.png"></img></a>
    <a href="/userman/users" title="Authorization Manager" alt=""><img src="/userman/static/art/userman-logo.png"></img></a>
    <a href="/jobbrowser/jobs" title="Job Browser" alt=""><img src="/jobbrowser/static/art/icon_large.png"></img></a>
    <a href="/jobsub/list/" title="Job Designer" alt=""><img src="/jobsub/static/art/icon.png"></img></a>
    <a href="/flume/flows" title="Flume" alt=""><img src="/flume/static/art/flume.png"></img></a>
    <a href="/filebrowser" title="File Browser" alt=""><img src="/filebrowser/static/art/icon_large.png"></img></a>
  </div>

  <a href="/accounts/logout">Log Out</a>

  <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>

</body>
</html>
