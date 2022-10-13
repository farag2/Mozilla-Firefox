// Search for text when start typing
// Включить поиск текста на странице по мере его набора
user_pref("accessibility.typeaheadfind", true);

// Turn on notifications to show in Windows 10/11 Action Center
// Включить интеграцию с центром уведомлений Windows 10/11
user_pref("alerts.useSystemBackend", true);

// Allow Firefox to install and run studies
// Разрешить Firefox устанавливать и проводить исследования
user_pref("app.shield.optoutstudies.enabled", true);

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
// Скрыть папку Мобильные закладки
user_pref("browser.bookmarks.showMobileBookmarks", false);

// Show the Compact option under Density in the customize menu
// Отображать опцию "Компактные" в разделе "Значки" в разделе персонализации панели инструментов
user_pref("browser.compactmode.show", true);

// Turn off Content Blocker notification
// Не отображать уведомление о блокировке содержимого
user_pref("browser.contentblocking.introCount", 20);

// Do not allow Firefox to make prezonalized extension recommendations
// Не разрешать Firefox давать персональные рекомендации расширений
user_pref("browser.discovery.enabled", false);

// Do not auto-hide Downloads button in toolbar
// Не скрывать кнопку "Загрузки" на панели инструментов
user_pref("browser.download.autohideButton", false);

// Ask what to do for each file before downloading
// Спрашивать, что делать для каждого файла перед загрузкой
user_pref("browser.download.useDownloadDir", false);

// Turn off counting URIs in private browsing mode
// Отключить подсчета URI в приватном режиме просмотра
user_pref("browser.engagement.total_uri_count.pbm", false);

// Turn off Library Highlights
// Скрыть "Последнее Избранное" в Библиотеки
user_pref("browser.library.activity-stream.enabled", false);

// Do not notify about new features
// Не уведомлять о новых функциях Firefox
user_pref("browser.messaging-system.whatsNewPanel.enabled", false);

// Add "View Image Info" to the image context menu
// Добавить в контекстное меню изображений пункт "Информация об изображении"
user_pref("browser.menu.showViewImageInfo", true);

// Turn off recommended extensions
// Отключить рекомендации расширений
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr", false);

// Do not recommend extensions as you browse
// Не рекомендовать расширения при просмотре
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);

// Do not recommend features as you browse
// Не рекомендовать функции при просмотре
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

// Turn off Snippets (Updates from Mozilla and Firefox)
// Отключить Заметки (Обновления от Mozilla и Firefox)
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);

// Unpin Top Sites search shortcuts
// Открепить ярлыки поисковых сервисов в Топе сайтов
user_pref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts", false);

// Does not offer import bookmarks, history and passwords from other browsers
// Не предлагать импорт закладок, истории и паролей из другого браузера
user_pref("browser.newtabpage.activity-stream.migrationExpired", true);

// Show Highlights in 4 rows
// Отобразить избранные сайты в 4 столбца
user_pref("browser.newtabpage.activity-stream.section.highlights.rows", 4);

// Hide sponsored top sites in Firefox Home screen
// Скрыть топ сайтов спонсоров на домашней странице Firefox
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Show Top Sites in 4 rows
// Отобразить топ сайтов в 4 столбца
user_pref("browser.newtabpage.activity-stream.topSitesRows", 4);

// Turn on "Firefox Experiments" settings page
// Включить раздел "Эксперименты Firefox" в настройках
user_pref("browser.preferences.experimental", true);

// Hide "More from Mozilla" from Settings
// Скрыть "Больше от Mozilla" в Настройках
user_pref("browser.preferences.moreFromMozilla", false);

// Show search suggestions in Private Windows
// Отображать поисковые предложения в Приватных вкладках
user_pref("browser.search.suggest.enabled.private", true);

// Set number of saved closed tabs on 20
// Установить количество закрытых вкладок для восстановления на 20
user_pref("browser.sessionstore.max_tabs_undo", 20);

// Set homepage and new windows on https://ya.ru
// Установить домашнюю страницу страницу и новые окна на https://ya.ru
user_pref("browser.startup.homepage", "https://ya.ru");

// Restore previous session
// Восстанавливать предыдущую сессию
user_pref("browser.startup.page", 3);

