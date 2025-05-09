#include <windows.h>
#include <iostream>

void pressKey(char key) {
    // Convert char to virtual keycode
    SHORT vk = VkKeyScan(key);
    INPUT input[2] = {};

    // Key down
    input[0].type = INPUT_KEYBOARD;
    input[0].ki.wVk = vk;

    // Key up
    input[1].type = INPUT_KEYBOARD;
    input[1].ki.wVk = vk;
    input[1].ki.dwFlags = KEYEVENTF_KEYUP;

    // Send input
    SendInput(2, input, sizeof(INPUT));
}

int main() {
    // Open serial port (e.g. COM3)
    HANDLE hSerial = CreateFile(
        "\\\\.\\COM3", // Replace COM3 with your port
        GENERIC_READ,
        0,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL
    );

    if (hSerial == INVALID_HANDLE_VALUE) {
        std::cerr << "Error opening serial port.\n";
        return 1;
    }

    // Configure serial port
    DCB dcbSerialParams = {0};
    dcbSerialParams.DCBlength = sizeof(dcbSerialParams);

    if (!GetCommState(hSerial, &dcbSerialParams)) {
        std::cerr << "Failed to get COM state.\n";
        return 1;
    }

    dcbSerialParams.BaudRate = CBR_9600;
    dcbSerialParams.ByteSize = 8;
    dcbSerialParams.StopBits = ONESTOPBIT;
    dcbSerialParams.Parity   = NOPARITY;

    if (!SetCommState(hSerial, &dcbSerialParams)) {
        std::cerr << "Failed to set COM state.\n";
        return 1;
    }

    char incomingByte;
    DWORD bytesRead;

    std::cout << "Listening on COM3...\n";

    while (true) {
        if (ReadFile(hSerial, &incomingByte, 1, &bytesRead, NULL) && bytesRead > 0) {
            std::cout << "Received: " << incomingByte << "\n";
            if (incomingByte == 'w') {
                pressKey('w');
            }
        }
    }

    CloseHandle(hSerial);
    return 0;
}
