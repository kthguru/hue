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
%>

<%namespace name="layout" file="../navigation-bar.mako" />
<%namespace name="utils" file="../utils.inc.mako" />

${ commonheader(_("Oozie App"), "oozie", "100px") }
${ layout.menubar(section='workflows') }


<div class="container-fluid">
  <h1>${ _('Workflow') } <a href="${ url('oozie:edit_workflow', workflow=workflow.id) }">${ workflow.name }</a> : ${ _('Action') }
  % if action_form.instance.id:
    ${ action_form.instance }
  % endif
  </h1>

  <br/>
  <form class="form-horizontal" id="actionForm" action="${ form_url }" method="POST">
    <fieldset>
    % for field in action_form:
      % if field.html_name in ('name', 'description'):
        ${ utils.render_field(field) }
      % endif
    % endfor

    ${ utils.render_constant(_('Action type'), node_type) }

    <hr/>

    <div class="control-group">
      <label class="control-label"></label>
      <div class="controls">
      <p class="alert alert-info span5">
        ${ _('You can parameterize the values using uppercase') } <code>${"${"}VAR}</code>.
      </p>
      </div>
    </div>

    % for field in action_form:
      % if field.html_name not in ('name', 'description', 'node_type'):
        ${ utils.render_field(field) }
      % endif
    % endfor

    % if 'params' in action_form.fields:
      <div class="control-group">
        <label class="control-label">${ _('Params') }</label>
        <div class="controls">
          <table class="table-condensed designTable" data-bind="visible: params().length > 0">
            <thead>
              <tr>
                <th>${ _('Type') }</th>
                <th>${ _('Value') }</th>
                <th/>
              </tr>
            </thead>
            <tbody data-bind="foreach: params">
              <tr>
                <td>
                  <span class="span3 required" data-bind="text: type" />
                </td>
                <td>
                  <input class="input span5 required pathChooserKo" data-bind="fileChooser: $data, value: value, uniqueName: false" />
                </td>
                <td><a class="btn" href="#" data-bind="click: $root.removeParam">${ _('Delete') }</a></td>
              </tr>
            </tbody>
          </table>

          % if len(action_form['params'].errors):
            <div class="alert alert-error">
              ${ unicode(action_form['params'].errors) | n }
            </div>
          % endif

          <button class="btn" data-bind="click: addParam">${ _('Add Param') }</button>
          <button class="btn" data-bind="click: addArgument">${ _('Add Argument') }</button>
        </div>
      </div>
    % endif

    % if 'job_properties' in action_form.fields:
    <div class="control-group">
      <label class="control-label">${ _('Job Properties') }</label>
      <div class="controls">
        <table class="table-condensed designTable" data-bind="visible: properties().length > 0">
          <thead>
            <tr>
              <th>${ _('Property name') }</th>
              <th>${ _('Value') }</th>
              <th/>
            </tr>
          </thead>
          <tbody data-bind="foreach: properties">
            <tr>
              <td><input class="span4 required propKey" data-bind="value: name, uniqueName: false" /></td>
              <td><input class="span5 required pathChooserKo" data-bind="fileChooser: $data, value: value, uniqueName: false" /></td>
              <td><a class="btn btn-small" href="#" data-bind="click: $root.removeProp">${ _('Delete') }</a></td>
            </tr>
          </tbody>
        </table>
        % if len(action_form['job_properties'].errors):
          <div class="row">
            <div class="alert alert-error">
              ${ unicode(action_form['job_properties'].errors) | n }
            </div>
          </div>
        % endif

        <button class="btn" data-bind="click: addProp">${ _('Add Property') }</button>
      </div>
    </div>
    % endif

    % if 'files' in action_form.fields:
    <div class="control-group">
        <label class="control-label">${ _('Files') }</label>
        <div class="controls">
            <table class="table-condensed designTable" data-bind="visible: files().length > 0">
              <tbody data-bind="foreach: files">
                <tr>
                  <td><input class="input span5 required pathChooserKo"
                          data-bind="fileChooser: $data, value: name, uniqueName: false" />
                  </td>
                  <td><a class="btn" href="#" data-bind="click: $root.removeFile">${ _('Delete') }</a></td>
                </tr>
              </tbody>
            </table>
            % if len(action_form['files'].errors):
              <div class="alert alert-error">
                ${ unicode(action_form['files'].errors) | n }
              </div>
            % endif

            <button class="btn" data-bind="click: addFile">${ _('Add File') }</button>
        </div>
    </div>
    % endif

    % if 'archives' in action_form.fields:
    <div class="control-group">
      <label class="control-label">${ _('Archives') }</label>
      <div class="controls">
        <table class="table-condensed designTable" data-bind="visible: archives().length > 0">
          <tbody data-bind="foreach: archives">
            <tr>
              <td>
                <input class="input span5 required pathChooserKo"
                    data-bind="fileChooser: $data, value: name, uniqueName: false" />
              </td>
              <td><a class="btn" href="#" data-bind="click: $root.removeArchive">${ _('Delete') }</a></td>
            </tr>
          </tbody>
        </table>
        % if len(action_form['archives'].errors):
          <div class="alert alert-error">
            ${ unicode(action_form['archives'].errors) | n }
          </div>
        % endif

        <button class="btn" data-bind="click: addArchive">${ _('Add Archive') }</button>
       </div>
    </div>
    % endif
    </fieldset>

    <div class="form-actions">
      <a href="${ url('oozie:edit_workflow', workflow=workflow.id) }" class="btn">${ _('Cancel') }</a>
      % if can_edit_action:
        <button data-bind="click: submit" class="btn btn-primary">${ _('Save') }</button>
      % endif
    </div>
  </form>
