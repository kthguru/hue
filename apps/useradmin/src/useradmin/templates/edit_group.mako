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
from desktop.views import commonheader, commonfooter
from desktop.lib.django_util import extract_field_data
import urllib
from django.utils.translation import ugettext as _
%>


<%namespace name="layout" file="layout.mako" />

${commonheader(_('Hue Groups'), "useradmin", "100px")}
${layout.menubar(section='groups', _=_)}

<%def name="render_field(field)">
  %if not field.is_hidden:
    <% group_class = len(field.errors) and "error" or "" %>
    <div class="control-group ${group_class}">
      <label class="control-label" for="id_${field.html_name}">${field.label}</label>
      <div class="controls">
		${unicode(field) | n}
        % if len(field.errors):
          <span class="help-inline">${unicode(field.errors) | n}</span>
        % endif
      </div>
    </div>
  %endif
</%def>


<div class="container-fluid">
	% if name:
		<h1>${_('Hue Groups - Edit group: %(name)s') % dict(name=name)}</h1>
	% else:
		% if ldap:
			<h1>${_('Hue Groups - Add/Sync LDAP group')}</h1>
		% else:
			<h1>${_('Hue Groups - Create group')}</h1>
		% endif
	% endif

	<form id="editForm" action="${urllib.quote(action)}" method="POST" class="form form-horizontal">
		<fieldset>
		% for field in form:
			${render_field(field)}
		% endfor
        </fieldset>
		<br/>
		<div class="form-actions">
			% if name:
				<input type="submit" class="btn btn-primary" value="${_('Update group')}"/>
			% else:
				% if ldap:
					<input type="submit" class="btn btn-primary" value="${_('Add/Sync group')}"/>
				% else:
					<input type="submit" class="btn btn-primary" value="${_('Add group')}"/>
				% endif
			% endif
			<a href="/useradmin/groups" class="btn">${_('Cancel')}</a>
		</div>
	</form>
</div>

<script type="text/javascript" charset="utf-8">
	$(document).ready(function(){
		$("#id_members").jHueSelector({
            width:400,
            selectAllLabel: "${_('Select all')}",
            searchPlaceholder: "${_('Search')}"
        });
		$("#id_permissions").jHueSelector({
            width:400,
            selectAllLabel: "${_('Select all')}",
            searchPlaceholder: "${_('Search')}"
        });
	});
</script>

${commonfooter(messages)}
