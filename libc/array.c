#include "array.h"

void reverse(s8 *arr, int size) {
    for (int i = 0; i < size / 2; i++) {
        s8 tmp = arr[i];
        arr[i] = arr[size - i - 1];
        arr[size - i - 1] = tmp;
    }
}

void reverse_str(s8 *arr) {
    int size = str_len(arr);
    for (int i = 0; i < size / 2; i++) {
        s8 tmp = arr[i];
        arr[i] = arr[size - i - 1];
        arr[size - i - 1] = tmp;
    }
}

int first_index(s8 *arr, int size, s8 token) {
    for (int i = 0; i < size; i++) {
        if (arr[i] == token) {
            return i;
        }
    }
    return -1;
}

int last_index(s8 *arr, int size, s8 token) {
    for (int i = size - 1; i >= 0; i--) {
        if (arr[i] == token) {
            return i;
        }
    }
    return -1;
}

int str_len(const char *str) {
    char c;
    int i = 0;
    while ((c = str[i++]) != '\0');
    
    return i - 1;
}