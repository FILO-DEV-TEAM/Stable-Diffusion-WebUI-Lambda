from modules import launch_utils, initialize, initialize_util, script_callbacks
from mangum import Mangum
from fastapi import FastAPI
import sys
from modules import timer


def create_api(app):
    from modules.api.api import Api
    from modules.call_queue import queue_lock
    api = Api(app, queue_lock)
    return api

sys.argv.append("--listen")
sys.argv.append("--no-half")
sys.argv.append("--no-half-vae")
sys.argv.append("--use-cpu=all")
sys.argv.append("--skip-torch-cuda-test")
sys.argv.append("--nowebui")
sys.argv.append("--skip-prepare-environment")

startup_timer = timer.startup_timer
startup_timer.record("launcher")

initialize.imports()

initialize.check_versions()


print('debug 1')
initialize.initialize() # Loading weights in... Model loaded in...
print('debug 2')
app = FastAPI()
print('debug 3')
initialize_util.setup_middleware(app)
print('debug 4')
api = create_api(app)
print('debug 5')

script_callbacks.before_ui_callback()
print('debug 6')
script_callbacks.app_started_callback(None, app)
print('debug 7')

handler = Mangum(app)
print('debug 8')