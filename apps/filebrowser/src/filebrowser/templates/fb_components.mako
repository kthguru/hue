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
from django.template.defaultfilters import urlencode
from django.utils.translation import ugettext as _
%>

<%def name="breadcrumbs(path, breadcrumbs, from_listdir=False)">
    <%
    current_filter = ""
    if filter_str is not None:
        current_filter = filter_str
    %>
    <div class="subnav">
        % if from_listdir:
        <p class="pull-right">
            <a href="#" class="btn upload-link">${_('Upload files')}</a>
            <a href="#" class="btn create-directory-link">${_('New directory')}</a>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="text" value="${current_filter}" class="input-medium search-query span4" placeholder="${_('Search for file name')}">
            <a href="#" class="btn filter">${_('Search')}</a>
        </p>
        % endif
        <ul class="nav nav-pills">
          <li><a href="${url('filebrowser.views.view', path=urlencode(path))}?default_to_home"><i class="icon-home"></i> ${_('Home')}</a></li>
          <li>
            <ul class="hueBreadcrumb">
                % for breadcrumb_item in breadcrumbs:
                    <% label = breadcrumb_item['label'] %>
                    %if label == '/':
                        <li><a href="/filebrowser/view${breadcrumb_item['url']}"><span
                            class="divider">${label | h}<span></a></li>
                    %else:
                        <li><a href="/filebrowser/view${breadcrumb_item['url']}">${label | h}</a><span class="divider">/</span></li>
                    %endif
                % endfor
            </ul>
          </li>
        </ul>
    </div>
    <br/>
</%def>
