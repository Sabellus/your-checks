import psycopg2
from psycopg2.extras import RealDictCursor
from flask import make_response, Flask, jsonify, request
import json
import uuid
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime, timedelta, time
import jwt
from functools import wraps
app = Flask(__name__)
app.config['SECRET_KEY'] = 'sabellus'
from database import create_connection
conn = create_connection()

class User:
    def __init__(self, data):        
        self.username = data['username']
        self.password = data['password_hash']        
        self.id = data['id']    

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):        
        token = None
        if 'token' in request.form:
            token = request.form['token']
        if not token:
            return jsonify({'message': 'Token is missing!'}), 401
        try:            
            data = jwt.decode(token, app.config['SECRET_KEY'])                       
            current_user = User(get_user_id(data['id']))               
        except Exception as e:
            print(e)
            return jsonify({'message' : 'Token is invalid'}), 401
        return f(current_user, *args, **kwargs)
    return decorated

def timeit(method):    
    def timed(*args, **kw):        
        start_time = datetime.now().microsecond
        result = method(*args, **kw)
        end_time = datetime.now().microsecond
        if 'log_time' in kw:            
            kw['log_time']["worktime"] = str("{0:.4f}s".format(int(end_time - start_time)/1000000))
        return result
    return timed

def take_func_time(f, current_user, limit, offset):
    logtime_data = {}
    time = f(current_user, limit, offset, log_time=logtime_data)
    time.update(logtime_data)
    return time

def limit_offset(data):
    limit = int(data['limit'])  
    offset = int(data['offset'])  
    return limit, offset

@timeit
def get_checks_data(current_user, limit, offset, **kwargs):    
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM get_checks_current_user(%s,%s,%s);' % (current_user.id, limit, offset))    
    res = {}
    res["data"] = cur.fetchall()       
    for i in res["data"]:
        cur.execute("SELECT * from get_items_definite_check(%s);" % i["id"])
        item = cur.fetchall()
        i['items'] = item        
    return res

@app.route('/checks', methods=['POST'])    
@token_required
def get_checks(current_user):
    data = request.form
    try:        
        limit, offset = limit_offset(data)
    except:
        return jsonify({'message' : 'Пераданы не все параметры или не того типа'}), 401

    result = take_func_time(get_checks_data, current_user, limit, offset)    
    result = jsonify(result)
    return result

def get_check_data(user_id,check_id):
    try:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute('SELECT * FROM get_check_id(%s, %s);' % (check_id, user_id))    
        res = {'data':cur.fetchall()}
        
        print(res)       
        for i in res["data"]:
            cur.execute("SELECT * from get_items_definite_check(%s);" % i["id"])
            item = cur.fetchall()
            i['items'] = item
        return res
    except: 
        return {'message' : 'Error, не удалось получить данные'}   
    
@app.route('/check', methods=['POST'])
@token_required
def get_check(current_user):    
    try:        
        data = request.form['check_id']    
        print(data)
        check_id = int(data)
    except:
        return jsonify({'message' : 'Пераданы не все параметры или не того типа'}), 401
    result = get_check_data(current_user.id, check_id)
    result = jsonify(result)
    return result


@app.route('/create-check', methods=['POST'])
@token_required
def create_check(current_user):
    data = request.form
    try:        
        check_name = str(data['check_name']) 
        check_date = data['check_date']
        totalsum = float(data['totalsum'])
        created_date = data['created_date']       
    except:
        return jsonify({'message' : 'Пераданы не все параметры или не того типа'}), 401
    result = create_check_data(current_user.id, check_name, check_date, totalsum,created_date)    
    return result

@app.route('/update_check', methods=['POST'])
@token_required
def update_check(current_user):
    try:
        data = request.form
        check_id = data['check_id']
        check_name = data['check_name']
        check_date = data['check_date']
        totalsum = data['totalsum']
        updated_date = data['updated_date']

        with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("SELECT * FROM update_qr_check('%s', '%s', '%s', '%s', '%s', '%s');" % (check_id, current_user.id, check_name , check_date , totalsum , updated_date))
                data = cur.fetchall()
                return jsonify({'message': 'success', 'data': data}), 200
    except Exception as e:
        jsonify({'message': str(e)}), 500

