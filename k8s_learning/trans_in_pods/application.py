from flask import Flask
from flask_redis import FlaskRedis
import time
import os


if os.environ.get("envname") == "k8s": # 说明是在k8s中
    REDIS_URL = "redis://{}:{}/{}".format('10.1.0.59', 6379, 1)
else:
    REDIS_URL = "redis://{}:{}/{}".format('127.0.0.1', 6380, 1)

app = Flask(__name__)
app.config['REDIS_URL'] = REDIS_URL
redis_client = FlaskRedis(app)

@app.route("/")
def index_handle():
    redis_client.set("reidstest",time.strftime("%Y-%m-%d %H:%M:%S",time.localtime(time.time())))
    name = redis_client.get("reidstest").decode()
    return "hello %s"% name

app.run(host='0.0.0.0', port=6000, debug=True)