</div>


<div id="chooseFile" class="modal hide fade">
  <div class="modal-header">
    <a href="#" class="close" data-dismiss="modal">&times;</a>
    <h3>${ _('Choose a file') }</h3>
  </div>
  <div class="modal-body">
    <div id="fileChooserModal"></div>
  </div>
  <div class="modal-footer"></div>
</div>


<link rel="stylesheet" href="/static/ext/css/jquery-ui-autocomplete-1.8.18.css" type="text/css" media="screen" title="no title" charset="utf-8" />
<script src="/static/ext/js/knockout-2.0.0.js" type="text/javascript" charset="utf-8"></script>
<script src="/static/ext/js/jquery/plugins/jquery-ui-autocomplete-1.8.18.min.js" type="text/javascript" charset="utf-8"></script>

<style>
  #fileChooserModal {
    padding:14px;
    height:270px;
  }

  #fileChooserModal > ul {
    overflow-y:auto;
  }

  .designTable {
    margin-left:0;
  }
  .designTable th, .designTable td {
    padding-left: 0;
  }
  .designTable th {
    text-align:left;
  }
</style>


<script type="text/javascript" charset="utf-8">
  $(document).ready(function(){
    var propertiesHint = ${properties_hint};

    // The files and archives are dictionaries in the model, because we
    // can add and remove it the same way we add/remove properties.
    // But the server expects them to be arrays. So we transform the
    // two representations back and forth.
    var arrayToDictArray = function(arr) {
        var res = [ ];
        for (var i in arr) {
            res.push( { name: arr[i], dummy: "" } );
        }
        return res;
    };

    var dictArrayToArray = function(dictArray) {
        var res = [ ];
        for (var i in dictArray) {
            res.push(dictArray[i]["name"]);
        }
        return res;
    };

    // Handles adding autocomplete to job properties.
    // We need to propagate the selected value to knockoutjs.
    var addAutoComplete = function(i, elem) {
        $(elem).autocomplete({
            source: propertiesHint,
            select: function(event, ui) {
                var context = ko.contextFor(this);
                context.$data.name = ui.item.value;
            }
        });
    };

    var ViewModel = function(properties, files, archives, params) {
        var self = this;

        self.properties = ko.observableArray(properties);
        self.files = ko.observableArray(files);
        self.archives = ko.observableArray(archives);
        self.params = ko.observableArray(params);

        self.addProp = function() {
            self.properties.push({ name: "", value: "" });
            $(".propKey:last").each(addAutoComplete);
        };

        self.removeProp = function(val) {
            self.properties.remove(val);
        };

        self.addParam = function() {
            self.params.push({ value: "", type: "param" });
        };

        self.addArgument = function() {
            self.params.push({ value: "", type: "arg" });
        };

        self.removeParam = function(val) {
            self.params.remove(val);
        };

        self.addFile = function() {
            self.files.push({ name: "", dummy: "" });
        };

        self.removeFile = function(val) {
            self.files.remove(val);
        };

        self.addArchive = function() {
            self.archives.push({ name: "", dummy: "" });
        };

        self.removeArchive = function(val) {
            self.archives.remove(val);
        };

        self.submit = function(form) {
            var form = $("#actionForm");
            var files_arr = dictArrayToArray(ko.toJS(self.files));
            var archives_arr = dictArrayToArray(ko.toJS(self.archives));

            // Beware dirty
            $("<input>").attr("type", "hidden")
                .attr("name", "job_properties")
                .attr("value", ko.utils.stringifyJson(self.properties))
                .appendTo(form);
            $("<input>").attr("type", "hidden")
                .attr("name", "files")
                .attr("value", JSON.stringify(files_arr))
                .appendTo(form);
            $("<input>").attr("type", "hidden")
                .attr("name", "archives")
                .attr("value", JSON.stringify(archives_arr))
                .appendTo(form);
            $("<input>").attr("type", "hidden")
                .attr("name", "params")
                .attr("value", ko.utils.stringifyJson(self.params))
                .appendTo(form);

            form.submit();
        };
      };

	  var viewModel = new ViewModel(
	            ${ job_properties },
	            arrayToDictArray(${ files }),
	            arrayToDictArray(${ archives }),
	            ${ params });
	
	  ko.bindingHandlers.fileChooser = {
	        init: function(element, valueAccessor, allBindings, model) {
	        var self = $(element);
	        self.after(getFileBrowseButton(self));
      }
    };

    ko.applyBindings(viewModel);

    $(".pathChooser").each(function(){
      var self = $(this);
      self.after(getFileBrowseButton(self));
    });

    function getFileBrowseButton(inputElement) {
      return $("<button>").addClass("btn").addClass("fileChooserBtn").text("..").click(function(e){
        e.preventDefault();
        $("#fileChooserModal").jHueFileChooser({
	        onFileChoose: function(filePath) {
	            inputElement.val(filePath);
	            $("#chooseFile").modal("hide");
	        },
	        createFolder: false
	      });
	    $("#chooseFile").modal("show");
      })
    }

    $(".propKey").each(addAutoComplete);
  });
</script>

${commonfooter(messages)}
