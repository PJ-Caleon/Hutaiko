import serial
from pynput.keyboard import Controller

keyboard = Controller()
ser = serial.Serial('COM3', 9600)  # Replace with your port

while True:
    if ser.in_waiting:
        key = ser.readline().decode().strip()
        if key == 'w':
            keyboard.press('w')
            keyboard.release('w')

