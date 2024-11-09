![Installers (2)](https://github.com/user-attachments/assets/68b37a6b-c826-4a2d-95b5-2502c773bcc5)

# SetupBuilder
**SetupBuilder** is a fast, Flutter-based Windows installer creator optimized for large files like games. It offers an easy-to-understand configuration and extensive customization options, allowing you to quickly create efficient and personalized installers for your big applications.

## Getting Started
Follow these steps to build "**SetupBuilder**" on your local machine.

- Clone the repository
```
git clone https://github.com/ArtemTolochyn/SetupBuilder
```
```
cd SetupBuilder
```

- Get dependencies
```
flutter pub get
```

- Build
```
flutter build windows --release
```

## Customization
You can easily customize the appearance of your installer in the prebuilt config file.
- lib/config/theme_config.dart

## Configuration
You can easily configure your installer in the prebuilt config file.
- lib/config/installer_config.dart

## How to Make a Bundle with Files to Install
1. Make a file structure like in the "**bundle_example**" folder.
2. Place the files of your program that can be installed anywhere into the **{content}** folder.
3. Place into the **{hardcode}** folder the files that will be hardcoded to an exact folder on **DRIVE C**.
4. In the **{hardcode}** folder, you can use a folder named **{user}**; any folder with that name will be renamed to the **USERNAME OF CURRENT USER**.
5. Make a **TAR** file with these two folders, **{content}** and **{hardcode}**. These folders **MUST BE FIRST** in the folder tree in the archive.
6. The archive must be without any compression, just a **TAR FILE**!
7. Rename the archive from **{archive_name}.tar** to **bundle.qam**.
8. Put the archive into the **data** folder in the **compiled installer**.

## Advice
After building, Flutter creates two files, **setup.exp** and **setup.lib**. You can remove them; they're unnecessary.
