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
import md5
from django.template.defaultfilters import urlencode, stringformat, filesizeformat, date, time, escape
from desktop.lib.django_util import reverse_with_get
from django.utils.encoding import smart_str
from django.utils.translation import ugettext as _
%>


<%def name="pageref(num)">
    <%
    sortby_param = ""
    if sortby:
        sortby_param = "&sortby="+sortby

    descending_param = ""
    if descending:
        descending_param = "&descending=true"

    filter_param = ""
    if filter_str is not None:
        filter_param = "&filter="+filter_str
    %>
    href="?pagenum=${num}&pagesize=${pagesize}${sortby_param}${descending_param}${filter_param}"
</%def>

<%def name="prevpage(page)">
  ${pageref(page.previous_page_number())}
</%def>

<%def name="nextpage(page)">
  ${pageref(page.next_page_number())}
</%def>

<%def name="toppage(page)">
  ${pageref(1)}
</%def>

<%def name="bottompage(page)">
  ${pageref(page.num_pages())}
</%def>

<%def name="pagination(page)">
    <div class="pagination">
        <ul class="pull-right">
            % if page.number > 1:
                <li class="prev"><a title="${_('Beginning of List')}" ${toppage(page)}>&larr; ${_('Beginning of List')}</a></li>
                <li><a title="${_('Previous Page')}" ${prevpage(page)}>${_('Previous Page')}</a></li>
            % endif
            % if page.number < page.num_pages():
                <li><a title="${_('Next page')}" ${nextpage(page)}>${_('Next Page')}</a></li>
                <li class="next"><a title="${_('End of List')}" ${bottompage(page)}>${_('End of List')} &rarr;</a></li>
            % endif
        </ul>
        <p>${_('Show')} <select id="pagesize" class="input-mini"><option>15</option><option selected>30</option><option>45</option><option>60</option><option>100</option><option>200</option></select> ${_('items per page')}. ${_('Showing %(start_index)s to %(end_index)s of %(total_count)s items, page %(page)s of %(num_pages)s.') % dict(start_index=page.start_index(), end_index=page.end_index(), total_count=page.total_count(), page=page.number, num_pages=page.num_pages())}</p>
    </div>
</%def>

<%def name="list_table_chooser(files, path, current_request_path)">
  ${_table(files, path, current_request_path, 'chooser')}
</%def>

<%def name="list_table_browser(files, path, current_request_path, cwd_set=True)">
  ${_table(files, path, current_request_path, 'view')}
</%def>

<%def name="_table(files, path, current_request_path, view)">
    <script src="/static/ext/js/knockout-2.0.0.js" type="text/javascript" charset="utf-8"></script>
    <script src="/static/ext/js/moment.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/static/ext/js/datatables-paging-0.1.js" type="text/javascript" charset="utf-8"></script>
    <style type="text/css">
        .pull-right {
            margin: 4px;
        }
        .sortable {
            cursor: pointer;
        }
        .file-row {
            height:37px;
        }
        .parent {
            display: none;
        }
    </style>

    %if len(files) > 0:

    <table class="table table-condensed table-striped datatables">
        <thead>
            <tr>
                <th width="1%"><input id="selectAll" type="checkbox" data-bind="click: selectAll, checked: allSelected"/></th>
                <th class="sortable sorting" data-sort="type" width="4%">Type</th>
                <th class="sortable sorting" data-sort="name">${_('Name')}</th>
                <th class="sortable sorting" data-sort="size" width="10%">${_('Size')}</th>
                <th class="sortable sorting" data-sort="user" width="10%">${_('User')}</th>
                <th class="sortable sorting" data-sort="group" width="10%">${_('Group')}</th>
                <th width="10%">${_('Permissions')}</th>
                <th class="sortable sorting" data-sort="mtime" width="15%">${_('Date')}</th>
            </tr>
        </thead>
        <tbody id="files" data-bind="template: {name: 'fileTemplate', foreach: files}">

        </tbody>
    </table>

    ##${pagination(page)}
    %else:
        <div class="alert">
            There are no files matching the search criteria.
        </div>
    %endif

