// Search for text when start typing
// Включить поиск текста на странице по мере его набора
user_pref("accessibility.typeaheadfind", true);

// Do not show about:config warning message
// Не предупреждать при заходе на about:config
user_pref("browser.aboutConfig.showWarning", false);

// Enable Backspace to go back to a previous web page
// Включить переход на предыдущую страницу по нажатию Backspace
user_pref("browser.backspace_action", 0);

// Prevent bookmark menu and toolbar folder menu from closing when opening bookmark in a new tab
// Отключить автозакрытие меню закладок после открытия закладки в новой вкладке
user_pref("browser.bookmarks.openInTabClosesMenu", false);

// Hide mobile bookmarks folder
// Скрыть папку "Мобильные закладки"
user_pref("browser.bookmarks.showMobileBookmarks", false);

// Do not allow Firefox to make personalized extension recommendations
// Не разрешать Firefox давать персональные рекомендации расширений
user_pref("browser.discovery.enabled", false);

// Do not auto-hide Downloads button in toolbar
// Не скрывать кнопку "Загрузки" на панели инструментов
user_pref("browser.download.autohideButton", false);

// Ask what to do for each file before downloading
// Спрашивать, что делать для каждого файла перед загрузкой
user_pref("browser.download.useDownloadDir", false);

// Turn on Firefox VPN
// Включить Firefox VPN
// https://blog.mozilla.org/en/firefox/built-in-vpn/
user_pref("browser.ipProtection.enabled", true);

// Add "View Image Info" to the image context menu
// Добавить в контекстное меню изображений пункт "Информация об изображении"
user_pref("browser.menu.showViewImageInfo", true);

// Turn on AI chatbot
// Включить ИИ-чат-бот
user_pref("browser.ml.chat.enabled", true);

// Choose a chatbot
// Выберите чат-бот
// https://chatgpt.com
// https://claude.ai/new
// https://gemini.google.com
// https://huggingface.co/chat
// https://chat.mistral.ai/chat
user_pref("browser.ml.chat.provider", "https://chatgpt.com");

// Show prompts on text select
// Показывать подсказки при выделении текста
user_pref("browser.ml.chat.shortcuts", true);

// Do not recommend extensions as you browse
// Не рекомендовать расширения при просмотре
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);

// Do not recommend features as you browse
// Не рекомендовать функции при просмотре
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

// Turn off recommended stories on New Tab
// Выключить рекомендуемые статьи на новой вкладке
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

// Unpin Top Sites search shortcuts
// Открепить ярлыки поисковых сервисов в Топе сайтов
user_pref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts", false);

// Show Highlights in 4 rows
// Отобразить избранные сайты в 4 ряда
user_pref("browser.newtabpage.activity-stream.section.highlights.rows", 4);

// Hide sponsored top sites in Firefox Home screen
// Скрыть топ сайтов спонсоров на домашней странице Firefox
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Show Top Sites in 4 rows
// Отобразить топ сайтов в 4 ряда
user_pref("browser.newtabpage.activity-stream.topSitesRows", 4);

// Show weather widget in a new tab
// Отобразить виджет погоды в новой вкладке
user_pref("browser.newtabpage.activity-stream.widgets.weather.enabled", true);
user_pref("browser.newtabpage.activity-stream.widgets.system.weather.enabled", true);

// Turn on "Firefox Labs" settings page
// Включить раздел "Firefox Labs" в настройках
user_pref("browser.preferences.experimental.hidden", false);

// Hide "More from Mozilla" from Settings
// Скрыть "Больше от Mozilla" в Настройках
user_pref("browser.preferences.moreFromMozilla", false);

// Show search suggestions in Private Windows
// Отображать поисковые предложения в приватных окнах
user_pref("browser.search.suggest.enabled.private", true);

// Set number of saved closed tabs on 20
// Установить количество закрытых вкладок для восстановления на 20
user_pref("browser.sessionstore.max_tabs_undo", 20);

// Set homepage and new windows on https://ya.ru
// Установить домашнюю страницу и новые окна на https://ya.ru
user_pref("browser.startup.homepage", "https://ya.ru");

// Restore previous session
// Восстанавливать предыдущую сессию
user_pref("browser.startup.page", 3);

// Double-click to close tabs feature
// Закрывать вкладки двойным нажатием левой кнопки мыши
user_pref("browser.tabs.closeTabByDblclick", true);

// The last tab does not close the browser
// Не закрывать браузер при закрытии последней вкладки
user_pref("browser.tabs.closeWindowWithLastTab", false);

// Show Title Bar
// Отобразить заголовок
user_pref("browser.tabs.inTitlebar", 0);

// Open new tabs at the end of the tab strip
// Открывать новые вкладки в конце панели вкладок
user_pref("browser.tabs.insertRelatedAfterCurrent", false);

// Open bookmarks in a background tab
// Открывать закладки в фоновых вкладках
user_pref("browser.tabs.loadBookmarksInBackground", true);

// Enable tab previews
// Включить предпросмотр вкладок
user_pref("browser.tabs.hoverPreview.enabled", true);

// Do not warn when attempt to close multiple tabs
// Не предупреждать при закрытии нескольких вкладок
user_pref("browser.tabs.warnOnClose", false);

// Show tab previews in the Windows taskbar
// Отображать эскизы вкладок на панели задач
user_pref("browser.taskbar.previews.enable", true);

