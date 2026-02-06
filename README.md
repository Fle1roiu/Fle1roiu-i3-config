# 🐧 Fleiroiu i3wm Config

## **Description / Описание**

**EN:** A custom i3wm configuration tailored for Arch Linux, built with a focus on high-end aesthetics and performance. Featuring advanced dual-kawase blur, deep transparency effects, and a unique integrated Plymouth boot experience. Designed for users who seek a polished, hardware-accelerated workspace.

**RU:** Кастомная конфигурация i3wm для Arch Linux, созданная с упором на эстетику и производительность. Включает продвинутое размытие dual-kawase, эффекты глубокой прозрачности и уникальную интегрированную анимацию загрузки Plymouth. Дизайн для тех, кому нужно отполированное рабочее пространство с аппаратным ускорением.

---

> [!NOTE]
> **EN:** This configuration is currently designed **only for Arch Linux**. Support for other distributions is not guaranteed.
>
> **RU:** На данный момент этот конфиг предназначен **только для Arch Linux**. Работа на других дистрибутивах не гарантируется.

---

## **⌨️ Main Bindings / Основные клавиши**

* <kbd>Super</kbd> + <kbd>Enter</kbd> — Open terminal / Открыть терминал
* <kbd>Super</kbd> + <kbd>d</kbd> — Open menu / Открыть меню
* <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>q</kbd> — Close window / Закрыть окно
* <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>r</kbd> — Restart i3 / Перезагрузить i3
* <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>e</kbd> — Exit i3 / Выйти из системы

---

## **🗔 Workspaces & Windows / Рабочие столы и Окна**

**EN:** Use <kbd>Super</kbd> + <kbd>Number</kbd> to switch between desktops.

**RU:** Используйте <kbd>Super</kbd> + <kbd>Цифра</kbd> для переключения между столами.

* <kbd>Super</kbd> + <kbd>1-9;0</kbd> — Switch workspace / Перейти на рабочий стол
* <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>1-9;0</kbd> — Move window to workspace / Переместить окно на стол
* <kbd>Super</kbd> + <kbd>h</kbd> / <kbd>v</kbd> — Split horizontal/vertical / Разделить по горизонтали/вертикали
* <kbd>Super</kbd> + <kbd>f</kbd> — Toggle fullscreen / Полноэкранный режим
* <kbd>Super</kbd> + <kbd>Space</kbd> — Toggle floating mode / Плавающее окно

---

## **🖱️ Mouse mode / Режим мыши**

**EN:** Activate with <kbd>Super</kbd> + <kbd>g</kbd>. Use <kbd>w</kbd><kbd>a</kbd><kbd>s</kbd><kbd>d</kbd> to move the cursor and <kbd>j</kbd><kbd>k</kbd> for clicks.

**RU:** Активация через <kbd>Super</kbd> + <kbd>g</kbd>. Используйте <kbd>w</kbd><kbd>a</kbd><kbd>s</kbd><kbd>d</kbd> для перемещения курсора и <kbd>j</kbd><kbd>k</kbd> для кликов.

---

## **🚀 Installation / Установка**

### **Step 1: Base System (archinstall) / Шаг 1: Базовая система**

**EN:** Run `archinstall` and follow these specific settings:
**RU:** Запустите `archinstall` и выберите следующие настройки:

1. **Bootloader / Загрузчик:** * Select **GRUB**.
   * Выберите **GRUB**.

2. **Disk Configuration / Диск:**
   * Select configuration: Use a best-effort default partition layout/выберите configuration: Use a best-effort default partition layout
   * Select **Ext4**. 
   * **Important:** Do **NOT** create a separate `/home` partition.
   * **Важно:** Не создавайте отдельный раздел `/home`.

4. **Swap / Подкачка:**
   * **EN:** Set **Swap** to **True** (Enable). It is better for system stability.
   * **RU:** Установите **Swap** в значение **True** (Enable). Это необходимо для стабильной работы системы.

5. **User Account / Пользователь:**
   * Create user and set **Sudo account** to **YES**.
   * Создайте пользователя и установите **Sudo account** на **YES**.

6. **Network Configuration / Сеть:**
   * Select **Use Network Manager**
   * Выберите **Use Network Manager**

7. **Profile / Профиль:**
   * Select Profile type **Desktop** -> **i3-wm**.

8. **Graphics Driver / Видеодрайверы:**
   * **EN:** It is CRITICAL to choose the right driver for your hardware:
   * **RU:** КРИТИЧЕСКИ важно выбрать правильный драйвер:
     * **NVIDIA:** Select `nvidia`
     * **Intel:** Select `Intel`

 ### **Step 2: Apply Config / Шаг 2: Применение конфига**
 
**EN:** After rebooting, log in to your new system, open a terminal, and run these commands:

**RU:** После перезагрузки войдите в систему, откройте терминал и выполните следующие команды:

sudo pacman -S git

git clone **https://github.com/Fleiroiu/Fleiroiu-i3-config**

cd ~/Fleiroiu-i3-config

chmod +x install.sh && ./install.sh

___

### **Sreenshots:**

![Desktop_260203_1716](https://github.com/user-attachments/assets/68a4c0d6-9c0e-4761-81bd-c92aa136caa5)

![Desktop_260203_1816](https://github.com/user-attachments/assets/c0857534-b1bd-40ec-b582-c466189d46e7)

![Desktop_260203_1736](https://github.com/user-attachments/assets/d54b9f8c-425b-49cb-9856-a7823f002d13)

___

### **👤 Author / Автор**

**EN:** Created and maintained by **Fle1roiu**.

**RU:** Создатель и разработчик — **Fle1roiu**.
