# TestDrinks
Test Task. Viper architecture, UI built using Texture &amp; UIKit. API https://www.thecocktaildb.com/, Alamofire.

# Содержание

- **[Задание](#Task)**
- **[Необходимо использовать](#Requirements)**
- **[Презентация реализации](#Presentation)**

## <a id="Task"></a>Задание 

- Поиск по коктейлям на публичном API: 
[https://www.thecocktaildb.com/api/json/v1/1/search.php?s=](https://www.thecocktaildb.com/api/json/v1/1/search.php?s=)
- Два экрана: экран поиска и экран коктейля (экран коктейля состоит из картинки и тайтла, появляется как попап, затемняя и заблуривая бэкграунд, закрывается кликом в пустое место)
- Поиск по тайтлу и по ингредиентам
- Поле текстфилда прилипает к клавиатуре при ее появлении и возвращается к исходному положению при исчезновении клавиатуры(клик в пустое место)
- Обращение к апи когда юзер не вводил новых символов 1сек (получается, что во время ввода ждем, прекращает печатать - шлем запрос на поиск)
- Пока загружаются данные показываем спиннер

## <a id="Requirements"></a>Необходимо использовать

- **VIPER** архитектура
- **Texture**(AsyncDisplayKit)
- **Alamofire** (или **Moya**), можно и **Combine**
- **Codable** для парсинга JSON

## <a id="Presentation"></a>Презентация реализации

<img width="300" src="https://user-images.githubusercontent.com/77533590/183901850-30c383bf-089b-4258-8343-cd1f3eb9df84.png"> <img width="300" src="https://user-images.githubusercontent.com/77533590/183902068-84c48cdd-78a0-44d2-946e-c280c85518d9.png"> <img width="300" src="https://user-images.githubusercontent.com/77533590/183902100-9fd14eae-f8f0-44a7-a983-3b69e7b318f3.png">
