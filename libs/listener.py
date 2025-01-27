# listener.py
ROBOT_LISTENER_API_VERSION = 3

total_elapsed_time = 0

def end_test(data, result):
    global total_elapsed_time
    total_elapsed_time += result.elapsedtime
    print(f'\nStart time: {result.starttime}')
    print(f'End time: {result.endtime}')
    print(f'Elapsed time: {result.elapsedtime} ms')

def close():
    print(f'\nTotal execution time: {total_elapsed_time} ms')
