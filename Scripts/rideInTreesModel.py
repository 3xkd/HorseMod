import numpy as np
import matplotlib.pyplot as plt
from matplotlib import colormaps

BASE_CHANCE = 0.05  # Base chance of falling per second


PERKS = {
    'Eagle Eyed': 0.5,
    'Gymnast': 0.5,
    'Motion Sensitive': 2,
    'Clumsy': 2,
}

perks = [
    'Eagle Eyed',
    'Clumsy',
    'Motion Sensitive',
]

low_nimble = 1
high_nimble = 0
nimble_skill = np.linspace(low_nimble, high_nimble, 11)

time = np.linspace(0, 10, 100)

def calculate_chance(time):
    return time * BASE_CHANCE
    return (np.exp(time/4) - 1) * BASE_CHANCE

for i, skill in enumerate(nimble_skill):
    color = colormaps['coolwarm'](1-(skill-low_nimble)/(high_nimble - low_nimble))

    chance = calculate_chance(time*skill)
    plt.plot(time, chance, label=f'Nimble Skill: {i}', color=color)

plt.legend()
plt.xlabel('Time in Trees (s)')
plt.ylabel('Chance of Falling')
plt.title('Chance of Falling While Riding in Trees Over Time')
plt.grid(True)
plt.show()


chance = calculate_chance(time)
plt.plot(time, chance, label='Base')

chance = calculate_chance(time)
for perk in perks:
    chance = chance * PERKS[perk]
plt.plot(time, chance, label='Perks: ' + ', '.join(perks))

plt.legend()
plt.xlabel('Time in Trees (s)')
plt.ylabel('Chance of Falling')
plt.title('Chance of Falling While Riding in Trees Over Time')
plt.grid(True)
plt.show()
