import helper_func as hf

class MDPBasicEnvironment :
    '''
    Basic Markov Decision Process Environment that consist of
    - states
    - available actions, given current state
    - transition probability for the next state, given (state, action) pair
    - constant rewards for each given (state, action) pair
    '''

    def __init__(self) :
        self.states = []
        self.actions_state = {}
        self.state_state_map = {}
        self.t_proba = {}
        self.rewards = {}
        self.initial_state = None

    def add_state(self, state: str | int) :
        self.states.append(state)

    def set_states(self, states: list[str | int]) :
        self.states = states

    def add_state_state_conn(self, state1: str | int, state2: str | int) :
        if not state1 in self.state_state_map.keys() :
            self.state_state_map[state1] = []
        self.state_state_map[state1].append(state2)

    def set_initial_state(self, state: str | int) :
        self.initial_state = state

    def add_transition(self, state, action, next_state, proba) :
        # Check if action is available in the available action list for the state
        if not state in self.actions_state.keys() :
            self.actions_state[state] = []
        if not action in self.actions_state[state] :
            self.actions_state[state].append(action)

        # Add transition probability
        if not (state, action) in self.t_proba.keys() :
            self.t_proba[(state, action)] = {}
        self.t_proba[(state, action)][next_state] = proba
        
    def add_reward(self, state, action, reward) :
        if (state, action) in self.rewards.keys() :
            return
        self.rewards[(state, action)] = reward

    def get_next_state(self, state, action) :
        if not (state, action) in self.t_proba.keys() :
            return None
        return hf.get_random_element_by_proba(
            list(self.t_proba[(state, action)].keys()),
            list(self.t_proba[(state, action)].values())
        )

    def get_reward(self, state, action) :
        if not (state, action) in self.rewards.keys() :
            return 0
        return self.rewards[(state, action)]
    
    def get_states(self) :
        return self.states
    
    def get_actions(self, state) :
        if not state in self.actions_state.keys() :
            return []
        return self.actions_state[state]
    
    def get_state_state_map(self) :
        return self.state_state_map
                
class MDPBasicAgent :
    '''
    Basic Markov Decision Process Agent that consist of
    - states
    - actions
    - policy, using maxxing value function
    - value function
    '''

    def __init__(self, environment: MDPBasicEnvironment) :
        self.states = environment.get_states()
        self.policy = {}
        self.value_function = {}
        self.action_value_function = {}
        self.state_state_map = {}
        for state in self.states :
            self.policy[state] = {}
            self.value_function[state] = 0
            self.action_value_function[state] = {}
            for action in environment.get_actions(state) :
                self.policy[state][action] = 1 / len(environment.get_actions(state))
                self.action_value_function[state][action] = 0
        self.environment = environment

        self.current_state = environment.initial_state

        self.total_reward = 0
        self.reward_sequence = []
        self.action_sequence = []
        self.state_state_t_count = {}
        for state in self.states :
            self.state_state_t_count[state] = {}
            for next_state in environment.state_state_map[state] :
                self.state_state_t_count[state][next_state] = 0

       

    def set_policy(self, state, action, proba) :
        self.policy[state][action] = proba

    def set_value_function(self, state, value) :
        self.value_function[state] = value

    def set_action_value_function(self, state, action, value) :
        self.action_value_function[state][action] = value

    def get_policy(self, state, action) :
        return self.policy[state][action]
    
    def get_value_function(self, state) :
        return self.value_function[state]
    
    def get_action_value_function(self, state, action) :
        return self.action_value_function[state][action]
    
    def get_current_state(self) :
        return self.current_state
    
    def take_action(self) :
        if self.current_state == None :
            raise ValueError("Current state is not defined")
        action = hf.get_random_element_by_proba(
            list(self.policy[self.current_state].keys()),
            list(self.policy[self.current_state].values())
        )

        next_state = self.environment.get_next_state(self.current_state, action)
        reward = self.environment.get_reward(self.current_state, action)

        # Update value function with bellman equation
        self.value_function[self.current_state] = reward + self.value_function[next_state]

        # Evaluate 
        self.state_state_t_count[self.current_state][next_state] += 1
        self.current_state = next_state
        self.total_reward += reward
        self.reward_sequence.append(reward)
        self.action_sequence.append(action)

    
    


    








    