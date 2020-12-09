from flask import Flask
import psycopg2

from config import *

app = Flask(__name__)
@app.route('/health')
def health_check():
    return 'OK'

@app.route('/ready')
def ready_check():
    try:
        conn = psycopg2.connect(host=host, dbname=dbname, user=user, 
                                                password=password)
        return 'OK'
    except Exception as e:
        return str(e), 503

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
