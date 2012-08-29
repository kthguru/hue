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
    <div class="subnav subnav-fixed">
        % if from_listdir:
        <p class="pull-right">

            <button class="btn fileToolbarBtn" title="${_('Edit File')}" rel="tooltip" data-bind="click: editFile, enable: selectedFiles().length == 1 && selectedFile().type == 'file'"><i class="icon-pencil"></i></button>
            <button class="btn fileToolbarBtn" title="${_('Download File')}" rel="tooltip" data-bind="click: downloadFile, enable: selectedFiles().length == 1 && selectedFile().type == 'file'"><i class="icon-download"></i></button>
            <button class="btn fileToolbarBtn" title="${_('Rename')}" rel="tooltip" data-bind="click: renameFile, enable: selectedFiles().length == 1"><i class="icon-font"></i></button>
            <button class="btn fileToolbarBtn" title="${_('Move')}" rel="tooltip" data-bind="click: move, enable: selectedFiles().length == 1"><i class="icon-random"></i></button>
            <button class="btn fileToolbarBtn" title="${_('Change Owner / Group')}" rel="tooltip" data-bind="click: changeOwner, enable: selectedFiles().length == 1"><i class="icon-user"></i></button>
            <button class="btn fileToolbarBtn" title="${_('Change Permissions')}" rel="tooltip" data-bind="click: changePermissions, enable: selectedFiles().length == 1"><i class="icon-list-alt"></i></button>
            <button class="btn fileToolbarBtn" title="${_('Delete')}" rel="tooltip" data-bind="click: deleteSelected, enable: selectedFiles().length == 1"><i class="icon-trash"></i></button>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <a href="#" class="btn upload-link" title="${_('Upload files')}" rel="tooltip"><i class="icon-upload"></i></a>
            <a href="#" class="btn create-directory-link" title="${_('New directory')}" rel="tooltip"><i class="icon-folder-close"></i></a>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="text" class="input-medium search-query" placeholder="${_('Search for file name')}" data-bind="value: searchQuery">
            <a href="#" class="btn" data-bind="click: filter">${_('Search')}</a>
        </p>
        % endif
        <ul class="nav nav-pills">
          <li><a href="${url('filebrowser.views.view', path=urlencode(path))}?default_to_home"><i class="icon-home"></i> ${_('Home')}</a></li>
          <li>
            <ul class="hueBreadcrumb" data-bind="foreach: breadcrumbs">
                <li data-bind="visible: label == '/'"><a href="#" data-bind="click: show"><span class="divider" data-bind="text: label"></span></a></li>
                <li data-bind="visible: label != '/'"><a href="#" data-bind="text: label, click: show"></a><span class="divider">/</span></li>
            </ul>
          </li>
        </ul>
    </div>
    <br/>
</%def>
