import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

# Этапы проекта и их длительность (в днях)
stages = [
    "1. Формализация требований",
    "2. Функциональная концепция",
    "3. Предварительное проектирование",
    "4. Логическая архитектура",
    "5. Реализация и тестирование"
]
durations = [5, 7, 16, 15, 47]

# Начальные дни (кумулятивно)
start_days = [0]
for i in range(1, len(durations)):
    start_days.append(start_days[i-1] + durations[i-1])

# Построение
fig, ax = plt.subplots(figsize=(10, 3.5))
bar_height = 0.6

for i, (start, duration) in enumerate(zip(start_days, durations)):
    ax.broken_barh([(start, duration)], (i - bar_height/2, bar_height), facecolors="#00AEEF")

# Настройки осей
ax.set_ylim(-0.5, len(stages) - 0.5)
ax.set_xlim(0, 90)
ax.set_xlabel("Дни проекта", fontsize=10)
ax.set_yticks(range(len(stages)))
ax.set_yticklabels(stages, fontsize=9)
ax.set_xticks(range(0, 95, 5))
ax.grid(True, axis='x', linestyle='--', alpha=0.5)

# Стиль
ax.set_title("Календарный график выполнения работ", fontsize=12, fontweight='bold')

# Подписи этапов как прямоугольники
for i, (start, duration) in enumerate(zip(start_days, durations)):
    ax.text(start + duration / 2, i, f"{duration} дн", ha='center', va='center', fontsize=8, color='white', fontweight='bold')

# Сохранить изображение
plt.tight_layout()
plt.savefig("gantt_chart_vkr.png", dpi=300)
plt.show()