// Double-сlick to close tabs feature
// Закрывать вкладки двойным нажатием левой кнопки мыши
user_pref("browser.tabs.closeTabByDblclick", true);

// The last tab does not close the browser
// Не закрывать браузер при закрытии последней вкладки
user_pref("browser.tabs.closeWindowWithLastTab", false);

// Show Title Bar
// Отобразить заголовок
user_pref("browser.tabs.inTitlebar", 0);

// Show Drag Space
// Отобразить место для перетаскивания окна
user_pref("browser.tabs.extraDragSpace", true);

// Open new tabs on the right
// Открывать новые вкладки справа
user_pref("browser.tabs.insertRelatedAfterCurrent", false);

// Open bookmarks in a background tab
// Открывать закладки в фоновых вкладках
user_pref("browser.tabs.loadBookmarksInBackground", true);

// Unload tabs when Firefox detects the system is running on low memory
// Выгружать вкладки, когда Firefox обнаруживает, что система работает с малым объемом памяти
// user_pref("browser.tabs.unloadOnLowMemory", true);

// Do not warn when attempt to close multiple tabs
// Не предупреждать при закрытии нескольких вкладок
user_pref("browser.tabs.warnOnClose", false);

// Show tab previews in the Windows taskbar
// Отображать эскизы вкладок на панели задач
user_pref("browser.taskbar.previews.enable", true);

// Set the "Bookmarks menu" as default bookmark folder
// Установить "Меню закладок" как папку по умолчанию для закладок
user_pref("browser.toolbars.bookmarks.2h2020", true);
user_pref("browser.bookmarks.defaultLocation", "menu________");

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
user_pref("browser.urlbar.quickactions.enabled", true);
user_pref("browser.urlbar.shortcuts.quickactions", true);

// When using the address bar, do not suggest search engines
// При использовании панели адреса не предлагать ссылки из поисковых
user_pref("browser.urlbar.suggest.engines", false);

// Alway show bookmarks toolbar
// Всегда отображать панель закладок
user_pref("browser.toolbars.bookmarks.visibility", "always");

// Turn off "Firefox Default Browser Agent"
// Отключить "Firefox Default Browser Agent"
user_pref("default-browser-agent.enabled", false);

// Turn off protection for downloading files over insecure connections
// Отключить защиту скачивания файлов через незащищенные соединения
user_pref("dom.block_download_insecure", false);

// Turn on lazy loading for images
// Включить отложенную загрузку для изображений
user_pref("dom.dom.image-lazy-loading.enabled", true);

// Enable HTTPS-Only Mode in all windows
// Включить режим "Только HTTPS" во всех окнах
user_pref("dom.security.https_only_mode", true);

// Run extensions in Private browsing mode
// Запускать дополнения в приватном режиме
user_pref("extensions.allowPrivateBrowsingByDefault", true);

// Turn off Extension Recommendations on the Add-ons Manager
// Отключить рекомендуемые расширения на странице "Дополнения"
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

// Turn off Pocket
// Отключить Pocket
user_pref("extensions.pocket.enabled", false);

// Turn on Unified Extensions Toolbar button (105)
// Включить универсального Unified Extensions Toolbar (105)
// user_pref("extensions.unifiedExtensions.enabled", true);

// Highlight all occurrences of the phrase when searching
// Подстветить всех вхождения фразы в текст при поиске
user_pref("findbar.highlightAll", true);

// Enable site isolation (Project Fission)
// Включить режим строгой изоляции страниц (Project Fission)
user_pref("fission.autostart", true);

// Use smooth scrolling
// Использовать плавную прокрутку
user_pref("general.autoScroll", false);

// Do not select when double-clicking text the space following the text
// Не выделять при выделении слова двойным нажатием идущий за ним пробел
user_pref("layout.word_select.eat_space_to_next_word", false);

// Turn on media control
// Включить элементы управления мультимедиа
user_pref("media.hardwaremediakeys.enabled", true);

// Turn on MMB for openning link a new tab
// Включить открытие ссылки в новой вкладки по нажатию на СКМ
user_pref("middlemouse.openNewWindow", true);

// Enable Encrypted Client Hello (ECH)
// Включить Encrypted Client Hello (ECH)
user_pref("network.dns.echconfig.enabled", true);
user_pref("network.dns.use_https_rr_as_altsvc", true);

