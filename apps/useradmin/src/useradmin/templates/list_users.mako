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
from django.template.defaultfilters import date, time
import urllib
from django.utils.translation import ugettext as _
%>

<%namespace name="layout" file="layout.mako" />
${commonheader(_('Hue Users'), "useradmin", "100px")}
${layout.menubar(section='users', _=_)}

<div class="container-fluid">
    <h1>${_('Hue Users')}</h1>
    <div class="well hueWell">
        <div class="btn-group pull-right">
            %if user.is_superuser == True:
            <a href="${ url('useradmin.views.edit_user') }" class="btn">${_('Add user')}</a>
            <a href="${ url('useradmin.views.add_ldap_user') }" class="btn">${_('Add/Sync LDAP user')}</a>
            <a href="javascript:void(0)" class="btn confirmationModal" data-confirmation-url="${ url('useradmin.views.sync_ldap_users_groups') }">${_('Sync LDAP users/groups')}</a>
            %endif
        </div>
        <form class="form-search">
            ${_('Filter: ')}<input type="text" id="filterInput" class="input-xlarge search-query" placeholder="${_('Search for username, name, e-mail, etc...')}">
        </form>
    </div>
    <table class="table table-striped datatables">
        <thead>
            <tr>
                <th>${_('Username')}</th>
                <th>${_('First Name')}</th>
                <th>${_('Last Name')}</th>
                <th>${_('E-mail')}</th>
                <th>${_('Groups')}</th>
                <th>${_('Last Login')}</th>
                <th>&nbsp;</th>
            </tr>
        </thead>
        <tbody>
        % for listed_user in users:
            <tr class="userRow" data-search="${listed_user.username}${listed_user.first_name}${listed_user.last_name}${listed_user.email}${', '.join([group.name for group in listed_user.groups.all()])}">
                <td>${listed_user.username}</td>
                <td>${listed_user.first_name}</td>
                <td>${listed_user.last_name}</td>
                <td>${listed_user.email}</td>
                <td>${', '.join([group.name for group in listed_user.groups.all()])}</td>
                <td>${date(listed_user.last_login)} ${time(listed_user.last_login).replace("p.m.","PM").replace("a.m.","AM")}</td>
                <td class="right">
                <%
                    i18n_editUsername = _('Edit %(username)s') % {'username': listed_user.username}
                    i18n_deleteUsername = _('Delete %(username)s') % {'username': listed_user.username}
                %>
                %if user.is_superuser == True:
                    <a title="${_('Edit %(username)s') % dict(username=listed_user.username)}" class="btn small" href="${ url('useradmin.views.edit_user', username=urllib.quote(listed_user.username)) }" data-row-selector="true">${_('Edit')}</a>
                    <a title="${_('Delete %(username)s') % dict(username=listed_user.username)}" class="btn small confirmationModal" alt="Are you sure you want to delete ${listed_user.username}?" href="javascript:void(0)" data-confirmation-url="${ url('useradmin.views.delete_user', username=urllib.quote_plus(listed_user.username)) }">${_('Delete')}</a>
                %else:
                    %if user.username == listed_user.username:
                        <a title="${_('Edit %(username)s') % dict(username=listed_user.username)}" class="btn small" href="${ url('useradmin.views.edit_user', username=urllib.quote(listed_user.username)) }">Edit</a>
                    %else:
                        &nbsp;
                    %endif
                %endif
                </td>
            </tr>
        % endfor
        </tbody>
    </table>

    <div id="syncLdap" class="modal hide fade"></div>

    <div id="deleteUser" class="modal hide fade"></div>

</div>

    <script type="text/javascript" charset="utf-8">
        $(document).ready(function(){
            $(".datatables").dataTable({
                "bPaginate": false,
                "bLengthChange": false,
                "bInfo": false,
                "bFilter": false,
                "aoColumns": [
                        null,
                        null,
                        null,
                        null,
                        null,
                        { "sType": "date" },
                        { "bSortable": false }
                    ]
            });
            $(".dataTables_wrapper").css("min-height","0");
            $(".dataTables_filter").hide();

            $(".confirmationModal").click(function(){
                var _this = $(this);
                $.ajax({
                    url: _this.attr("data-confirmation-url"),
                    beforeSend: function(xhr){
                        xhr.setRequestHeader("X-Requested-With", "Hue");
                    },
                    dataType: "html",
                    success: function(data){
                        $("#deleteUser").html(data);
                        $("#deleteUser").modal("show");
                    }
                });
            });

            $("#filterInput").keyup(function(){
                $.each($(".userRow"), function(index, value) {
                  if($(value).data("search").toLowerCase().indexOf($("#filterInput").val().toLowerCase()) == -1 && $("#filterInput").val() != ""){
                    $(value).hide(250);
                  }else{
                    $(value).show(250);
                  }
                });
            });

            $("a[data-row-selector='true']").jHueRowSelector();
        });
    </script>

${commonfooter(messages)}
