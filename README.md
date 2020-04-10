# Zowe Flutter Application
This is a Flutter project with Provider state management that allows interaction with Z (mainframe) on your mobile phone. It consumes Zowe REST APIs to achieve that.

You can read the full guide on [[Tutorial]: Interact with z/OS using a mobile device with Zowe and Flutter](https://developer.ibm.com/components/ibmz/tutorials/interacting-with-zos-using-mobile-device-with-zowe-and-flutter) or see below for quick info.

## Requirements
- Flutter
- Access to Zowe (check the guide for details)

## Features
### Data sets
- Filter and display data sets,
- Create data sets,
- Delete data sets,
- Update data sets.

Works only for Sequential and PDS/PDSE formats.

### Jobs
- Display jobs and outputs,
- Purge jobs,
- Submit data sets as jobs.


## Installation

Clone the repository:

```bash
git clone https://github.com/IBM/zowe-flutter-provider.git
```

Change directory:
```bash
cd zowe-flutter-provider
```

Install dependencies:
```bash
flutter pub get
```

Run the app:
```bash
# Make sure you are in the right directory.
# Either run iOS/Android simulator, or connect your mobile device via USB in Debug mode.

flutter run
```

## Help
You can submit issues for the problems you encounter.

