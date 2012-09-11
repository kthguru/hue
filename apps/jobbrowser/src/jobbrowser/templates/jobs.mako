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
<%
  from jobbrowser.views import get_state_link
  from desktop import appmanager
  from django.template.defaultfilters import urlencode
  from desktop.views import commonheader, commonfooter
  from django.utils.translation import ugettext as _
%>
<%namespace name="comps" file="jobbrowser_components.mako" />

<%def name="get_state(option, state)">
%   if option == state:
      selected="true"
%   endif
</%def>

% if len(jobs) > 0 or filtered:
${commonheader(_('Job Browser'), "jobbrowser")}
<div class="container-fluid">
<h1>${_('Job Browser')}</h1>
<form class="well form-inline" action="/jobbrowser/jobs" method="GET">
    <label>
    ${_('Job status:')}
    <select name="state" class="submitter">
        <option value="all" ${get_state('all', state_filter)}>${_('All States')}</option>
        <option value="running" ${get_state('running', state_filter)}>${_('Running')}</option>
        <option value="completed" ${get_state('completed', state_filter)}>${_('Completed')}</option>
        <option value="failed" ${get_state('failed', state_filter)}>${_('Failed')}</option>
        <option value="killed" ${get_state('killed', state_filter)}>${_('Killed')}</option>
    </select>
    </label>
    &nbsp;
    <label class="checkbox">
        <%
            checked = ""
            if retired == "on":
                checked = 'checked="checked"'
        %>
        <input name="retired" type="checkbox" class="submitter" ${checked}> ${_('Show retired jobs')}
    </label>

    <label class="pull-right">
        &nbsp;
        ${_('Text:')}
        <input type="text" name="text" title="${_('Text Filter')}" value="${text_filter}" placeholder="${_('Text Filter')}" class="submitter input-xlarge search-query"/>
    </label>
    <label class="pull-right">
        ${_('Username:')}
        <input type="text" name="user" title="${_('User Name Filter')}" value="${user_filter}" placeholder="${_('User Name Filter')}" class="submitter input-medium search-query" />
    </label>
</form>


% if len(jobs) == 0:
<p>${_('There were no jobs that match your search criteria.')}</p>
% else:
<style>
    .job-row {
        height:45px;
    }
