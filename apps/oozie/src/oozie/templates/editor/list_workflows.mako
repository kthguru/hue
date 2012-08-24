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
  from django.utils.translation import ugettext as _

  from oozie.views import can_access_job, can_edit_job
%>

<%namespace name="layout" file="../navigation-bar.mako" />
<%namespace name="utils" file="../utils.inc.mako" />

${ commonheader( _("Oozie App"), "oozie", "100px") }
${ layout.menubar(section='workflows') }


<div class="container-fluid">
  <h1>${ _('Workflow Editor') }</h1>

  <div class="well hueWell">
    <div class="btn-group pull-right">
      <a href="${ url('oozie:create_workflow') }" class="btn">${ _('Create') }</a>
      % if currentuser.is_superuser:
        <a href="#installSamples" data-toggle="modal" class="btn">${ _('Setup App') }</a>
      % endif
    </div>

    <div class="row-fluid">
      <div class="span4">
        <form class="form-search">
          ${ _('Filter:') } <input type="text" id="filterInput" class="input-xlarge search-query" placeholder="${ _('Search for username, name, etc...') }">
        </form>
      </div>
      <div class="span4">
        <button class="btn action-buttons" id="submit-btn" disabled="disabled"><i class="icon-play"></i> ${ _('Submit') }</button>
        <button class="btn action-buttons" id="schedule-btn" disabled="disabled"><i class="icon-refresh"></i> ${ _('Schedule') }</button>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <button class="btn action-buttons" id="clone-btn" disabled="disabled"><i class="icon-retweet"></i> ${ _('Copy') }</button>
        <button class="btn action-buttons" id="delete-btn" disabled="disabled"><i class="icon-remove"></i> ${ _('Delete') }</button>
      </div>
      <div class="span4"></div>
    </div>
  </div>

  <br/>

  <table id="workflowTable" class="table datatables">
    <thead>
      <tr>
        <th></th>
        <th>${ _('Name') }</th>
        <th>${ _('Description') }</th>
        <th>${ _('Last Modification') }</th>
        <th>${ _('Steps') }</th>
        <th>${ _('Status') }</th>
        <th>${ _('Owner') }</th>
      </tr>
    </thead>
    <tbody>
      %for workflow in jobs:
        <tr class="action-row">
          <td class=".btn-large action-column" data-row-selector-exclude="true" style="background-color: white;">
            <input type="radio" name="action" data-row-selector-exclude="true"
              % if can_access_job(currentuser, workflow):
                  data-param-url="${ url('oozie:workflow_parameters', workflow=workflow.id) }"
                  data-submit-url="${ url('oozie:submit_workflow', workflow=workflow.id) }"
                  data-schedule-url="${ url('oozie:create_coordinator', workflow=workflow.id) }"
              % endif
              % if can_edit_job(currentuser, workflow):
                  data-delete-url="${ url('oozie:delete_workflow', workflow=workflow.id) }"
                  data-clone-url="${ url('oozie:clone_workflow', workflow=workflow.id) }"
              % endif
            />
            % if can_access_job(currentuser, workflow):
              <a href="${ url('oozie:edit_workflow', workflow=workflow.id) }" data-row-selector="true"></a>
            % endif
          </td>
          <td>
            ${ workflow.name }
          </td>
          <td>${ workflow.description }</td>

          <td nowrap="nowrap">${ utils.format_date(workflow.last_modified) }</td>
          <td><span class="badge badge-info">${ workflow.actions.count() }</span></td>
          <td>
            <span class="label label-info">${ workflow.status }</span>
          </td>
          <td>${ workflow.owner.username }</td>
        </tr>
      %endfor
    </tbody>
  </table>

</div>


<div id="submitWf" class="modal hide fade">
  <form id="submitWfForm" action="" method="POST">
    <div class="modal-header">
      <a href="#" class="close" data-dismiss="modal">&times;</a>
      <h3 id="submitWfMessage">${ _('Submit this workflow?') }</h3>
    </div>
    <div class="modal-body">
      <fieldset>
        <div id="param-container">
        </div>
      </fieldset>
    </div>
    <div class="modal-footer">
      <a href="#" class="btn secondary hideModal">${ _('Cancel') }</a>
      <input id="submitBtn" type="submit" class="btn primary" value="${ _('Submit') }"/>
    </div>
  </form>
</div>

<div id="deleteWf" class="modal hide fade">
  <form id="deleteWfForm" action="" method="POST">
    <div class="modal-header">
      <a href="#" class="close" data-dismiss="modal">&times;</a>
      <h3 id="deleteWfMessage">${ _('Delete this workflow?') }</h3>
    </div>
    <div class="modal-footer">
      <input type="submit" class="btn primary" value="${ _('Yes') }"/>
      <a href="#" class="btn secondary hideModal">${ _('No') }</a>
    </div>
  </form>
