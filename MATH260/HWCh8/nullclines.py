import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

# --- Parameters ---
a = 0.2    # prey growth
b = 0.04   # predation rate
c = 0.1    # predator death
d = 0.005  # predator growth

def system(t, z):
    x, y = z
    return [a*x - b*x*y, -c*y + d*x*y]

fig, ax = plt.subplots(figsize=(7, 6))

xmax, ymax = 45, 12

# --- x-nullclines: x=0 and y=5 ---
# x = 0 (vertical line)
ax.axvline(x=0, color='steelblue', linewidth=2.0,
           label=r"$x$-nullclines: $x=0$, $y=5$")
# y = 5 (horizontal line)
ax.axhline(y=5, color='steelblue', linewidth=2.0, linestyle='--')

# --- y-nullclines: y=0 and x=20 ---
# y = 0 (horizontal line)
ax.axhline(y=0, color='tomato', linewidth=2.0,
           label=r"$y$-nullclines: $y=0$, $x=20$")
# x = 20 (vertical line)
ax.axvline(x=20, color='tomato', linewidth=2.0, linestyle='--')

# --- Nullcline labels ---
ax.text(42, 5.25, r'$y = 5$',   color='steelblue', fontsize=10)
ax.text(0.4, 11,  r'$x = 0$',   color='steelblue', fontsize=10)
ax.text(20.4, 11, r'$x = 20$',  color='tomato',    fontsize=10)
ax.text(1,    0.3, r'$y = 0$',  color='tomato',    fontsize=10)

# --- Vector field ---
xv = np.linspace(0.5, xmax, 18)
yv = np.linspace(0.2, ymax, 14)
XX, YY = np.meshgrid(xv, yv)
dX = a*XX - b*XX*YY
dY = -c*YY + d*XX*YY
mag = np.sqrt(dX**2 + dY**2)
mag[mag == 0] = 1
ax.quiver(XX, YY, dX/mag, dY/mag,
          alpha=0.22, color='gray', scale=30, width=0.003)

# --- A few representative orbits ---
starts = [(5, 1), (10, 2), (30, 3), (15, 8), (5, 9)]
colors = plt.cm.viridis(np.linspace(0.2, 0.8, len(starts)))
for (x0, y0), col in zip(starts, colors):
    sol = solve_ivp(system, (0, 300), [x0, y0],
                    t_eval=np.linspace(0, 300, 15000),
                    method='RK45', rtol=1e-9, atol=1e-9)
    ax.plot(sol.y[0], sol.y[1], color=col, lw=1.2, alpha=0.7)

# --- Equilibrium points ---
equilibria = [(0, 0), (20, 5)]
for (xeq, yeq) in equilibria:
    ax.plot(xeq, yeq, 'k*', markersize=13, zorder=6)
    offset = (0.6, 0.4) if xeq == 0 else (0.7, 0.4)
    ax.annotate(f'$({xeq},\\ {yeq})$',
                xy=(xeq, yeq),
                xytext=(xeq + offset[0], yeq + offset[1]),
                fontsize=11)

# --- Formatting ---
ax.set_xlim(-1, xmax)
ax.set_ylim(-0.3, ymax)
ax.set_xlabel(r'$x$ (prey)', fontsize=12)
ax.set_ylabel(r'$y$ (predator)', fontsize=12)
ax.set_title('Nullclines and Equilibria\n'
             r"$x' = 0.2x - 0.04xy,\quad y' = -0.1y + 0.005xy$",
             fontsize=12)
ax.legend(fontsize=10, loc='upper right')
ax.grid(True, alpha=0.25)

plt.tight_layout()
plt.savefig('nullclines.png', dpi=150, bbox_inches='tight')
plt.show()

print("Saved as nullclines.png")