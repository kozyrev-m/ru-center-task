# ru-center-task - тестовое задание

- [Условие задачи](#description)
- [Использованные модули](#modules)
- [Тестирование решения](#test)

# Условие задачи <a name="description">
Задан массив URL-путей. В пути могут присутствовать элементы, начинающиеся с ':'.
Такие элементы представляют собой переменные - ключи.

Нужно продемонстрировать код на Perl, который для заданного полного URL определит первый подходящий URL-путь.
Получить его индекс и собрать хэш :
- ключ - имя переменной из подходящего URL-пути
- значение - часть полного URL соответствующая данному ключу

Пример

Массив URL-путей:
```
my @paths = (
    '/api/v1/:storage/:pk/raw',
    '/api/v1/:storage/:pk/:op',
    '/api/v1/:storage/:pk',
);
```

Полный URL:
```
my $url = 'http://localhost:8080/api/v1/order/123/update';
```

В результате должно получиться:
```
Индекс первого подходящего пути: 1
Хэш : 
{
    storage => 'order',
    pk => '123',
    op => 'update'
}
```
# Использованные модули <a name="modules">
- Работа с URI: [URI](https://metacpan.org/pod/URI)
- Тестирование: [Test::More](https://metacpan.org/pod/Test::More)

# Тестирование решения <a name="test">
## Запуск теста
Для проверки решения выполнить следующую команду из корня репозитория:
```
make test
```
Подробнее см. [Makefile](Makefile)

## Кейсы
Проверены следующие кейсы (из файла [t/test.t](t/test.t)):
```
my %test_cases = (
    '1st case' => {
        url      => 'http://localhost:8080/api/v1/order/123/update',
        patterns => [
            '/api/v1/:storage/:pk/raw',
            '/api/v1/:storage/:pk/:op',
            '/api/v1/:storage/:pk',
        ],
        expected => {
            index => 2,
            hash => {
                'storage' => 'order',
                'pk' => '123',
                'op' => 'update',
            },
        }
    },
    '2nd case' => {
        url      => 'http://localhost:8080/api/v1/order/123/raw',
        patterns => [
            '/api/v1/:storage/:pk/raw',
            '/api/v1/:storage/:pk/:op',
            '/api/v1/:storage/:pk',
        ],
        expected => {
            index => 1,
            hash => {
                'storage' => 'order',
                'pk' => '123',
            },
        }
    },
    '3rd case' => {
        url      => 'http://localhost:8080/api/v1/order/123',
        patterns => [
            '/api/v1/:storage/:pk/raw',
            '/api/v1/:storage/:pk/:op',
            '/api/v1/:storage/:pk',
        ],
        expected => {
            index => 3,
            hash => {
                'storage' => 'order',
                'pk' => '123',
            },
        }
    },
    '4th case' => {
        url      => 'http://localhost:8080/api/v1/:order/13',
        patterns => [
            '/api/v1/:storage/:pk/raw',
            '/api/v1/:storage/:pk/:op',
            '/api/v1/:storage/:pk',
        ],
        expected => {
            index => 3,
            hash => {
                'storage' => ':order',
                'pk' => '13',
            },
        }
    }
);

```
