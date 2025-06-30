import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches

# --- Complex feasible region ---
res = 600
x = np.linspace(0, 1, res)
y = np.linspace(0, 1, res)
X, Y = np.meshgrid(x, y)

# Constraints
C1 = Y >= (0.4 + 0.1 * np.sin(4 * np.pi * X))
C2 = Y <= (0.8 - 0.1 * np.sin(6 * np.pi * X))
C3 = (X - 0.2)**2 + (Y - 0.2)**2 >= 0.12**2

feasible = C1 & C2 & C3

# Colour map
domain_img = np.zeros((res, res, 3))
domain_img[feasible] = [1.0, 0.9, 0.05]   # bright yellow
domain_img[~feasible] = [0.35, 0.0, 0.55]  # purple

# Sub‑cubes
sub_cubes = [
    {'xy': (0.05, 0.05), 'size': 0.3},
    {'xy': (0.35, 0.20), 'size': 0.3},
    {'xy': (0.60, 0.50), 'size': 0.3},
]

# Plot
fig, ax = plt.subplots(figsize=(8, 8))
ax.imshow(domain_img, extent=(0, 1, 0, 1), origin='lower')

cube_color = '#00FFFF'  # cyan for high visibility

for idx, sc in enumerate(sub_cubes, 1):
    rect = patches.Rectangle(sc['xy'], sc['size'], sc['size'],
                             linewidth=2.5, edgecolor=cube_color,
                             facecolor='none', linestyle='--')
    ax.add_patch(rect)
    cx, cy = sc['xy']
    ax.text(cx + sc['size']/2, cy + sc['size']/2, f'$J_{{{idx}}}$',
            color=cube_color, ha='center', va='center', fontsize=13, weight='bold')

# Arrows
arrow_props = dict(arrowstyle='->', color=cube_color, linewidth=2)
for i in range(len(sub_cubes) - 1):
    x0, y0 = sub_cubes[i]['xy']
    s0 = sub_cubes[i]['size']
    x1, y1 = sub_cubes[i+1]['xy']
    s1 = sub_cubes[i+1]['size']
    ax.annotate('', xy=(x1 + s1/2, y1 + s1/2),
                xytext=(x0 + s0/2, y0 + s0/2), arrowprops=arrow_props)

# Labels & Formatting
ax.set_xlabel('$x_1$')
ax.set_ylabel('$x_2$')
ax.set_title('HCTPS: Sub‑Cube Relocation Over a Wavy Feasible Region')
ax.set_xlim(0, 1)
ax.set_ylim(0, 1)
ax.set_aspect('equal')
plt.tight_layout()