%if len(files) > 0:
    <!-- delete modal -->
    <div id="deleteModal" class="modal hide fade">
        <div class="modal-header">
            <a href="#" class="close" data-dismiss="modal">&times;</a>
            <h3>${_('Please Confirm')}</h3>
        </div>
        <div class="modal-body">
            <p>${_('Are you sure you want to delete this file?')}</p>
        </div>
        <div class="modal-footer">
            <form id="deleteForm" action="" method="POST" enctype="multipart/form-data" class="form-stacked">
                <input type="submit" value="${_('Yes')}" class="btn primary" />
                <a id="cancelDeleteBtn" class="btn">${_('No')}</a>
                <input id="fileToDeleteInput" type="hidden" name="path" />
            </form>
        </div>
    </div>

    <!-- rename modal -->
    <div id="renameModal" class="modal hide fade">
        <form id="renameForm" action="/filebrowser/rename?next=${current_request_path}" method="POST" enctype="multipart/form-data" class="form-inline form-padding-fix">
        <div class="modal-header">
            <a href="#" class="close" data-dismiss="modal">&times;</a>
            <h3>${_('Renaming:')} <span id="renameFileName">file name</span></h3>
        </div>
        <div class="modal-body">
            <label>${_('New name')} <input id="newNameInput" name="dest_path" value="" type="text" class="input-xlarge"/></label>
        </div>
        <div class="modal-footer">
            <div id="renameNameRequiredAlert" class="hide" style="position: absolute; left: 10;">
                <span class="label label-important">${_('Sorry, name is required.')}</span>
            </div>

            <input id="renameSrcPath" type="hidden" name="src_path" type="text">
            <a id="cancelRenameBtn" class="btn">${_('Cancel')}</a>
            <input type="submit" value="${_('Submit')}" class="btn primary" />
        </div>
        </form>
    </div>

    <div id="changeOwnerModal" class="modal hide fade"></div>

    <div id="changePermissionModal" class="modal hide fade"></div>

    <div id="moveModal" class="modal hide fade"></div>
%endif

<!-- upload modal -->
<div id="uploadModal" class="modal hide fade">
    <div class="modal-header">
        <a href="#" class="close" data-dismiss="modal">&times;</a>
        <h3>${_('Uploading to:')} <span id="uploadDirName">${current_dir_path}</span></h3>
    </div>
    <div class="modal-body">
        <form action="/filebrowser/upload?next=${current_dir_path}" method="POST" enctype="multipart/form-data" class="form-stacked">
            <div id="fileUploader">
            <noscript>
                <p>${_('Please enable JavaScript to use the file uploader.')}</p>
            </noscript>
            </div>
        </form>
    </div>
    <div class="modal-footer"></div>
</div>

<!-- new directory modal -->
<div id="createDirectoryModal" class="modal hide fade">
    <form id="createDirectoryForm" action="/filebrowser/mkdir?next=${current_request_path}" method="POST" enctype="multipart/form-data" class="form-inline form-padding-fix">
    <div class="modal-header">
        <a href="#" class="close" data-dismiss="modal">&times;</a>
        <h3>${_('Create Directory')}</h3>
    </div>
    <div class="modal-body">
        <label>${_('Directory Name')} <input id="newDirectoryNameInput" name="name" value="" type="text" class="input-xlarge"/></label>
        <input type="hidden" name="path" type="text" value="${current_dir_path}"/>
    </div>
    <div class="modal-footer">
         <div id="directoryNameRequiredAlert" class="alert-message error hide" style="position: absolute; left: 10;">
            <p><strong>${_('Sorry, directory name is required.')}</strong>
        </div>
        <a id="cancelCreateDirectoryBtn" class="btn" href="#">${_('Cancel')}</a>
        <input class="btn primary" type="submit" value="${_('Submit')}" />
    </div>
    </form>
</div>

