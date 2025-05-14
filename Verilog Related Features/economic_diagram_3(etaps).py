import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from datetime import datetime, timedelta

# Данные: [этап, дата начала, дата окончания]
tasks = [
    ("1.1 Сбор данных",        "2025-02-10", "2025-02-11"),
    ("1.2 Постановка задачи",  "2025-02-12", "2025-02-13"),
    ("1.3 Утверждение ТЗ",     "2025-02-14", "2025-02-14"),
    ("2.1 Архитектура ПЛИС",   "2025-02-15", "2025-02-17"),
    ("2.2 Интерфейсы",         "2025-02-18", "2025-02-20"),
    ("2.3 Согласование",       "2025-02-21", "2025-02-24"),
    ("3.1 Структура модуля",   "2025-02-25", "2025-03-04"),
    ("3.2 Анализ биосенсора",  "2025-03-05", "2025-03-07"),
    ("3.3 Черновик проекта",   "2025-03-10", "2025-03-14"),
    ("4.1 RTL схемы",          "2025-03-15", "2025-03-20"),
    ("4.2 Логическая модель",  "2025-03-21", "2025-03-22"),
    ("4.3 Версия кода",        "2025-03-24", "2025-04-01"),
    ("5.1 Программирование",   "2025-04-02", "2025-04-22"),
    ("5.2 Тестирование",       "2025-04-23", "2025-04-25"),
    ("5.3 Корректировка",      "2025-04-26", "2025-04-29"),
    ("5.4 Документация",       "2025-04-30", "2025-05-06"),
    ("5.5 Внедрение",          "2025-05-07", "2025-05-14"),
    ("5.6 Отчёт и ПЗ",         "2025-05-15", "2025-05-19"),
]

# Преобразование дат
task_names = [task[0] for task in tasks]
start_dates = [datetime.strptime(task[1], "%Y-%m-%d") for task in tasks]
end_dates = [datetime.strptime(task[2], "%Y-%m-%d") for task in tasks]
durations = [(end - start).days + 1 for start, end in zip(start_dates, end_dates)]

# Построение
fig, ax = plt.subplots(figsize=(12, 8))

for i, (start, duration) in enumerate(zip(start_dates, durations)):
    ax.barh(y=i, width=duration, left=start, height=0.6, align='center', color='#00AEEF')

# Настройка осей
ax.set_yticks(range(len(task_names)))
ax.set_yticklabels(task_names, fontsize=8)
ax.invert_yaxis()  # Последняя задача внизу

# Формат оси X
ax.xaxis_date()
ax.xaxis.set_major_locator(mdates.WeekdayLocator(interval=1))
ax.xaxis.set_major_formatter(mdates.DateFormatter("%d.%m"))
ax.set_xlim(datetime(2025, 2, 10), datetime(2025, 5, 20))

plt.xticks(rotation=45, ha='right')
plt.title("Календарный график выполнения проекта", fontsize=12, fontweight='bold')
plt.xlabel("Дата")
plt.grid(True, axis='x', linestyle='--', alpha=0.6)

plt.tight_layout()
plt.savefig("calendar_gantt_chart.png", dpi=300)
plt.show()
