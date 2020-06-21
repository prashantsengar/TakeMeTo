from flask import Flask, request, jsonify
from blockchain import block
import utils

app = Flask(__name__)


@app.route('/')
def home():
    return 'hello world'

@app.route('/submit', methods=['POST'])
def submiturl():
    url = request.args.get('url')
    app.logger.warning(url)
    title = request.args.get('title', '')
    app.logger.warning(title)
    submitter = block.CONTRACT_ADDRESS
    category = int(request.args.get('category'))
    app.logger.warning(category)
    if not 1<=category<=6:
        return jsonify({'success': False, 'message':'category should be between 1 and 6'})

    url = url.lstrip('https://').lstrip('http://').lstrip('www.').rstrip('/')

    try:
        block.submit_url(category, url, title, submitter)
    except Exception as e:
        app.logger.error(e)
        return jsonify({'success': False, 'message':'blockchain error'})
    return jsonify({'success': True, 'message':'successfully submitted'})


@app.route('/takemeto', methods=['GET'])
def geturl():
    category = request.args.get('category', 0)

    ID = utils.choose_random_ID(category)
    if ID==None:
        return jsonify({'success': True, 'message':'no urls, submit and URL'})

    try:
        url = block.get_url(ID, category)
    except Exception as e:
        app.logger.error(e)
        return jsonify({'success': False, 'message':'blockchain error'})

    return url

@app.route('/vote', methods=['POST'])
def vote():
    ID = int(request.args.get('ID'))
    up = bool(request.args.get('upvote'))
    addr = request.args.get('addr')
    tokens = int(request.args.get('votes'))

    try:
        block.cast_vote(ID, addr, up, tokens)
    except Exception as e:
        app.logger.error(e)
        return jsonify({'success': False, 'message':'blockchain error', 'error':e})

    return jsonify({'success': True, 'message':'successfully voted'})

@app.route('/removestakes', methods=['POST'])
def removestakes():
    ID = int(request.args.get('ID'))
    addr = request.args.get('addr')

    try:
        block.remove_stakes(ID, addr)
    except Exception as e:
        app.logger.error(e)
        return jsonify({'success': False, 'message':'blockchain error', 'error':e})

    return jsonify({'success': True, 'message':'successfully removed stakes'})

@app.route('/claimreward', methods=['POST'])
def claim_reward():
    ID = int(request.args.get('ID'))
    addr = request.args.get('addr')

    try:
        block.claim_reward(ID, addr)
    except Exception as e:
        app.logger.error(e)
        return jsonify({'success': False, 'message':'blockchain error', 'error':e})

    return jsonify({'success': True, 'message':'successfully claimed reward'})


@app.route('/isstaked', methods=['GET'])
def is_staked():
    ID = int(request.args.get('ID'))

    try:
        status = block.staking_status(ID)
    except Exception as e:
        app.logger.error(e)
        return jsonify({'success': False, 'message':'blockchain error', 'error':e})

    return jsonify({'success': True, 'status':status})


if __name__=='__main__':

    app.run('localhost', port=8080, debug=True)