@app.route('/delete_check', methods=['POST'])
@token_required
def delete_check(current_user):
    try:
        data = request.form
        check_id = data['check_id']
        deleted_date = data['deleted_date']
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("SELECT * FROM delete_qr_check(%s, %s, '%s')" % (check_id, current_user.id, deleted_date))
                data = cur.fetchall()
                return jsonify({'message': 'success', 'data': data}), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500

def create_check_data(user_id, check_name, check_date, totalsum, created_date):    
    cur = conn.cursor(cursor_factory=RealDictCursor)
    try:
        cur.execute("SELECT * from create_qr_check(%s, '%s', '%s', '%s', %s, '%s', '%s');" % (user_id, check_name, check_date, created_date, totalsum, created_date, created_date))
        res = {}
        result = cur.fetchall()
        resid = {}
        resid['check_id'] = result[0]['create_qr_check']        
        res["data"] = resid
        return jsonify(res)
    except:        
        cur.execute("rollback")
        cur.close()
        return jsonify({'message' : 'Error, не удалось получить данные'},401)

def create_check_data(user_id,check_name,check_date,totalsum,created_date):    
    cur = conn.cursor(cursor_factory=RealDictCursor)
    try:        
        cur.execute("SELECT * from create_qr_check(%s, '%s', '%s', '%s', %s, '%s', '%s');" % (user_id, check_name, check_date, created_date, totalsum, created_date, created_date))    
        print(1)
        res = {}
        result = cur.fetchall()
        resid = {} 
        resid['check_id'] = result[0]['create_qr_check']        
        res["data"] = resid
        print(res)       
        return jsonify(res)
    except:        
        cur.execute("rollback")
        cur.close()
        return jsonify({'message' : 'Error, не удалось получить данные'},401)

   
    
def get_user(email):       
    cur = conn.cursor(cursor_factory=RealDictCursor)
    user_query = "SELECT * from get_user_email('%s');" % (email)
    cur.execute(user_query)
    result = cur.fetchall()
    if len(result) == 0:
        return None
    return result[0]

def get_user_id(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    user_query = "SELECT * from get_user_id('%s');" % (id)
    cur.execute(user_query)
    
    result = cur.fetchall()     
    return result[0]
@app.route('/user', methods=['GET'])
def get_allusers():
    return ''
@app.route('/user/<user_id>', methods=['GET'])
def get_one_user():
    return ''
@app.route('/user', methods = ['POST'])
def create_user():
    data = request.get_json(silent=True, cache=False)
    username = data['username']
    hashed_password = generate_password_hash(data['password'], method='sha256')    
    phone = data['phone']
    email = data['email']    
    if not get_user(email):
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("INSERT INTO users VALUES (default, '%s', '%s', '%s', '%s');" % (username, hashed_password, phone, email))
        conn.commit()
        return jsonify({'message': 'user created'})
    return jsonify({'message': 'user already exists'})
@app.route('/user/<user_id>', methods=['PUT'])
def promote_user():
    return ''
@app.route('/user/<user_id>', methods=['DELETE'])
def delete_user():
    return ''

@app.route('/login')
def login():    
    auth = request.authorization 
    print(auth)
    if not auth or not auth.username or not auth.password:
        return make_response('Could not verify', 401, {'WWW-Authenticate' : 'Basic realm="Login required!"'})      
    user = get_user(auth.username)
    if user is None:
        return make_response('Could not verify', 401, {'WWW-Authenticate' : 'Basic realm="Login required!"'})
    user = User(user)   
    if not user:
        return make_response('Could not verify', 401, {'WWW-Authenticate' : 'Basic realm="Login required!"'})
    if check_password_hash(user.password, auth.password):
        token = jwt.encode({'id': user.id, 'exp': datetime.utcnow() + timedelta(days=365)}, app.config['SECRET_KEY'])
        return jsonify({'token' : token.decode('UTF-8')})
    return make_response('Could not verify', 401, {'WWW-Authenticate' : 'Basic realm="Login required!"'})
if __name__ == '__main__':
    app.run(debug=True)

    #UPDATE incomings SET total = 100, updated_date = CURRENT_TIMESTAMP WHERE incomings.user_id = 1 and incomings.id = 1;
    #INSERT INTO incomings VALUES (default, 1, 'ЗП', 145.5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);