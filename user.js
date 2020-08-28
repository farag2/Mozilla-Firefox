// Search for text when start typing
// Включить поиск текста на странице по мере его набора
user_pref("accessibility.typeaheadfind", true);

// Turn on notifications to show in Windows 10 Action Center
// Включить интеграцию с центром уведомлений Windows 10
user_pref("alerts.useSystemBackend", true);

// Allow Firefox to install and run studies
// Разрешить Firefox устанавливать и проводить исследования
user_pref("app.shield.optoutstudies.enabled", true);

// Do not show about:config warning message
// Не предупреждать при заходе на about:config
user_pref("browser.aboutConfig.showWarning", false);

// Prevent bookmark menu and toolbar folder menu from closing when opening bookmark in a new tab
// Отключить автозакрытие меню закладок после открытия закладки в новой вкладке
user_pref("browser.bookmarks.openInTabClosesMenu", false);

// Hide mobile bookmarks folder
// Скрыть папку Мобильные закладки
user_pref("browser.bookmarks.showMobileBookmarks", false);

// Turn off Content Blocker notification
// Не отображать уведомление о блокировке содержимого
user_pref("browser.contentblocking.introCount", 20);

// Do not allow Firefox to make prezonalized extension recommendations
// Не разрешать Firefox давать персональные рекомендации расширений
user_pref("browser.discovery.enabled", false);

// Do not auto-hide Downloads button in toolbar
// Не скрывать кнопку "Загрузки" на панели инструментов
user_pref("browser.download.autohideButton", false);

// Turn off counting URIs in private browsing mode
// Отключить подсчета URI в приватном режиме просмотра
user_pref("browser.engagement.total_uri_count.pbm", false);

// Turn off Library Highlights
// Скрыть "Последнее Избранное" в Библиотеки
user_pref("browser.library.activity-stream.enabled", false);

// Do not notify about new features
// Не уведомлять о новых функциях Firefox
user_pref("browser.messaging-system.whatsNewPanel.enabled", false);

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

// Show Top Sites in 4 rows
// Отобразить топ сайтов в 4 столбца
user_pref("browser.newtabpage.activity-stream.topSitesRows", 4);

// Turn on "Firefox Experiments" settings page
// Включить раздел "Эксперименты Firefox" в настройках
user_pref("browser.preferences.experimental", true);

// Show search suggestions in Private Windows
// Отображать поисковые предложения в Приватных вкладках
user_pref("browser.search.suggest.enabled.private", true);

// Set number of saved closed tabs on 20
// Установить количество закрытых вкладок для восстановления на 20
user_pref("browser.sessionstore.max_tabs_undo", 20);

// Set homepage and new windows on https://yandex.ru
// Установить домашнюю страницу страницу и новые окна на https://yandex.ru
user_pref("browser.startup.homepage", "https://yandex.ru/");

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
user_pref("browser.tabs.drawInTitlebar", false);

// Show Drag Space
// Отобразить место для перетаскивания окна
user_pref("browser.tabs.extraDragSpace", true);

// Open new tabs on the right
// Открывать новые вкладки справа
user_pref("browser.tabs.insertRelatedAfterCurrent", false);

// Open bookmarks in a background tab
// Открывать закладки в фоновых вкладках
user_pref("browser.tabs.loadBookmarksInBackground", true);

// Do not warn when attempt to close multiple tabs
// Не предупреждать при закрытии нескольких вкладок
user_pref("browser.tabs.warnOnClose", false);

// Show tab previews in the Windows taskbar
// Отображать эскизы вкладок на панели задач
user_pref("browser.taskbar.previews.enable", true);

// Use touch density in toolbar
// Включить мобильные значки на панели инструментов
user_pref("browser.uidensity", 2);

// Decode copied URLs, containing UTF8 symbols
// Декодировать URL, содержащий UTF8-символы
// https://bugzilla.mozilla.org/show_bug.cgi?id=1657526
user_pref("browser.urlbar.decodeURLsOnCopy", true);

// Do not send search term via ISP's DNS server
// Не отправлять поисковый запрос через DNS-сервер провайдера
user_pref("browser.urlbar.dnsResolveSingleWordsAfterSearch", 0);

// Turn off "Firefox Default Browser Agent"
// Отключить "Firefox Default Browser Agent"
user_pref("default-browser-agent.enabled", false);

// Turn on lazy loading for images
// Включить отложенную загрузку для изображений
user_pref("dom.dom.image-lazy-loading.enabled", true);

// Run extensions in Private browsing mode
// Запускать дополнения в приватном режиме
user_pref("extensions.allowPrivateBrowsingByDefault", true);

// Turn off Extension Recommendations on the Add-ons Manager
// Отключить рекомендуемые расширения на странице "Дополнения"
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

// Turn off Pocket
// Отключить Pocket
user_pref("extensions.pocket.enabled", false);

// Highlight all occurrence when searching
// Включить подсветку при поиске текста на странице
user_pref("findbar.highlightAll", true);

// Use smooth scrolling
// Использовать плавную прокрутку
user_pref("general.autoScroll", false);

// Turn on AVIF support
// Включить поддержку AVIF
user_pref("image.avif.enabled", true);

// Do not select when double-clicking text the space following the text
// Не выделять при выделении слова двойным нажатием идущий за ним пробел
user_pref("layout.word_select.eat_space_to_next_word", false);

// Turn on media control (81)
// Включить элементы управления мультимедиа (81)
// user_pref("media.hardwaremediakeys.enabled", true);

// Turn on MMB for openning link a new tab
// Включить открытие ссылки в новой вкладки по нажатию на СКМ
user_pref("middlemouse.openNewWindow", true);

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

// Block new requests asking to allow notifications
// Блокировать новые запросы на отправку уведомлений
user_pref("permissions.default.desktop-notification", 2);

// Send websites a "Do Not Track" signal always
// Передавать сайтам сигнал "Не отслеживать" всегда
user_pref("privacy.donottrackheader.enabled", true);

// Set time range to clear to "Everything"
// Выбрать "Удалить всё" при удаление истории
user_pref("privacy.sanitize.timeSpan", 0);

// Prompts should be window modal by default
// Привязывать модальные диалоги по умолчанию к окну
user_pref("prompts.defaultModalType", 3);

// Turn on UI customizations sync
// Включить синхронизацию кастомизации интерфейса
user_pref("services.sync.prefs.sync.browser.uiCustomization.state", true);

// Show indicators on saved logins that are re-using those breached passwords
// Показать индикаторы на сохраненных логинах, которые повторно используют эти скомпрометированные пароли
user_pref("signon.management.page.vulnerable-passwords.enabled", true);

// Turn on userChrome.css and userContent.css support
// Включить загрузку userChrome.css и userContent.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Turn off Firefox starting automatically after Windows 10 restart
// Выключить автоматическое восстановление сеанса после перезапуска Windows 10
user_pref("toolkit.winRegisterApplicationRestart", false);

// Turn on Video Acceleration API (VA-API). For desktop environment based on Wayland
// Включить Video Acceleration API (VA-API). Для окружений на базе Wayland
// user_pref("widget.wayland-dmabuf-vaapi.enabled", true);

// Turn on FFmpegDataDecoder. For display server based on Wayland
// Включить FFmpegDataDecoder. Для окружений на базе Wayland
// user_pref("widget.wayland-dmabuf-webgl.enabled", true);