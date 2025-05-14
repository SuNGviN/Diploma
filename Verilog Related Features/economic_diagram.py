import matplotlib.pyplot as plt

# Данные
labels = [
    "Основная заработная плата", 
    "Дополнительная заработная плата", 
    "Страховые взносы", 
    "Сырье и материалы", 
    "Амортизация", 
    "Прочие расходы"
]

sizes = [36.3, 7.3, 13.2, 5.7, 4.1, 47.2]

# Цвета аналогичные Excel
colors = [
    '#4F81BD',  # Синий
    '#C0504D',  # Красный
    '#9BBB59',  # Зеленый
    '#8064A2',  # Фиолетовый
    '#4BACC6',  # Голубой
    '#F79646'   # Оранжевый
]

# Построение диаграммы
fig, ax = plt.subplots()
wedges, texts, autotexts = ax.pie(
    sizes, labels=labels, colors=colors, autopct='%1.1f%%',
    startangle=90, textprops={'fontsize': 10}
)

# Равные оси — круг
ax.axis('equal')
plt.title("Структура затрат", fontsize=14)

# Сохранение изображения
plt.tight_layout()
plt.savefig("structure_pie_chart.png", dpi=300)
plt.show()
у