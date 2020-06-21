import os
os.system('brownie networks add Ethereum maticv3 chainid=15001 host=https://testnetv3.matic.network')
from brownie import Contract, network, web3
from brownie.network import accounts
from . import abi
import json

ETH_WALLET_KEY = os.environ['ETH_WALLET_KEY']
CONTRACT_ADDRESS = os.environ['CONTRACT_ADDRESS']


abi = abi.abi
abi = json.loads(abi)
network.connect('maticv3')
network.gas_limit(0)
accounts.add(ETH_WALLET_KEY)
my_contract = Contract("TakeMeTo", CONTRACT_ADDRESS, abi=abi, owner=accounts[0])



def get_total(category=0):
    return my_contract.gettotal(category, {'from': accounts[0]})

def submit_url(category: int, url: str, title: str, submitter: str):
    my_contract.submitUrl(category, url, rating, title, submitter, {'from': accounts[0]})

def get_url(ID: int, category=0):
    return my_contract.getURL(ID, category, {'from': accounts[0]})


def cast_vote(ID: int, validator_addr: str, upvote: bool, num_of_tokens: int):
    #upvote is true -> upvote, else downvote
    return my_contract.Vote(ID, validator_addr, upvote, num_of_tokens, {'from': accounts[0]})


def claim_reward(ID, user):
    return my_contract.claimReward(user, ID, {'from': accounts[0]})

def reward_user(addr, tokens: int):
    transferFrom(CONTRACT_ADDRESS, addr, tokens)


def remove_stakes(ID: int, validator_addr:str):
    return my_contract.Vote(ID, validator_addr, {'from': accounts[0]})


def total_supply():
    return int(my_contract.totalSupply({'from': accounts[0]}))

def get_balance(address: str):
    return my_contract.balanceOf(address, {'from': accounts[0]})


def get_contract_address():
    return str(my_contract.get_contract_address({'from': accounts[0]}))

def staking_status(ID):
    return my_contract.stakingStatus(ID, {'from': accounts[0]})

def transferFrom(from_addr: str, to_addr: str, num_of_tokens: int):
    my_contract.transferFrom(from_addr, to_addr, num_of_tokens, {'from': accounts[0]})
