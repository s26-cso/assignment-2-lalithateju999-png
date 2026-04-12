#include<stdio.h>
#include<stdlib.h>
#include<dlfcn.h> // for dlopen dlsym, dlclose

int main(){
    char op[10];
    int a,b;
    // keep reading until input is EOF
    while(scanf("%9s %d %d",op,&a,&b)==3){
        char libname[20];
        //create a lib name like './libadd.so'
        sprintf(libname,"./lib%s.so",op);
        void *handle=dlopen(libname,RTLD_LAZY);
        if(handle==NULL){
            printf("%s\n",dlerror()); //if there is any error in opening then it mentions the error
            continue;
        }
        int (*func)(int,int);
        dlerror(); //this clears previous errors
        func=(int (*)(int,int)) dlsym(handle,op);
        char *err=dlerror();
        if(err!=NULL){
            printf("%s\n",err); // checks if any error occured if yes then prints it
            dlclose(handle); //close library
            continue;
        }
        int result=func(a,b);
        printf("%d\n",result);
        dlclose(handle);
    }
    return 0;
}