</div>

<div id="installSamples" class="modal hide fade">
  <form id="installSamplesForm" action="${url('oozie:setup_app')}" method="POST">
    <div class="modal-header">
      <a href="#" class="close" data-dismiss="modal">&times;</a>
      <h3>${ _('Setup the workspaces and examples?') }</h3>
    </div>
    <div class="modal-body">
      ${ _('Hue is going to re-create the workspaces and re-install the examples...') }
    </div>
    <div class="modal-footer">
      <input type="submit" class="btn primary" value="${ _('Yes') }"/>
      <a href="#" class="btn secondary" data-dismiss="modal">${ _('No') }</a>
    </div>
  </form>
</div>

<style>
  td .btn-large{ cursor: crosshair;  }

  .action-column {
    cursor: auto;
  }
</style>

<script src="/static/ext/js/datatables-paging-0.1.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript" charset="utf-8">
  $(document).ready(function() {
      $(".action-row").click(function(e){
        var select_btn = $(this).find('input');
        select_btn.prop("checked", true);

        $(".action-row").css("background-color", "");
        $(this).css("background-color", "#ECF4F8");

        $(".action-buttons").attr("disabled", "disabled");

        update_action_buttons_status();
      });

      function update_action_buttons_status() {
        var select_btn = $('input[name=action]:checked');

        var action_buttons = [
          ['#submit-btn', 'data-submit-url'],
          ['#schedule-btn', 'data-schedule-url'],
          ['#delete-btn', 'data-delete-url'],
          ['#clone-btn', 'data-clone-url']]

        $.each(action_buttons, function(index) {
          if (select_btn.attr(this[1])) {
            $(this[0]).removeAttr('disabled');
          } else {
            $(this[0]).attr("disabled", "disabled");
          }
        });
      }

      update_action_buttons_status();

      $("#delete-btn").click(function(e){
          var _this = $('input[name=action]:checked');
          var _action = _this.attr("data-delete-url");
          $("#deleteWfForm").attr("action", _action);
          $("#deleteWfMessage").text(_this.attr("alt"));
          $("#deleteWf").modal("show");
      });

      $("#submit-btn").click(function(e){
          var _this = $('input[name=action]:checked');
          var _action = _this.attr("data-submit-url");
          $("#submitWfForm").attr("action", _action);
          $("#submitWfMessage").text(_this.attr("alt"));
          // We will show the model form, but disable the submit button
          // until we've finish loading the parameters via ajax.
          $("#submitBtn").attr("disabled", "disabled");
          $("#submitWf").modal("show");

          $.get(_this.attr("data-param-url"), function(data) {
              var params = data["params"]
              var container = $("#param-container");
              container.empty();
              for (key in params) {
                if (!params.hasOwnProperty(key)) {
                    continue;
                }
                container.append(
                  $("<div/>").addClass("clearfix")
                    .append($("<label/>").text(params[key]))
                    .append(
                        $("<div/>").addClass("input")
                          .append($("<input/>").attr("name", key).attr("type", "text"))
                    )
                )
              }
              // Good. We can submit now.
              $("#submitBtn").removeAttr("disabled");
          }, "json");
      });

    $("#clone-btn").click(function(e){
        var _this = $('input[name=action]:checked');
        var _url = _this.attr("data-clone-url");

      $.post(_url, function(data) {
        window.location = data.url;
      });
    });

    $("#schedule-btn").click(function(e){
        var _this = $('input[name=action]:checked');
        var _url = _this.attr("data-schedule-url");

        window.location.replace(_url);
    });

    $("#submitWf .hideModal").click(function(){
        $("#submitWf").modal("hide");
    });

    $("#deleteWf .hideModal").click(function(){
        $("#deleteWf").modal("hide");
    });

    var oTable = $('#workflowTable').dataTable( {
      "sPaginationType": "bootstrap",
      'iDisplayLength': 50,
      "bLengthChange": false,
      "sDom": "<'row'r>t<'row'<'span8'i><''p>>",
      "aoColumns": [
        { "bSortable": false },
        null,
        null,
        null,
        { "sType": "date" },
        null,
        null
      ],
      "aaSorting": [[3, 'desc'], [ 1, "asc" ]]
    });

    $("#filterInput").keyup(function() {
      oTable.fnFilter($(this).val());
    });

    $("a[data-row-selector='true']").jHueRowSelector();
  });
</script>

${commonfooter(messages)}
