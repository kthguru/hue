#!/usr/bin/env python
# Licensed to Cloudera, Inc. under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Cloudera, Inc. licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from desktop.lib.django_util import render
from django.http import HttpResponse
import logging
import simplejson
import shell.conf
import shell.constants as constants
import shell.utils as utils
from shell.shellmanager import ShellManager
import sys

SHELL_OUTPUT_LOGGER = logging.getLogger("shell_output")
SHELL_INPUT_LOGGER = logging.getLogger("shell_input")

def _running_with_spawning(request):
  return 'eventlet.input' in request.META

def index(request):
  if not _running_with_spawning(request):
    return render('not_running_spawning.mako', request, {})
  shell_manager = ShellManager.global_instance()
  result = shell_manager.available_shell_types(request.user)
  if result is None:
    return render('no_such_user.mako', request, {})
  return render('index.mako', request, {'shells':result})

def create(request):
  if not _running_with_spawning(request):
    if request.method == "POST":
      result = simplejson.dumps({ constants.NOT_RUNNING_SPAWNING : True })
      return HttpResponse(result, mimetype="application/json")
    else:
      return render('not_running_spawning.mako', request, {})
  shell_manager = ShellManager.global_instance()
  user = request.user
  if request.method == "POST":
    key_name = request.POST.get(constants.KEY_NAME, "")
  else:
    key_name = request.GET.get(constants.KEY_NAME, "")
  SHELL_INPUT_LOGGER.info("%s %s - Request to create shell of type '%s'" % 
                (request.META.get('REMOTE_ADDR'), user.username, key_name))
  result = shell_manager.try_create(user, key_name)
  if request.method == "POST":
    return HttpResponse(simplejson.dumps(result), mimetype="application/json")
  else:
    if constants.SUCCESS in result:
      shell_types = shell_manager.available_shell_types(user)
      dict_for_template = { 'shells' : shell_types,
                            'shell_id' : result.get(constants.SHELL_ID) }
      return render('index.mako', request, dict_for_template)
    else:
      return render('failed_to_create.mako', request, {})

def kill_shell(request):
  if not _running_with_spawning(request):
    result = simplejson.dumps({ constants.NOT_RUNNING_SPAWNING : True })
    return HttpResponse(result, mimetype="application/json")
  shell_manager = ShellManager.global_instance()
  username = request.user.username
  shell_id = request.POST[constants.SHELL_ID]
  SHELL_INPUT_LOGGER.info("%s %s - Request to kill shell with shell ID %s" % 
                 (request.META.get('REMOTE_ADDR'), username, shell_id))
  result = shell_manager.kill_shell(username, shell_id)
  return HttpResponse(result)

def restore_shell(request):
  if not _running_with_spawning(request):
    result = simplejson.dumps({ constants.NOT_RUNNING_SPAWNING : True })
    return HttpResponse(result, mimetype="application/json")
  shell_manager = ShellManager.global_instance()
  username = request.user.username
  shell_id = request.POST[constants.SHELL_ID]
  SHELL_OUTPUT_LOGGER.info("%s %s - Request to restore shell with shell ID %s" %
                      (request.META.get('REMOTE_ADDR'), username, shell_id))
  result = simplejson.dumps(shell_manager.get_previous_output(username, shell_id))
  SHELL_OUTPUT_LOGGER.info("%s %s - Reply to restore shell with ID %s : '%s'" %
              (request.META.get('REMOTE_ADDR'), username, shell_id, result))
  return HttpResponse(result, mimetype="application/json")

def process_command(request):
  if not _running_with_spawning(request):
    result = simplejson.dumps({ constants.NOT_RUNNING_SPAWNING : True })
    return HttpResponse(result, mimetype="application/json")
  shell_manager = ShellManager.global_instance()
  username = request.user.username
  shell_id = request.POST[constants.SHELL_ID]
  command = request.POST.get(constants.COMMAND, "")
  SHELL_INPUT_LOGGER.info("%s %s - Received command '%s' for shell ID '%s'" %
              (request.META.get('REMOTE_ADDR'), username, command, shell_id))
  result = shell_manager.process_command(username, shell_id, command)
  return HttpResponse(simplejson.dumps(result), mimetype="application/json")

def retrieve_output(request):
  if not _running_with_spawning(request):
    result = simplejson.dumps({ constants.NOT_RUNNING_SPAWNING : True })
    return HttpResponse(result, mimetype="application/json")
  shell_manager = ShellManager.global_instance()
  username = request.user.username
  hue_instance_id = request.META[constants.HUE_INSTANCE_ID]
  try:
    shell_pairs = utils.parse_shell_pairs(request)
  except ValueError:
    shell_pairs = []
  SHELL_OUTPUT_LOGGER.info("%s %s - Request for output with parameters '%s'" %
              (request.META.get('REMOTE_ADDR'), username, repr(request.POST)))
  result = simplejson.dumps(shell_manager.retrieve_output(username, hue_instance_id, shell_pairs))
  SHELL_OUTPUT_LOGGER.info("%s %s - Reply to request with parameters '%s' : '%s'" %
              (request.META.get('REMOTE_ADDR'), username, repr(request.POST), result))
  return HttpResponse(result, mimetype="application/json")

def add_to_output(request):
  if not _running_with_spawning(request):
    result = simplejson.dumps({ constants.NOT_RUNNING_SPAWNING : True })
    return HttpResponse(result, mimetype="application/json")
  shell_manager = ShellManager.global_instance()
  username = request.user.username
  hue_instance_id = request.META[constants.HUE_INSTANCE_ID]
  try:
    shell_pairs = utils.parse_shell_pairs(request)
  except ValueError:
    shell_pairs = []
  SHELL_OUTPUT_LOGGER.info("%s %s - Request to add new shells to output request with params '%s'" %
              (request.META.get('REMOTE_ADDR'), username, repr(request.POST)))
  result = simplejson.dumps(shell_manager.add_to_output(username, hue_instance_id, shell_pairs))
  SHELL_OUTPUT_LOGGER.info("%s %s - Reply to request for additional shells with params '%s' : '%s'" %
              (request.META.get('REMOTE_ADDR'), username, repr(request.POST), result))
  return HttpResponse(result, mimetype="application/json")