// Allow Windows single sign-on for Microsoft, work, and school accounts
// Разрешить единый вход Windows для учётных записей Microsoft, учетных записей на работе и в учеьных заведениях
user_pref("network.http.windows-sso.enabled", true);

// Set automatic proxy configuration URL
// Установить URL автоматической настройки прокси
user_pref("network.proxy.autoconfig_url", "https://antizapret.prostovpn.org/proxy.pac");
user_pref("network.proxy.type", 2);

// https://wiki.mozilla.org/Trusted_Recursive_Resolver
// Make DoH the browser's first choice but use regular DNS as a fallback
// DoH используется по умолчанию, а стандартный DNS-сервер используется в качестве резервного
user_pref("network.trr.mode", 2);
// The URI for DoH server
// URI для DoH-сервера 
user_pref("network.trr.uri", "https://mozilla.cloudflare-dns.com/dns-query");
// Set the IP address of the host name used in "network.trr.uri", to bypass using the system native resolver for it
// Установить IP-адрес, используемого в "network.trr.uri", чтобы исключить использование системного резольвера
user_pref("network.trr.bootstrapAddress", "1.1.1.1");

// Enable PDF editing feature and tools
// Включить возможность редактировать PDF-файлы
user_pref("pdfjs.annotationEditorMode", 0);
user_pref("pdfjs.annotationMode", 2);

// Block new requests asking to allow notifications
// Блокировать новые запросы на отправку уведомлений
user_pref("permissions.default.desktop-notification", 2);

// Send websites a "Do Not Track" signal always
// Передавать сайтам сигнал "Не отслеживать" всегда
user_pref("privacy.donottrackheader.enabled", true);

// Strips known tracking query parameters from URLs
// Удалять известные отслеживающие параметры запроса из URL-адресов 
user_pref("privacy.query_stripping.enabled.pbmode", true);

// Total Cookie Protection contains cookies to the site you’re on, so trackers can’t use them to follow you between sites.
// Полная защита от кук ограничивает работу кук сайтом, на котором вы находитесь, чтобы трекеры не могли использовать их для слежки за вами от сайта к сайту
user_pref("privacy.restrict3rdpartystorage.rollout.enabledByDefault", true);

// Set time range to clear to "Everything"
// Выбрать "Удалить всё" при удаление истории
user_pref("privacy.sanitize.timeSpan", 0);

// Prompts should be window modal by default
// Привязывать модальные диалоги по умолчанию к окну
user_pref("prompts.defaultModalType", 3);

// Turn on UI customizations sync
// Включить синхронизацию кастомизации интерфейса
user_pref("services.sync.prefs.sync.browser.uiCustomization.state", true);

// Enable the import of passwords as a CSV file on the about:logins page
// Включить импорт паролей в виде CSV-файла на странице "about: logins" 
user_pref("signon.management.page.fileImport.enabled", true);

// Enable urlbar built-in calculator
// Включить встроенный в адресную строку калькулятор
user_pref("suggest.calculator", true);

// Show indicators on saved logins that are re-using those breached passwords
// Показать индикаторы на сохраненных логинах, которые повторно используют эти скомпрометированные пароли
user_pref("signon.management.page.vulnerable-passwords.enabled", true);

// Turn on userChrome.css and userContent.css support
// Включить поддержку userChrome.css и userContent.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Turn off Firefox starting automatically after Windows 10 restart
// Выключить автоматическое восстановление сеанса после перезапуска Windows 10
user_pref("toolkit.winRegisterApplicationRestart", false);

// Show matches next on top of scrollbar
// Показывать совпадения поверх полосы прокрутки
user_pref("ui.textHighlightBackground", "Fireprick");

// Turn on Video Acceleration API (VA-API). For desktop environment based on Wayland
// Включить Video Acceleration API (VA-API). Для окружений на базе Wayland
// user_pref("widget.wayland-dmabuf-vaapi.enabled", true);

// Turn on FFmpegDataDecoder. For display server based on Wayland
// Включить FFmpegDataDecoder. Для окружений на базе Wayland
// user_pref("widget.wayland-dmabuf-webgl.enabled", true);
