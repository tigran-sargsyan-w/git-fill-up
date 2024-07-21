#!/bin/bash

# Папка для лог-файлов
logs_folder="Logs"

# Путь к файлу, который отслеживает количество запусков
count_file="$logs_folder/run_count.txt"
run_log="$logs_folder/run.log"
error_log="$logs_folder/error.log"

# Проверка наличия git
if ! command -v git &> /dev/null; then
    echo "Git is not installed or not in PATH. Aborting." >> "$error_log" 2>&1
    exit 1
fi

# Создаем папку для лог-файлов, если ее нет
mkdir -p "$logs_folder"

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

    # Создаем массив с именами файлов для каждого языка
    python_files=(
        "greetings_utils.py"
        "financial_calculations.py"
        "file_handling.py"
        "math_operations.py"
        "text_manipulation.py"
        "data_analysis.py"
        "network_utils.py"
        "image_processing.py"
        "data_structures.py"
        "database_operations.py"
    )
    
    kotlin_files=(
        "Main.kt"
        "Utils.kt"
        "Network.kt"
        "Database.kt"
        "FileHandler.kt"
        "Auth.kt"
        "Logger.kt"
        "Config.kt"
        "Service.kt"
        "Adapter.kt"
    )
    
    dotnet_files=(
        "Program.cs"
        "Utils.cs"
        "Network.cs"
        "Database.cs"
        "FileHandler.cs"
        "Auth.cs"
        "Logger.cs"
        "Config.cs"
        "Service.cs"
        "Adapter.cs"
    )

    shell_files=(
        "utils.sh"
        "network.sh"
        "database.sh"
        "file_handler.sh"
        "auth.sh"
        "logger.sh"
        "config.sh"
        "service.sh"
        "adapter.sh"
        "backup.sh"
    )

    # Создаем массив со случайными строками кода для каждого языка
    python_codes=(
        "def greet(name):\n    return f'Hello, {name}!'"
        "def add(a, b):\n    return a + b"
        "def generate_random_number():\n    import random\n    return random.randint(1, 100)"
        "def read_file(file_path):\n    try:\n        with open(file_path, 'r') as file:\n            return file.read()\n    except FileNotFoundError:\n        return 'File not found'"
        "def current_time():\n    from datetime import datetime\n    now = datetime.now()\n    return now.strftime('%Y-%m-%d %H:%M:%S')"
        "def fibonacci(n):\n    a, b = 0, 1\n    for _ in range(n):\n        a, b = b, a + b\n    return a"
        "def factorial(n):\n    if n == 0:\n        return 1\n    else:\n        return n * factorial(n-1)"
        "def reverse_string(s):\n    return s[::-1]"
        "def is_prime(n):\n    if n <= 1:\n        return False\n    for i in range(2, int(n**0.5) + 1):\n        if n % i == 0:\n            return False\n    return True"
    )

    kotlin_codes=(
        "fun greet(name: String): String = \"Hello, \$name!\""
        "fun add(a: Int, b: Int): Int = a + b"
        "fun generateRandomNumber(): Int = (1..100).random()"
        "fun readFile(filePath: String): String = File(filePath).readText()"
        "fun currentTime(): String = SimpleDateFormat(\"yyyy-MM-dd HH:mm:ss\").format(Date())"
        "fun fibonacci(n: Int): Int { var a = 0; var b = 1; repeat(n) { val tmp = a; a = b; b += tmp }; return a }"
        "fun factorial(n: Int): Int = if (n == 0) 1 else n * factorial(n - 1)"
        "fun reverseString(s: String): String = s.reversed()"
        "fun isPrime(n: Int): Boolean { if (n <= 1) return false; for (i in 2..Math.sqrt(n.toDouble()).toInt()) { if (n % i == 0) return false } return true }"
        "fun countWords(text: String): Int = text.split(Regex(\"\\s+\")).size"
    )

    dotnet_codes=(
        "public static string Greet(string name) { return \"Hello, \" + name + \"!\"; }"
        "public static int Add(int a, int b) { return a + b; }"
        "public static int GenerateRandomNumber() { return new Random().Next(1, 101); }"
        "public static string ReadFile(string filePath) { return File.ReadAllText(filePath); }"
        "public static string CurrentTime() { return DateTime.Now.ToString(\"yyyy-MM-dd HH:mm:ss\"); }"
        "public static int Fibonacci(int n) { int a = 0, b = 1; for (int i = 0; i < n; i++) { int tmp = a; a = b; b += tmp; }; return a; }"
        "public static int Factorial(int n) { return (n == 0) ? 1 : n * Factorial(n - 1); }"
        "public static string ReverseString(string s) { char[] array = s.ToCharArray(); Array.Reverse(array); return new string(array); }"
        "public static bool IsPrime(int n) { if (n <= 1) return false; for (int i = 2; i <= Math.Sqrt(n); i++) { if (n % i == 0) return false; } return true; }"
        "public static int CountWords(string text) { return text.Split(' ', StringSplitOptions.RemoveEmptyEntries).Length; }"
    )

    shell_codes=(
        "greet() { echo \"Hello, \$1!\"; }"
        "add() { echo \$((\$1 + \$2)); }"
        "generate_random_number() { echo \$((RANDOM % 100 + 1)); }"
        "read_file() { cat \"\$1\"; }"
        "current_time() { date +\"%Y-%m-%d %H:%M:%S\"; }"
        "fibonacci() { a=0; b=1; for ((i=0; i<$1; i++)); do temp=\$a; a=\$b; b=\$((temp + b)); done; echo \$a; }"
        "factorial() { result=1; for ((i=2; i<=$1; i++)); do result=\$((result * i)); done; echo \$result; }"
        "reverse_string() { echo \"\$1\" | rev; }"
        "is_prime() { num=\$1; for ((i=2; i<=num/2; i++)); do if ((num % i == 0)); then echo \"false\"; return; fi; done; echo \"true\"; }"
        "count_words() { echo \"\$1\" | wc -w; }"
    )

    # Выбираем случайное имя файла и код
    for (( i=1; i<=$num_commits; i++ ))
    do
        # Выбираем случайный язык
        language=$((RANDOM % 4))

        # Определяем массив файлов и код в зависимости от выбранного языка
        case $language in
            0) 
                files=("${python_files[@]}")
                codes=("${python_codes[@]}")
                file_extension=".py"
                language_name="Python"
                folder_name="Python"
                ;;
            1) 
                files=("${kotlin_files[@]}")
                codes=("${kotlin_codes[@]}")
                file_extension=".kt"
                language_name="Kotlin"
                folder_name="Kotlin"
                ;;
            2) 
                files=("${dotnet_files[@]}")
                codes=("${dotnet_codes[@]}")
                file_extension=".cs"
                language_name=".NET"
                folder_name="DotNet"
                ;;
            3) 
                files=("${shell_files[@]}")
                codes=("${shell_codes[@]}")
                file_extension=".sh"
                language_name="Shell"
                folder_name="Shell"
                ;;
        esac

        # Создаем папку для языка, если ее нет
        mkdir -p "$folder_name"

        # Выбираем случайное имя файла и строку кода
        random_file="${files[$RANDOM % ${#files[@]}]}"
        random_code="${codes[$RANDOM % ${#codes[@]}]}"

        # Добавляем расширение файла, если его нет
        if [[ ! "$random_file" == *"$file_extension" ]]; then
            random_file+="$file_extension"
        fi

        # Полный путь к файлу
        full_path="$folder_name/$random_file"

        # Если файл не существует, создаем его
        if [ ! -f "$full_path" ]; then
            touch "$full_path" || { echo "Failed to create $full_path. Aborting." >> "$error_log" 2>&1; exit 1; }
        fi

        # Извлекаем имя функции из случайной строки кода
        function_name=$(echo "$random_code" | grep -oP 'def \K[a-zA-Z0-9_]+|fun \K[a-zA-Z0-9_]+|public static \K[a-zA-Z0-9_]+|function \K[a-zA-Z0-9_]+')

        # Формируем сообщение для коммита с названием языка
        commit_message="- feat ($language_name) : $function_name"

        # Выводим сообщение о выполнении коммита
        echo "Performing commit $i in $language_name..."

        # Добавляем случайную строку кода в конец файла
        echo -e "$random_code\n" >> "$full_path"

        # Добавляем изменения в индекс Git
        if ! git add "$full_path" >> "$error_log" 2>&1; then
            echo "Failed to add $full_path to git index. See $error_log for details." >> "$error_log" 2>&1
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

        # Логируем выполненный коммит
        echo "Commit $i: $commit_message" >> "$run_log"
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
