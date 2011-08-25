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
  <script src="/depender/build?client=true&require=Element,More/Drag,More/Drag.Move"></script>
  <script type="text/javascript">
    function destroy(e) {

      var close = e.target;
      var div = close.getParent();

      close.removeEvent('click', destroy);
      var iframe = div.childNodes[1];
      iframe.src = "about:blank";

      // div.empty();
      div.fireEvent('destroy');
      div.dispose();
    }

    function loadApp(url) {
			var div = new Element('div', {
        'style': 'width: 900px; height: 800px; position: absolute; top: 20px; left: 20px; background-color: #ccc'
			});
      div.makeResizable();
      div.makeDraggable();

			var close = new Element('input', {
				'type': 'button',
				'value': 'Close'
			});

			var iframe = new Element('iframe', {
				'src': url,
				'style': 'width: 800px; height: 750px'
			});

			close.addEvent('click', destroy);

			close.inject(div);
			iframe.inject(div);

      div.inject(document.body);
    }

    function destroy2(e) {
      var close;

      if (!e) {
        close = window.event.srcElement;
      } else {
        close = e.srcElement;
      }

      close.detachEvent('onclick', destroy);
      var div = close.parentNode;
      var iframe = div.childNodes[0];
      iframe.src = "about:blank";

      document.body.removeChild(div);
    }

    function loadApp2(url) {
      var div = document.createElement('div');
      div.setAttribute('style', 'width: 900px; height: 800px; position: absolute; top: 20px; left: 20px; background-color: #ccc');

      var close = document.createElement('input');
      close.setAttribute('type', 'button');
      close.setAttribute('value', 'Close');

      var iframe = document.createElement('iframe');
      iframe.setAttribute('src', url);
      iframe.setAttribute('style', 'width: 800px; height: 750px');

      close.attachEvent('onclick', destroy2);

      div.appendChild(iframe);
      div.appendChild(close);

      document.body.appendChild(div);
    }
  </script>
</head>
<body>
  <button onclick="loadApp('/beeswax/')">Beeswax</button>
  <button onclick="loadApp('/help')">Help</button>
  <button onclick="loadApp('/userman/users')">Userman</button>
  <button onclick="loadApp('/jobbrowser/jobs')">Job Browser</button>
  <button onclick="loadApp('/jobsub/list/')">Job Designer</button>
  <button onclick="loadApp('/flume/flows')">Flume</button>
  <button onclick="loadApp('/filebrowser')">File Browser</button>

</body>
</html>
