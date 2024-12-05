# vk-tech-2024-internship

## Стэк
- API: Было использован `YouTube API`. [Токен был получен здесь](https://console.cloud.google.com/apis/dashboard?inv=1&invt=AbjVgw&project=premium-origin-443819-h5)
> [!CAUTION]
> **API токен имеет ограничения на число запросов** и приложение может перестать работать без него. Тогда стоит сменить токен в файле `YouTubeListViewModel.swift` на 119 строке. (Токен я прятать не стал, т.к приложение тестовое и в условиях об этом не просилось)

- CleanSwift архитектура: используется для обеспечения ясной структуры, модульности и тестируемости приложения. Потоки данных организованы следующим образом:
View -> ViewModel -> Interactor -> Presenter -> ViewModel -> Router.
- SwiftData: используется для кэширования данных и изображений, что обеспечивает мгновенный доступ к уже загруженной информации.
- AsyncStream и TaskGroup: позволяют обрабатывать загрузку изображений асинхронно и параллельно, минимизируя задержки и повышая производительность.

## Про работу приложения
Данные подгружаются из двух источников:
1.	Сеть: Сетевые данные всегда отображаются в начале списка. Они имеют более высокий приоритет.
2.	Локальная память устройства: Локальные данные загружаются из SwiftData и отображаются в конце списка с пометкой “Saved”.

Поведение при смене режима сортировки:
- Новые данные из сети добавляются в начало списка.
- Уже отображённые данные остаются такими же и отображаются внизу.

Бесконечный скролл:
- При прокрутке данные загружаются и добавляются в конец списка.

Лоудинги:
- При самом первом запросе в сеть отображаются шиммеры карточек сниппетов. В последствии, достаются из памяти и сети. При бесконечном скролле отображаем лоудер внизу экрана.


## Как работает редактирование/удаление

Редактировать и удалять можно только данные, сохранённые локально.
- Удаление:
    - Свайпом на экране ленты.
    - По кнопке “Удалить” на экране деталей.
- Редактирование:
    - Доступно только для сохранённых данных. Изменения синхронизируются с локальным кэшем.

## Тостеры
При ошибках, успешном редактировании/удалении, показываются тостеры, информирующие о событиях.

## Фотографии

<img src="./Preview/Preview.png">