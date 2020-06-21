from blockchain import block
import random

def choose_random_ID(category):
    total = block.get_total()
    if total==0:
        return None
    total_in_cat = 0

    all_cats = list(range(1,7))
    while total_in_cat==0:
        if category==0:
            category = random.randint(1,6)
            all_cats.remove(category)
        total_in_cat = block.get_total(category)

    ID = random.randint(0,total_in_cat-1)
    return ID