<script type="text/javascript" charset="utf-8">
    %if len(files) > 0 :
    // ajax modal windows
    function openChownWindow(path, user, group, next){
        $.ajax({
            url: "/filebrowser/chown",
            data: {"path":path, "user":user, "group" : group, "next" : next},
            beforeSend: function(xhr){
                xhr.setRequestHeader("X-Requested-With", "Hue");
            },
            dataType: "html",
            success: function(data){
                $("#changeOwnerModal").html(data);
                $("#changeOwnerModal").modal({
                    keyboard: true,
                    show: true
                });
            }
        });
    }

    function openChmodWindow(path, mode, next){
        $.ajax({
            url: "/filebrowser/chmod",
            data: {"path":path, "mode":mode, "next" : next},
            beforeSend: function(xhr){
                xhr.setRequestHeader("X-Requested-With", "Hue");
            },
            dataType: "html",
            success: function(data){
                $("#changePermissionModal").html(data);
                $("#changePermissionModal").modal({
                    keyboard: true,
                    show: true
                });
            }
        });
    }

    function openMoveModal(src_path, mode, next){
        $.ajax({
            url: "/filebrowser/move",
            data: {"src_path":src_path, "mode":mode, "next" : next},
            beforeSend: function(xhr){
                xhr.setRequestHeader("X-Requested-With", "Hue");
            },
            dataType: "html",
            success: function(data){
                $("#moveModal").html(data);
                $("#moveModal").modal({
                    keyboard: true,
                    show: true
                });
            }
        });
    }
    %endif


    //uploader
    var num_of_pending_uploads = 0;
    function createUploader(){
        var uploader = new qq.FileUploader({
            element: document.getElementById("fileUploader"),
            action: "/filebrowser/upload",
            template: '<div class="qq-uploader">' +
                    '<div class="qq-upload-drop-area"><span>${_('Drop files here to upload')}</span></div>' +
                    '<div class="qq-upload-button">${_('Upload a file')}</div>' +
                    '<ul class="qq-upload-list"></ul>' +
                    '</div>',
            fileTemplate: '<li>' +
                    '<span class="qq-upload-file"></span>' +
                    '<span class="qq-upload-spinner"></span>' +
                    '<span class="qq-upload-size"></span>' +
                    '<a class="qq-upload-cancel" href="#">${_('Cancel')}</a>' +
                    '<span class="qq-upload-failed-text">${_('Failed')}</span>' +
                    '</li>',
            params:{
                dest: "${current_dir_path}",
                fileFieldLabel: "hdfs_file"
            },
            onComplete:function(id, fileName, responseJSON){
                num_of_pending_uploads--;
                if(num_of_pending_uploads == 0){
                    window.location = "/filebrowser/view${current_dir_path}";
                }
            },
            onSubmit:function(id, fileName, responseJSON){
                num_of_pending_uploads++;
            },
            debug: false
        });
    }

    // in your app create uploader as soon as the DOM is ready
    // don"t wait for the window to load
    window.onload = createUploader;

    function getQueryString(){
        var queryString = {};
        if (window.location.href.indexOf("?") > -1) {
            window.location.href.split("?").pop().split("&").forEach(function (prop) {
                var item = prop.split("=");
                queryString[item.shift()] = item.shift();
            });
        }
        return queryString;
    }

    function setQueryString(queryString){
        var qs = "?"
        for (var key in queryString) {
            qs += key + "=" + queryString[key] + "&";
        }
        return qs.substring(0, qs.length - 1);
    }

    $(document).ready(function(){
        var qs = getQueryString();

    %if len(files) > 0:
        if (qs["sortby"] == null){
            qs["sortby"] = "name";
        }

        var el = $(".sortable[data-sort=" + qs["sortby"] + "]");
        el.removeClass("sorting");
        if (qs["descending"] != null && qs["descending"] == "true") {
            el.addClass("sorting_desc");
        }
        else {
            el.addClass("sorting_asc");
        }


        $(".sortable").click(function(){
            qs["sortby"] = $(this).data("sort");
            if ($(this).hasClass("sorting_asc")) {
                qs["descending"] = "true";
            }
            else {
                delete qs["descending"];
            }
            location.href = setQueryString(qs);
        });

        $("#pagesize").val("${pagesize}");
        $("#pagesize").change(function(){
            qs["pagenum"] = "1";
            qs["pagesize"] = $("#pagesize").val();
            location.href = setQueryString(qs);
        });

        //delete handlers
        $(".delete").live("click", function(e){
            $("#fileToDeleteInput").attr("value", $(e.target).attr("file-to-delete"));
            $("#deleteForm").attr("action", "/filebrowser/" + $(e.target).attr("delete-type") + "?next=" + encodeURI("${current_request_path}") + "&path=" + encodeURI(""));
            $("#deleteModal").modal({
                keyboard: true,
                show: true
            });
        });

        $("#cancelDeleteBtn").click(function(){
            $("#deleteModal").modal("hide");
        });

        //rename handlers
        $(".rename").live("click",function(eventObject){
            $("#renameSrcPath").attr("value", $(eventObject.target).attr("file-to-rename"));
            $("#renameFileName").text($(eventObject.target).attr("file-to-rename"));
            $("#newNameInput").val($(eventObject.target).attr("file-to-rename"));
            $("#renameModal").modal({
                keyboard: true,
                show: true
            });
        });

        $("#cancelRenameBtn").click(function(){
            $("#renameModal").modal("hide");
        });

        $("#renameForm").submit(function(){
            if($("#newNameInput").val() == ""){
                $("#renameNameRequiredAlert").show();
                $("#newNameInput").addClass("fieldError");
                return false;
            }
        });

        $("#newNameInput").focus(function(){
            $("#renameNameRequiredAlert").hide();
            $("#newNameInput").removeClass("fieldError");
        });

        $("#moveForm").live("submit", function(){
            if ($.trim($("#moveForm").find("input[name='dest_path']").val()) == ""){
                $("#moveNameRequiredAlert").show();
                $("#moveForm").find("input[name='dest_path']").addClass("fieldError");
                return false;
            }
            return true;
        });

        $("#moveForm").find("input[name='dest_path']").live("focus", function(){
            $("#moveNameRequiredAlert").hide();
            $("#moveForm").find("input[name='dest_path']").removeClass("fieldError");
        });

        $(".parent").prependTo("#files").removeClass("parent");
        $("#files").removeClass("hide");
        $("a[data-row-selector='true']").jHueRowSelector();
    %endif

        //upload handlers
        $(".upload-link").click(function(){
            $("#uploadModal").modal({
                keyboard: true,
                show: true
            });
        });

        //create directory handlers
        $(".create-directory-link").click(function(){
            $("#createDirectoryModal").modal({
                keyboard: true,
                show: true
            });
        });

        // handle search
        $(".search-query").keydown(function(e){
            if (e.keyCode == 13){
                $(".filter").click();
            }
        });

        $(".filter").click(function(){
            qs["filter"] = $(".search-query").val();
            qs["pagenum"] = "1";
            location.href = setQueryString(qs);
        });

        $("#cancelCreateDirectoryBtn").click(function(){
            $("#createDirectoryModal").modal("hide");
        });

        $("#createDirectoryForm").submit(function(){
            if ($.trim($("#newDirectoryNameInput").val())==""){
                $("#directoryNameRequiredAlert").show();
                $("#newDirectoryNameInput").addClass("fieldError");
                return false;
            }
            return true;
        });

        $("#newDirectoryNameInput").focus(function(){
            $("#newDirectoryNameInput").removeClass("fieldError");
            $("#directoryNameRequiredAlert").hide();
        });

        $(".pathChooser").click(function(){
            var self = this;
            $("#fileChooserRename").jHueFileChooser({
                initialPath: $(self).val(),
                onFileChoose: function(filePath) {
                    $(self).val(filePath);
                },
                onFolderChange: function(folderPath){
                    $(self).val(folderPath);
                },
                createFolder: false,
                uploadFile: false
            });
            $("#fileChooserRename").slideDown();
        });

        $("*[rel='tooltip']").tooltip();
    });


    $.getJSON("${current_request_path}?format=json", function(data){
        ko.applyBindings(new FileBrowserModel(data.files));
    });

    var File = function(file){
        return {
            name: file.name,
            path: file.path,
            url: file.url,
            type: file.type,
            permissions: file.rwx,
            stats: {
                size: file.stats.size,
                user: file.stats.user,
                group: file.stats.group,
                mtime: moment.unix(file.stats.mtime).format("MMMM DD, YYYY hh:mm a")
            },
            selected: ko.observable(false)
        }
    }

    var FileBrowserModel = function(files) {
        var self = this;

        self.files = ko.observableArray(ko.utils.arrayMap(files, function(file) {
            return new File(file);
        }));

        self.saelectedFiles = ko.observableArray();

        self.allSelected = ko.observable(false);

        self.selectAll = function() {
            ko.utils.arrayForEach(self.files(), function(file) {
                file.selected(!self.allSelected());
            });
            return true;
        }

        self.selectedFiles = ko.computed(function() {
            return ko.utils.arrayFilter(self.files(), function(file) {
                return file.selected();
            });
        }, self);


        self.viewFile = function(file) {
            location.href = "/filebrowser/view/" + encodeURIComponent(file.path);
        };

    };

</script>

<script id="fileTemplate" type="text/html">
    <tr>
        <td class="center" data-row-selector-exclude="true">
            <input data-bind="value: path, checked: selected, visible: name!='..'" type="checkbox" data-row-selector-exclude="true"  />
        </td>
        <td class="right"><i data-bind="css: {'icon-file': type == 'file', 'icon-folder-close': type != 'file'}"></i></td>
        <td>
            <h5><a href="#" data-row-selector="true" data-bind="click: $root.viewFile, text: name"></a></h5>
        </td>
        <td>
            <span data-bind="visible: type=='file', text: stats.size"></span>
        </td>
        <td data-bind="text: stats.user"></td>
        <td data-bind="text: stats.group"></td>
        <td data-bind="text: permissions"></td>
        <td data-bind="text: stats.mtime"></td>
    </tr>
</script>

</%def>
