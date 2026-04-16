import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# parameters
m = 1220        # kg
k = 35600       # N/m
g = 17.5        # m/s^2
a = 450000      # N/m^3 (from part 2)
VL = 5.0        # m/s (impact velocity)

# ODE system
def landing_ode(t, y, b):
    x, x_dot = y
    x_ddot = (-m*g - b*x_dot - k*x - a*x**3) / m
    return [x_dot, x_ddot]

# initial conditions: x=0, velocity is downward (negative)
y0 = [0, -VL]

# time span — long enough for oscillations to die out
t_span = (0, 20)
t_eval = np.linspace(0, 20, 10000)

# test each b value
b_values = np.arange(1000, 10500, 500)
results = {}

for b in b_values:
    sol = solve_ivp(landing_ode, t_span, y0, args=(b,),
                    t_eval=t_eval, max_step=0.001)
    max_x = np.max(sol.y[0])  # highest x reached (should stay <= 0)
    results[b] = max_x
    print(f"b = {b:6.0f} N·s/m | max x = {max_x:.6f} m | "
          f"{'✓ OK' if max_x <= 0 else '✗ REBOUND'}")

# find minimum valid b
valid_b = [b for b, max_x in results.items() if max_x <= 0]
b_min = min(valid_b)
print(f"\nMinimum valid b = {b_min} N·s/m")


# plot the solution 
sol = solve_ivp(landing_ode, t_span, y0, args=(b_min,),
                t_eval=t_eval, max_step=0.001)

plt.figure(figsize=(10, 5))
plt.plot(sol.t, sol.y[0], label=f'b = {b_min} N·s/m')
plt.axhline(0, color='red', linestyle='--', label='x = 0 (natural length)')
plt.xlabel('Time (s)')
plt.ylabel('Displacement x (m)')
plt.title('Probe Displacement After Impact')
plt.legend()
plt.grid(True)
plt.show()