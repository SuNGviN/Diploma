import matplotlib.pyplot as plt

# Считываем значения
with open("uart_output.txt", "r") as f:
    lines = f.readlines()

# Преобразуем строки в значения (в формате 8.8 → real = value / 256)
data = [int(line.strip()) / 256 for line in lines]

# Строим график
plt.figure(figsize=(10, 5))
plt.plot(data, marker='o', color='royalblue', linestyle='-')

# Подписи
plt.title("Δx = ln(Vₙ) - ln(Vₙ₋₁)")
plt.xlabel("Измерение (номер)")
plt.ylabel("Сдвиг (Δx), логарифмическая шкала")
plt.grid(True)
plt.tight_layout()

# Сохраняем график
plt.savefig("shift_plot.png", dpi=300)
plt.show()
