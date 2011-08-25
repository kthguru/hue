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
<%!
import datetime
from django.template.defaultfilters import urlencode, escape
%>
<%def name="toolbar(path, current_request_path=False, toolbar=True, cwd_set=True, show_upload=True)">

      % if toolbar:
        <div class="header toolbar">

        <a class="logo" href="${url('filebrowser.views.view', path='/')}"><img src="/filebrowser/static/art/icon_large.png" class="logo"/></a>
        % if current_request_path:
          <div class="fb-actions Bar">
            % if home_directory:
              <% my_home_disabled = "" %>
            % else:
              <% my_home_disabled = "disabled" %>
            % endif
            <a class="fb-home ${my_home_disabled} Button" href="${url('filebrowser.views.view', path=(home_directory or "/"))}">My Home</a>
            % if cwd_set:
              % if show_upload:
                <a class="fb-upload Button" href="${url('filebrowser.views.upload')}?dest=${path|urlencode}&next=${current_request_path|urlencode}">Upload Files</a>
              % endif
              <a class="fb-mkdir Button" href="${url('filebrowser.views.mkdir')}?path=${path|urlencode}&next=${current_request_path|urlencode}">New Directory</a>
            % endif
          </div>
        % endif
      </div>
      % endif
</%def>

<%def name="uploadToolbar()">
      <div class="fb-uploader jframe-hidden">
        <a class="fb-cancel-upload">Close</a>
        <ul class="fb-upload-list"></ul>

        <div class="fb-noflash">If you are experiencing flash errors due to uploading,
          you can <a target="hue_upload" href="${ url('filebrowser.views.upload') }">upload without flash</a>.
        </div>
      </div>
</%def>
