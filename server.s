.intel_syntax noprefix
.globl _start

.section .text

_start:
    mov rax, 41    
    mov rdi, 2     
    mov rsi, 1      
    mov rdx, 0    
    syscall

    mov rdi, rax
    xor rax,rax    
    mov eax, 0    
    push rax
    mov ax, 0x5000 
    push ax
    mov ax, 2     
    push ax 
    mov rsi, rsp     
    mov rax, 49     
    mov rdx, 16
    syscall

    mov rax, 50     
    xor rsi, rsi
    syscall

    mov rax, 43     
    xor rdx, rdx 
    syscall

    push rax        
    mov rdi, rax    
    mov rsi, offset buffer
    mov rdx, 1000
    mov rax, 0
    syscall

    mov rdi, offset path
    mov rcx, 30
extract_pathname:
    mov rdx, 0           
    mov r8, 0            
next_char:
    mov al, byte [rsi]   
    cmp al, ' '          
    je check             
    cmp r8, 0
    je skip
    jmp add
check:
    inc r8
    cmp r8, 2
    je end_extraction
    cmp r8, 1
    je skip
    jmp end_extraction

skip:
    inc rsi               
    jmp next_char
add:
    mov [rdi + rdx], al 
    inc rsi              
    inc rdx               
    cmp rdx, rcx         
    je end_extraction   
    cmp al, 0            
    je end_extraction    
    jmp next_char         
end_extraction:
    mov byte ptr [rdi + rdx], 0  
    jmp open

open:
    mov rax, 2     
    mov rdi, offset path
    mov rsi, 0
    syscall



    push rax      
    mov rdi, rax
    mov rax, 0    
    mov rsi, offset buffer
    mov rdx, 1000
    syscall


    pop rdi         
    mov r8,rax     
    mov rax, 3     
    syscall


    pop rdi        
    mov rsi, offset response
    mov rdx, 19
    mov rax, 1          
    syscall

    mov rsi, offset buffer
    mov rdx, r8          
    mov rax, 1          
    syscall



    mov rax, 3      
    syscall

    mov rdi, 0    
    mov rax, 60
    syscall
.section .data
buffer: .space 1000
path: .space 30
response: .string "HTTP/1.0 200 OK\r\n\r\n"
