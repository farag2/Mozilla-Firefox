// Search for text when start typing
// Включить поиск текста на странице по мере его набора
user_pref("accessibility.typeaheadfind", true);
// Turn on notifications to show in Windows 10 Action Center
// Включить интеграцию с центром уведомлений Windows 10
user_pref("alerts.useSystemBackend", true);
// Prevent bookmark menu and toolbar folder menu from closing when opening bookmark in a new tab
// Отключить автозакрытие меню закладок после открытия закладки в новой вкладке
user_pref("browser.bookmarks.openInTabClosesMenu", false);
// Hide mobile bookmarks folder
// Скрыть папку Мобильные закладки
user_pref("browser.bookmarks.showMobileBookmarks", false);
// Set Enhanced Tracking Protection to "Custom"
// Установить блокировку содержимого на "Персональная"
user_pref("browser.contentblocking.category", "custom");
// Set Enhanced Tracking Protection to "Standart" (70)
// Установить блокировку содержимого на "Стандартная" (70)
// user_pref("browser.contentblocking.category", "Standart");
// Turn off Content Blocker notification
// Не отображать уведомление о блокировке содержимого
user_pref("browser.contentblocking.introCount", 20);
// Turn on Ctrl+Tab cycle through recently used tabs
// Включить переключение по Ctrl+Tab между вкладками в порядке недавнего использования
user_pref("browser.ctrlTab.recentlyUsedOrder", true);
// Do not auto-hide Downloads button in toolbar
// Не скрывать кнопку "Загрузки" на панели инструментов
user_pref("browser.download.autohideButton", false);
// Turn off counting URIs in private browsing mode
// Отключить подсчета URI в приватном режиме просмотра
user_pref("browser.engagement.total_uri_count.pbm", false);
// Turn off Library Highlights
// Скрыть "Последнее Избранное" в Библиотеки
user_pref("browser.library.activity-stream.enabled", false);
// Turn off recommended extensions
// Отключить рекомендации расширений
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr", false);
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
// Do not add search bar in toolbar
// Не добавлять панель поиска на панель инструментов
user_pref("browser.search.widget.inNavBar", false);
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
// Декодировать URL, содержащиq UTF8
user_pref("browser.urlbar.decodeURLsOnCopy", true);
// Require user gestures for requesting push notifications
// Запрашивать разрешение на отправку пуш-уведомлений
user_pref("dom.webnotifications.requireuserinteraction", true);
// Run extensions in Private browsing mode
// Запускать дополнения в приватном режиме
user_pref("extensions.allowPrivateBrowsingByDefault", true);
// Turn on Firefox Monitor
// Включить Firefox Monitor
user_pref("extensions.fxmonitor.enabled", true);
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
// Do not show about:config warning message
// Не предупреждать при заходе на about:config
user_pref("general.warnOnAboutConfig", false);
// Do not select when double-clicking text the space following the text
// Не выделять при выделении слова двойным нажатием идущий за ним пробел
user_pref("layout.word_select.eat_space_to_next_word", false);
// Turn on picture-in-picture video controls (71)
// Включить режим "картинка в картинке" (71)
// user_pref("media.videocontrols.picture-in-picture.enabled", true);
// user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", true);
// Block coockies from third-party trackers
// Блокировать куки со сторонних трекеров
user_pref("network.cookie.cookieBehavior", 4);
// Set automatic proxy configuration URL on https://antizapret.prostovpn.org/proxy.pac
// Установить URL автоматической настройки прокси на https://antizapret.prostovpn.org/proxy.pac
user_pref("network.proxy.type", 2);
user_pref("network.proxy.autoconfig_url", "https://antizapret.prostovpn.org/proxy.pac");
// Block new requests asking to allow notifications
// Блокировать новые запросы на отправку уведомлений
user_pref("permissions.default.desktop-notification", 2);
// Send websites a "Do Not Track" signal always
// Передавать сайтам сигнал "Не отслеживать" всегда
user_pref("privacy.donottrackheader.enabled", true);
// Set time range to clear to "Everything"
// Выбрать "Удалить всё" при удаление истории
user_pref("privacy.sanitize.timeSpan", 0);
// Show social media trackers and cross-site tracking cookie items in "Privacy & Security" (70)
// Отобразить межсайтовые и социальные трекеры в разделе "Приватность и Защита" (70)
// user_pref("privacy.socialtracking.block_cookies.enabled", true);
// Turn on trackers blocking only in Private Windows
// Включить блокировку трекеров только в приватных окнах
user_pref("privacy.trackingprotection.enabled", false);
// Turn on fingerprinters blocking
// Включить блокировку сборщиков цифровых отпечатков
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
// Turn off blocking social trackers (70)
// Выключить блокировку трекеров социальных сетей (70)
// user_pref("privacy.trackingprotection.socialtracking.enabled", false);
// Turn off Firefox starting automatically after Windows 10 restart
// Выключить автоматическое восстановление сеанса после перезапуска Windows 10
user_pref("toolkit.winRegisterApplicationRestart", false);
// Turn on userChrome.css and userContent.css support
// Включить загрузку userChrome.css и userContent.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
