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
    title = request.args.get('title', '')
    submitter = block.CONTRACT_ADDRESS
    category = int(request.args.get('category'))
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
def submiturl():
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
