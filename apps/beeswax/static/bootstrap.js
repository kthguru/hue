// Licensed to Cloudera, Inc. under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  Cloudera, Inc. licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
Hue.Desktop.register({
	Beeswax: {
		name: 'Beeswax for Hive',
		require: ['beeswax/Hue.BeeswaxInFrame'],
		launch: function(path, options) {
			var url = "/beeswax";
			// options.displayHistory = false;
      var div = new Element('div', {
        'style': 'width: 900px; height: 800px; position: absolute; top: 20px; left: 20px; background-color: #ccc'
      });

      var close = new Element('input', {
        'type': 'button',
        'value': 'Close'
      });

      var iframe = new Element('iframe', {
        'src': url,
        'style': 'width: 800px; height: 750px'
      });

      var destroyInClosure = function(e) {

        var close = e.target;
        var div = close.getParent();

        close.removeEvent('click', destroyInClosure);
        var iframe = div.childNodes[1];
        iframe.src = "about:blank";

        div.fireEvent('destroy');
        div.dispose();

        div = null;
        iframe = null;
        close = null;
      };

      close.addEvent('click', destroyInClosure);

      close.inject(div);
      iframe.inject(div);

			return div;
		},
		// css: '/beeswax/static/css/beeswax.css',
		menu: {
			id: 'hue-beeswax-menu',
			img: {
				src: '/beeswax/static/art/beeswax-logo.png'
			}
		},
		help: '/help/beeswax/'
	}
});
