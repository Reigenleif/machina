import helper_func as hf

class MDPSystem() :
    def __init__(self) -> None:
        self.environment = MDPEnvironment()
    
class MDPEnvironment() :
    def __init__(self) -> None:
        self.states = []
        self.actions = []
        self.rewards = []
        self.transitions = []
    def add_state(self, state: str|int):
        if state not in self.states:
            self.states.append(state)

    def get_all_states(self):
        return self.states
    
    def add_action(self, action: str|int):
        if action not in self.actions:
            self.actions.append(action)

    def get_all_actions(self):
        return self.actions

    def set_state_transition_proba(self, state: str|int, action: str|int, next_state: str|int, proba: float):
        if state not in self.states:
            self.add_state(state)
        if next_state not in self.states:
            self.add_state(next_state)
        if action not in self.actions:
            self.actions.append(action)
        self.transitions.append((state, action, next_state, proba))
        
    def get_state_transition_proba(self, state: str|int, action: str|int, next_state: str|int):
        for s, a, ns, proba in self.transitions:
            if s == state and a == action and ns == next_state:
                return proba
        return 0
    
    def set_reward(self, state: str|int, action: str|int, reward: float, proba: float):
        self.rewards.append((state, action, reward, proba))

    def get_reward(self, state: str|int, action: str|int):
        prob_sum = 0
        rewards = []
        probas = []
        for s, a, r, proba in self.rewards:
            if s == state and a == action:
                rewards.append(r)
                probas.append(proba)
                prob_sum += proba

        if prob_sum != 1:
            probas = [proba/prob_sum for proba in probas]

        return hf.get_random_element_by_proba(rewards, probas)
    

class MDPAgent() :
    def __init__(self) -> None:
        self.policy = {}
        self.value_estimates = {}
        self.gamma = 0.9

    def set_policy(self, state: str|int, action: str|int, proba):
        self.policy[(state, action)] = proba

    def get_policy(self, state: str|int, action: str|int):
        return self.policy[(state, action)]
    
    def set_value_estimate(self, state: str|int, value: float):
        self.value_estimates[state] = value

    def take_action(self, state: str|int, environment: MDPEnvironment):
        actions = environment.get_all_actions()
        action_values = []
        for action in actions:
            action_value = 0
            for next_state in environment.get_all_states():
                action_value += environment.get_state_transition_proba(state, action, next_state) * (environment.get_reward(state, action) + self.gamma * self.value_estimates[next_state])
            action_values.append(action_value)
        return actions[action_values.index(max(action_values))]