#!/bin/bash

# Путь к файлу, который отслеживает количество запусков
count_file="run_count.txt"
run_log="run.log"
error_log="error.log"

# Проверка наличия git
if ! command -v git &> /dev/null; then
    echo "Git is not installed or not in PATH. Aborting." >> "$error_log" 2>&1
    exit 1
fi

# Проверяем, существует ли файл для отслеживания количества запусков
if [ ! -f "$count_file" ]; then
    echo 0 > "$count_file" || { echo "Failed to create $count_file. Aborting." >> "$error_log" 2>&1; exit 1; }
fi

# Проверяем, существует ли файл для лога запусков
if [ ! -f "$run_log" ]; then
    touch "$run_log" || { echo "Failed to create $run_log. Aborting." >> "$error_log" 2>&1; exit 1; }
fi

# Проверяем, существует ли файл для лога ошибок
if [ ! -f "$error_log" ]; then
    touch "$error_log" || { echo "Failed to create $error_log. Aborting." >> "$run_log" 2>&1; exit 1; }
fi

# Читаем текущее количество запусков
run_count=$(cat "$count_file")

# Увеличиваем количество запусков на 1
run_count=$((run_count + 1))

# Обновляем количество запусков в файле
echo "$run_count" > "$count_file"

# Функция для генерации случайных изменений и коммитов
perform_random_commits() {
    local num_commits=$1  # количество коммитов, которые нужно выполнить

    for (( i=1; i<=$num_commits; i++ ))
    do
        echo "Performing commit $i..."

        # Создаем массив с именами файлов, которые мы хотим случайным образом изменять
        files=(
            "greetings_utils.py"
            "financial_calculations.py"
            "file_handling.py"
            "math_operations.py"
            "text_manipulation.py"
            "data_analysis.py"
            "network_utils.py"
            "image_processing.py"
            "data_structures.py"
        )

        # Выбираем случайное имя файла из массива
        random_file=${files[$RANDOM % ${#files[@]}]}

        # Если файл не существует, создаем его
        if [ ! -f "$random_file" ]; then
            touch "$random_file" || { echo "Failed to create $random_file. Aborting." >> "$error_log" 2>&1; exit 1; }
        fi

        # Создаем массив со случайными строками кода
        codes=(
            "def greet(name):\n    return f'Hello, {name}!'"
            "def add(a, b):\n    return a + b"
            "def generate_random_number():\n    import random\n    return random.randint(1, 100)"
            "def read_file(file_path):\n    try:\n        with open(file_path, 'r') as file:\n            return file.read()\n    except FileNotFoundError:\n        return 'File not found'"
            "def current_time():\n    from datetime import datetime\n    now = datetime.now()\n    return now.strftime('%Y-%m-%d %H:%M:%S')"
            "def fibonacci(n):\n    a, b = 0, 1\n    for _ in range(n):\n        a, b = b, a + b\n    return a"
            "def factorial(n):\n    if n == 0\n        return 1\n    else\n        return n * factorial(n-1)"
            "def reverse_string(s):\n    return s[::-1]"
            "def is_prime(n):\n    if n <= 1\n        return False\n    for i in range(2, int(n**0.5) + 1)\n        if n % i == 0\n            return False\n    return True"
            "def count_words(text):\n    words = text.split()\n    return len(words)"
            "def find_max(arr):\n    if not arr\n        return None\n    max_val = arr[0]\n    for num in arr\n        if num > max_val\n            max_val = num\n    return max_val"
            "def is_palindrome(s):\n    return s == s[::-1]"
            "def sum_of_squares(n):\n    return sum(i**2 for i in range(1, n+1))"
            "def find_average(numbers):\n    return sum(numbers) / len(numbers) if numbers else 0"
            "def square_elements(arr):\n    return [x**2 for x in arr]"
            "def remove_duplicates(lst):\n    return list(set(lst))"
            "def convert_to_uppercase(s):\n    return s.upper()"
            "def sort_list(lst):\n    return sorted(lst)"
            "def get_even_numbers(lst):\n    return [x for x in lst if x % 2 == 0]"
            "def count_vowels(s):\n    return sum(1 for char in s.lower() if char in 'aeiou')"
            "def join_strings(str_list):\n    return ' '.join(str_list)"
            "def calculate_power(base, exponent):\n    return base ** exponent"
        )

        # Выбираем случайную строку кода из массива
        random_code=${codes[$RANDOM % ${#codes[@]}]}

        # Извлекаем имя функции из случайной строки кода
        function_name=$(echo "$random_code" | grep -oP 'def \K[a-zA-Z0-9_]+')

        # Формируем сообщение для коммита
        commit_message="- feat : $function_name"

        # Добавляем случайную строку кода в конец файла
        echo -e "$random_code\n" >> "$random_file"

        # Добавляем изменения в индекс Git
        if ! git add "$random_file" >> "$error_log" 2>&1; then
            echo "Failed to add $random_file to git index. See $error_log for details." >> "$error_log" 2>&1
            exit 1
        fi

        # Коммитим изменения с сформированным сообщением
        if ! git commit -m "$commit_message" >> "$error_log" 2>&1; then
            echo "Failed to commit changes. See $error_log for details." >> "$error_log" 2>&1
            exit 1
        fi

        # Генерируем случайную задержку от 5 до 15 секунд
        random_sleep=$(shuf -i 5-15 -n 1)
        sleep "$random_sleep"
    done

    # Пушим все изменения в удаленный репозиторий
    if ! git push origin main >> "$error_log" 2>&1; then
        echo "Failed to push changes to remote repository. See $error_log for details." >> "$error_log" 2>&1
        exit 1
    fi
}

# Генерируем случайное количество коммитов от 5 до 15
random_commit_count=$(shuf -i 5-15 -n 1)

# Добавляем информацию о запуске скрипта и количестве коммитов в лог файл
echo "$run_count итерация - $random_commit_count коммитов" >> "$run_log"

# Добавляем лог файлы в индекс Git
git add -f "$run_log" "$error_log" "$count_file"

# Вызываем функцию perform_random_commits с случайным количеством коммитов
perform_random_commits "$random_commit_count"