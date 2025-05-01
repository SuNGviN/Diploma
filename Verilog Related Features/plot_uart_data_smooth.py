import matplotlib.pyplot as plt
import numpy as np
from scipy.interpolate import make_interp_spline  # Сплайновая интерполяция

# Считываем значения из файла
with open("uart_output.txt", "r") as f:
    lines = f.readlines()

# Переводим 8.8 фикс. точку в числа
data_raw = [int(line.strip()) / 256 for line in lines]

# X – просто индексы
x = np.arange(len(data_raw))
y = np.array(data_raw)

# Генерация новых X для сглаживания (в 5 раз больше точек)
x_smooth = np.linspace(x.min(), x.max(), len(x)*5)
spline = make_interp_spline(x, y)
y_smooth = spline(x_smooth)

# Построение графика
plt.figure(figsize=(10, 5))
plt.plot(x_smooth, y_smooth, label="Сглаженная кривая", color='royalblue')
plt.scatter(x, y, color='darkorange', label="Исходные точки")  # Добавим оригиналы

# Подписи
plt.title("Сглаженный сдвиг Δx = ln(Vₙ) - ln(Vₙ₋₁)")
plt.xlabel("Измерение (номер)")
plt.ylabel("Сдвиг (Δx), логарифмическая шкала")
plt.grid(True)
plt.legend()
plt.tight_layout()

# Сохранение
plt.savefig("shift_plot_smooth.png", dpi=300)
plt.show()