// Set the "Bookmarks menu" as default bookmark folder
// Установить "Меню закладок" как папку по умолчанию для закладок
user_pref("browser.bookmarks.defaultLocation", "menu________");

// Always show bookmarks toolbar
// Всегда отображать панель закладок
user_pref("browser.toolbars.bookmarks.visibility", "always");

// Never offer to translate page
// Никогда не предлагать перевод страницы
user_pref("browser.translations.automaticallyPopup", false);

// Seamlessly browse the web in your preferred language
// Просматривайте бесшовно веб-страницы на выбранном вами языке
user_pref("browser.ai.control.translations", "available");

// Use touch density in toolbar
// Включить мобильные значки на панели инструментов
user_pref("browser.uidensity", 2);

// Decode copied URLs, containing UTF8 symbols
// Декодировать URL, содержащий UTF8-символы
user_pref("browser.urlbar.decodeURLsOnCopy", true);

// Do not send search term via ISP's DNS server
// Не отправлять поисковый запрос через DNS-сервер провайдера
user_pref("browser.urlbar.dnsResolveSingleWordsAfterSearch", 0);

// Enable Quick Actions
// Включить Quick Actions
user_pref("browser.urlbar.suggest.quickactions", true);

// When using the address bar, do not suggest search engines
// При использовании панели адреса не предлагать ссылки из поисковых
user_pref("browser.urlbar.suggest.engines", false);

// Turn off "Firefox Default Browser Agent"
// Отключить "Firefox Default Browser Agent"
user_pref("default-browser-agent.enabled", false);

// Turn off protection for downloading files over insecure connections
// Отключить защиту скачивания файлов через незащищенные соединения
user_pref("dom.block_download_insecure", false);

// Enable HTTPS-Only Mode in all windows
// Включить режим "Только HTTPS" во всех окнах
user_pref("dom.security.https_only_mode", true);

// Turn off Extension Recommendations on the Add-ons Manager
// Отключить рекомендуемые расширения на странице "Дополнения"
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

// Highlight all occurrences of the phrase when searching
// Подсвечивать все вхождения фразы при поиске
user_pref("findbar.highlightAll", true);

// Turn off autoscrolling with the middle mouse button
// Отключить автопрокрутку по нажатию средней кнопки мыши
user_pref("general.autoScroll", false);

// Do not select when double-clicking text the space following the text
// Не выделять при выделении слова двойным нажатием идущий за ним пробел
user_pref("layout.word_select.eat_space_to_next_word", false);

// Turn on media control
// Включить элементы управления мультимедиа
user_pref("media.hardwaremediakeys.enabled", true);

// Turn on MMB for opening link in a new tab
// Включить открытие ссылки в новой вкладке по нажатию на СКМ
user_pref("middlemouse.openNewWindow", true);

// Allow Windows single sign-on for Microsoft, work, and school accounts
// Разрешить единый вход Windows для учётных записей Microsoft, учётных записей на работе и в учебных заведениях
user_pref("network.http.windows-sso.enabled", true);

// https://wiki.mozilla.org/Trusted_Recursive_Resolver
// Make DoH the browser's first choice but use regular DNS as a fallback
// DoH используется по умолчанию, а стандартный DNS-сервер используется в качестве резервного
user_pref("network.trr.mode", 2);
// The URI for DoH server
// URI для DoH-сервера
// https://www.comss.ru/page.php?id=7315
// user_pref("network.trr.uri", "https://dns.comss.one/dns-query");
user_pref("network.trr.uri", "https://mozilla.cloudflare-dns.com/dns-query");
// Set the IP address of the host name used in "network.trr.uri", to bypass using the system native resolver for it
// Установить IP-адрес хоста из "network.trr.uri", чтобы исключить использование системного резольвера
user_pref("network.trr.bootstrapAddr", "1.1.1.1");

// Block new requests asking to allow notifications
// Блокировать новые запросы на отправку уведомлений
user_pref("permissions.default.desktop-notification", 2);

// Enable Semantic History Search
// Включить семантический поиск истории
user_pref("places.semanticHistory.featureGate", true);

// Tell websites not to sell or share my data
// Сообщать веб-сайтам, чтобы они не продавали и не разглашали мои данные
user_pref("privacy.globalprivacycontrol.enabled", true);

// Strips known tracking query parameters from URLs
// Удалять известные отслеживающие параметры запроса из URL-адресов
user_pref("privacy.query_stripping.enabled.pbmode", true);

// Set time range to clear to "Everything"
// Выбрать "Удалить всё" при удалении истории
user_pref("privacy.sanitize.timeSpan", 0);

// Turn on UI customizations sync
// Включить синхронизацию кастомизации интерфейса
user_pref("services.sync.prefs.sync.browser.uiCustomization.state", true);

// Enable vertical tabs
// Включить вертикальные вкладки
// user_pref("sidebar.revamp", true);
// user_pref("sidebar.verticalTabs", true);
  
// Enable urlbar built-in calculator
// Включить встроенный в адресную строку калькулятор
user_pref("browser.urlbar.suggest.calculator", true);

// Turn on userChrome.css and userContent.css support
// Включить поддержку userChrome.css и userContent.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Turn off Firefox starting automatically after Windows restart
// Выключить автоматическое восстановление сеанса после перезапуска Windows
user_pref("toolkit.winRegisterApplicationRestart", false);

// Background color of find-in-page matches (Firebrick)
// Цвет фона найденных на странице совпадений (Firebrick)
user_pref("ui.textHighlightBackground", "#B22222");
