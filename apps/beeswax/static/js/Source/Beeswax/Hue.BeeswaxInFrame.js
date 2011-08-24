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
/*
---
description: Beeswax (the Hive UI) IFrame Loader
provides: [Hue.BeeswaxInFrame]
requires: [JFrame/JFrame.Browser]
script: Hue.BeeswaxInFrame.js

...
*/
(function(){
	Hue.BeeswaxInFrame = new Class({

		Extends: JFrame.Browser,

		options: {
			displayHistory: false,
			height: 350,
			className: 'art',
			windowTitler: function(title) {
				return "Beeswax";
			},
			jframeOptions: {}
		},

		initialize: function(path, options) {
			this.parent(path || '/beeswax/load_in_frame', options);
			// if (!Hue.Desktop.helpInstance || Hue.Desktop.helpInstance.isDestroyed()) Hue.Desktop.helpInstance = this;
		}
	});
}());
