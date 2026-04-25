import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

# --- Parameters ---
alpha = 0.2   # prey growth rate
beta  = 0.1   # predation rate
gamma = 0.3   # predator death rate
delta = 0.1   # predator growth rate

def system(t, y):
    F, S = y
    dF = alpha * F - beta * F * S
    dS = -gamma * S + delta * F * S
    return [dF, dS]

# Equilibrium
F_eq = gamma / delta   # 3.0
S_eq = alpha / beta    # 2.0

# --- Initial conditions for several orbits ---
starts = [
    (1.0, 0.5),
    (1.5, 1.0),
    (2.0, 1.2),
    (4.0, 1.0),
    (5.0, 2.0),
    (1.0, 3.0),
]

t_span = (0, 200)
t_eval = np.linspace(*t_span, 10000)

fig, ax = plt.subplots(figsize=(7, 5))

colors = plt.cm.viridis(np.linspace(0.15, 0.85, len(starts)))

for (F0, S0), color in zip(starts, colors):
    sol = solve_ivp(system, t_span, [F0, S0], t_eval=t_eval,
                    method='RK45', rtol=1e-9, atol=1e-9)
    ax.plot(sol.y[0], sol.y[1], color=color, linewidth=1.4, alpha=0.85)
    ax.plot(F0, S0, 'o', color=color, markersize=4)

# --- Highlight the (3, 2) equilibrium solution ---
ax.plot(F_eq, S_eq, 'k*', markersize=12, label=r'$(F^*, S^*) = (3,\,2)$', zorder=5)

# --- Vector field (quiver) ---
Fv = np.linspace(0.2, 7.5, 18)
Sv = np.linspace(0.2, 6.0, 18)
FF, SS = np.meshgrid(Fv, Sv)
dF = alpha * FF - beta * FF * SS
dS = -gamma * SS + delta * FF * SS
mag = np.sqrt(dF**2 + dS**2)
mag[mag == 0] = 1
ax.quiver(FF, SS, dF/mag, dS/mag,
          alpha=0.25, color='gray', scale=28, width=0.003)

ax.set_xlabel(r'$F$ (prey)', fontsize=12)
ax.set_ylabel(r'$S$ (predator)', fontsize=12)
ax.set_title('Phase Plane: Predator–Prey System', fontsize=13)
ax.legend(fontsize=11)
ax.set_xlim(0, 8)
ax.set_ylim(0, 6.5)
ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('phase_plane.png', dpi=150, bbox_inches='tight')
plt.show()

print("Saved as phase_plane.png")