import random
from helper_func import get_random_element_by_proba
import math

class KBanditEnvironment :
    '''
    Environment for k-armed bandit problem with stationary gaussian distributed rewards
    '''
    def __init__ (self) :
        self.arms: list[KBanditEnvironmentArm] = []
    
    def add_arm(self, mean: float, stdev: float):
        self.arms.append(KBanditEnvironmentArm(mean, stdev))

    def get_arm_count(self):
        return len(self.arms)
    
    def generate_reward_by_arm(self, arm_index: int):
        return self.arms[arm_index].generate_reward()


class KBanditEnvironmentArm :
    '''
    Arm of k-armed bandit environment
    '''
    def __init__ (self, mean: float, stdev: float) :
        self.mean = mean
        self.stdev = stdev
        
    def generate_reward(self):
        reward = random.gauss(self.mean, self.stdev)
        return reward
    
class KBanditBaseAgent :
    '''
    Base class for k-armed bandit agent
    '''
    def __init__ (self, Environment: KBanditEnvironment) :
        self.environment = Environment
        self.action_type = "epsilon_greedy"
        self.q_values = [0 for _ in range(self.environment.get_arm_count())]
        self.action_count = [0 for _ in range(self.environment.get_arm_count())]
        self.preferences = [1 for _ in range(self.environment.get_arm_count())]
        self.total_reward = 0
        self.action_sequence = []
        self.reward_sequence = []

        # default epsilon greedy paramter
        self.epsilon = 0

        # default ucb parameter
        self.c = 2

        # default gradient parameter
        self.alpha = 0.1

    def add_q_values(self, q0: int) :
        self.q_values = [q + q0 for q in self.q_values]

    def set_epsilon(self, epsilon: float):
        self.epsilon = epsilon

    def set_ucb_parameter(self, c: float):
        self.c = c

    def set_gradient_parameter(self, alpha: float):
        self.alpha = alpha

    def epsilon_greedy_action(self):
        if random.random() < self.epsilon:
            return random.randint(0, self.environment.get_arm_count() - 1)
        else:
            return self.q_values.index(max(self.q_values))
        
    def UCB_action(self):
        total_action_count = sum(self.action_count)
        ucb_values = [(self.q_values[i] + self.c * (math.log(total_action_count) / self.action_count[i]) ** 0.5) if not self.action_count[i] == 0 else self.q_values[i]  for i in range(self.environment.get_arm_count())]
        return ucb_values.index(max(ucb_values))
    
    def gradient_action(self):
        total_pref = sum(self.preferences)
        probas = [self.preferences[i] / total_pref for i in range(self.environment.get_arm_count())]
        return get_random_element_by_proba(list(range(self.environment.get_arm_count())), probas)
    
    def set_action_type(self, action_type: str):
        if action_type == "epsilon_greedy":
            self.take_action = self.epsilon_greedy_action
        elif action_type == "UCB":
            self.take_action = self.UCB_action
        elif action_type == "gradient":
            self.take_action = self.gradient_action
        else:
            raise ValueError("Invalid action type")
        self.action_type = action_type

    def take_action(self): 
        raise NotImplementedError("Subclass must implement abstract method")
    
    def get_total_reward(self):
        return self.total_reward
    
    def run(self, n_Step: int): 
        for _ in range(n_Step):
            action = self.take_action()
            reward = self.environment.generate_reward_by_arm(action)
            self.action_sequence.append(action)
            self.reward_sequence.append(reward)
            self.total_reward += reward
            self.action_count[action] += 1
            self.q_values[action] += (reward - self.q_values[action]) / self.action_count[action]

            # update preferences for gradient bandit
            if self.action_type == "gradient":
                avg_reward = self.total_reward / sum(self.action_count)
                for i in range(self.environment.get_arm_count()):
                    if i == action:
                        self.preferences[i] += self.alpha * (reward - avg_reward) * (1 - self.preferences[i])
                    else:
                        self.preferences[i] -= self.alpha * (reward - avg_reward) * self.preferences[i]
        return self.total_reward
    
    def get_reward_sequence(self):
        return self.reward_sequence
    
    def get_action_sequence(self):
        return self.action_sequence

    
    