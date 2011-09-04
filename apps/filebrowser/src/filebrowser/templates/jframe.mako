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
  <script type="text/javascript" src="/depender/build?client=true&require=filebrowser/Hue.FileBrowser"></script>
  <script type="text/javascript">
  window.addEvent('domready', function () {
    Behavior.instance = new Behavior();
    Behavior.instance.apply(document.documentElement);
    var options = {
      element: document.body
    }
    new Hue.FileBrowser("/filebrowser/view", options);
  });
  </script>

  </head>
  <body class="hue-shared jframe-shared filebrowser">
  </body>
</html>

