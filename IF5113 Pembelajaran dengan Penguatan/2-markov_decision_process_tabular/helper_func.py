import random

def get_random_element_by_proba(elements: list, probas: list):
    if len(elements) != len(probas):
        raise ValueError("Length of elements and probas must be the same")
    if sum(probas) != 1:
        raise ValueError("Sum of probas must be 1")
    rand_num = random.random()
    prob_sum = 0
    for i in range(len(probas)):
        prob_sum += probas[i]
        if rand_num < prob_sum:
            return elements[i]
    return elements[-1]