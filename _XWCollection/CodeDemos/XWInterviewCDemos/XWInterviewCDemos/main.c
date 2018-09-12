//
//  main.c
//  XWInterviewCDemos
//
//  Created by 邱学伟 on 2018/7/16.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#include <stdio.h>

///// 字符串反转
//void  char_reverse  (char *cha) {
//    // 定义头部指针
//    char *begin = cha;
//    // 定义尾部指针
//    char *end = cha + strlen(cha) -1;
//    while (begin < end) {
//        char temp = *begin;
//        *(begin++) = *end;
//        *(end--) = temp;
//    }
//}

//int main(int argc, const char * argv[]) {
//    //    char ch[] = "\n Qiu xue wei";
//    //    char_reverse (ch);
//    //    // 有兴趣的可以验证
//    //    printf ("%s",ch);
//}

int fun(int arr[], int n) {
    int x = arr[0];
    for (int i = 0; i < n;i++) {
        x = x ^ arr[i];
        printf("**** x - %d *** i - %d *****\n",x,i);
    }
    return x;
}
int main(int argc, const char * argv[]) {
    int arr[13] = {9,12,2,11,2,2,10,9,12,10,9,11,2};
    int a = fun(arr, 13);
    printf("****  %d *****\n",a);
    return 0;
}