</style>
<table class="datatables table table-striped table-condensed">
    <thead>
        <tr>
            <th>${_('ID')}</th>
            <th>${_('Name')}</th>
            <th>${_('Status')}</th>
            <th>${_('User')}</th>
            <th>${_('Maps')}</th>
            <th>${_('Reduces')}</th>
            <th>${_('Queue')}</th>
            <th>${_('Priority')}</th>
            <th>${_('Duration')}</th>
            <th>${_('Date')}</th>
            <th data-row-selector-exclude="true"></th>
        </tr>
    </thead>
    <tbody>
        % for job in jobs:
        <tr class="job-row">
            <td>
                <a href="${url('jobbrowser.views.single_job', jobid=job.jobId)}" title="${_('View this job')}" data-row-selector="true">${job.jobId_short}</a>
            </td>
            <td>
                ${job.jobName}
            </td>
            <td>
                <a href="${url('jobbrowser.views.jobs')}?${get_state_link(request, 'state', job.status.lower())}" title="${_('Show only %(status)s jobs') % dict(status=job.status.lower())}" class="nounderline">
                    ${comps.get_status(job)}
                </a>
            </td>
            <td class="center">
                <a href="${url('jobbrowser.views.jobs')}?${get_state_link(request, 'user', job.user.lower())}" title="${_('Show only %(status)s jobs') % dict(status=job.user.lower())}">${job.user}</a>
            </td>
            <td data-sort-value="${job.maps_percent_complete}">
                % if job.is_retired:
                    <div class="center">${_('N/A')}</div>
                % else:
                ${comps.mr_graph_maps(job)}
                % endif
            </td>
            <td data-sort-value="${job.reduces_percent_complete}">
                % if job.is_retired:
                    <div class="center">${_('N/A')}</div>
                % else:
                    ${comps.mr_graph_reduces(job)}
                % endif
            </td>
            <td class="center">${job.queueName}</td>
            <td class="center">${job.priority.lower()}</td>
            <td class="center" data-sort-value="${job.durationInMillis}" data-row-selector-exclude="true">
                % if job.is_retired:
                    ${_('N/A')}
                % else:
                    ${job.durationFormatted}
                % endif
            </td>
            <td data-sort-value="${job.startTimeMs}">${job.startTimeFormatted}</td>
            <td>
                % if job.status.lower() == 'running' or job.status.lower() == 'pending':
                % if request.user.is_superuser or request.user.username == job.user:
                <a href="#" title="${_('Kill this job')}" kill-action="${url('jobbrowser.views.kill_job', jobid=job.jobId)}?next=${request.get_full_path()|urlencode}" data-row-selector-exclude="true" data-keyboard="true" class="btn btn-mini kill">
                  <i class="icon-remove"></i> ${_('Kill')}
                </a>
                % endif
                % endif
            </td>
            </tr>
            % endfor
        </tbody>
    </table>
    % endif

    % else:
    ${commonheader(_('Job Browser'), "jobbrowser")}
    <div class="container-fluid">
    <h1>${_('Welcome to the Job Browser')}</h1>
    <div>
        <p>${_("There aren't any jobs running. Let's fix that.")}</p>
        % if appmanager.get_desktop_module('jobsub') is not None:
        <a href="/jobsub/">${_('Launch the Job Designer')}</a><br/>
        % endif
        % if appmanager.get_desktop_module('beeswax') is not None:
        <a href="/beeswax/">${_('Launch Beeswax')}</a><br/>
        % endif
    </div>
    % endif
</div>

<div id="killModal" class="modal hide fade">
    <div class="modal-header">
        <a href="#" class="close" data-dismiss="modal">&times;</a>
        <h3>${_('Please Confirm')}</h3>
    </div>
    <div class="modal-body">
        <p>${_('Are you sure you want to kill this job?')}</p>
    </div>
    <div class="modal-footer">
        <form id="kill-job" action="" method="POST" class="form-stacked">
            <input type="submit" value="${_('Yes')}" class="btn primary" />
            <a id="cancelKillBtn" class="btn">${_('No')}</a>
        </form>
    </div>
</div>

<script type="text/javascript" charset="utf-8">
    $(document).ready(function(){
        $(".datatables").dataTable({
            "bPaginate": false,
            "bLengthChange": false,
            "bFilter": false,
            "bInfo": false,
            "aaSorting": [[ 0, "desc" ]],
            "aoColumns": [
                null,
                null,
                null,
                null,
                { "sSortDataType": "dom-sort-value", "sType": "numeric", "sWidth": "60px" },
                { "sSortDataType": "dom-sort-value", "sType": "numeric", "sWidth": "60px" },
                null,
                null,
                { "sSortDataType": "dom-sort-value", "sType": "numeric" },
                { "sSortDataType": "dom-sort-value", "sType": "numeric" },
                {"bSortable":false}
            ]
        });

        $(".kill").live("click", function(e){
            $("#kill-job").attr("action", $(e.target).attr("kill-action"));
            $("#killModal").modal({
                keyboard: true,
                show: true
            });
        });

        $("#cancelKillBtn").click(function(){
            $("#killModal").modal("hide");
        });

        var filterTimeout = -1;
        $(".search-query").keyup(function(){
            window.clearTimeout(filterTimeout);
            var el = $(this);
            filterTimeout = window.setTimeout(function(){
                el.closest("form").submit();
            }, 500);
        });


        $("a[data-row-selector='true']").jHueRowSelector();
    });
</script>

${commonfooter(messages)}
