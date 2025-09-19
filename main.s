.intel_syntax noprefix

.code64
.extern printf
.extern malloc
.extern free
.extern SDL_CreateWindow
.extern SDL_CreateRenderer
.extern SDL_DestroyWindow
.extern SDL_DestroyRenderer
.extern SDL_DestroyTexture
.extern SDL_RenderCopy
.extern SDL_PollEvent
.extern SDL_RenderPresent
.extern SDL_RenderClear
.extern SDL_SetRenderDrawColor
.extern SDL_Delay
.extern SDL_GetKeyboardState
.extern SDL_SetHint
.extern SDL_GetWindowSize

.extern IMG_Init
.extern IMG_Load
.extern SDL_CreateTextureFromSurface
.extern SDL_FreeSurface
.extern SDL_Init

.equ SDL_WINDOWPOS_CENTER,805240832
.equ SDL_VINSAN_RENDER_ACCELERATED,2
.equ SDL_RENDER_INDEX_VGLFW,-1
.equ SDL_VIRTUAL_RESIZABLE,32
.equ INIT_VIRTUAL_FRAME_BUFFER,32

.equ SDL_SCANCODE_Q,20
.equ SDL_SCANCODE_1,30

.section .rodata
  L1: .string "OwO"
  L2: .string "Error\n"
  L3: .string "Briankernigan.jpeg"
  L4: .string "linear"
  L5: .string "SDL_RENDER_SCALE_QUALITY"

  FMT: .string "%s\n"
  FMT_S: .string "%s"
  FMT_D: .string "%d\n"

  LS1: .string "witdh = %zu\n"
  LS2: .string "height = %zu\n"

.section .data
  event_t: .skip 56
  window_t: .quad 1 
  renderer_t :.quad 1 
  keystate: .quad 1
  flags_t: .byte 1
  texture_t: .quad 1
  surface_t: .quad 1

.section .text
  .global main

main:

  push rbp
  mov rbp,rsp
  sub rsp,16 * 16

  mov edi,INIT_VIRTUAL_FRAME_BUFFER
  call SDL_Init

  mov edi,1 
  call IMG_Init

  lea rdi,[rip + L1]
  mov esi,SDL_WINDOWPOS_CENTER
  mov edx,SDL_WINDOWPOS_CENTER
  mov ecx,800 
  mov r8d,600 
  mov r9d,SDL_VIRTUAL_RESIZABLE
  call SDL_CreateWindow

  mov [rip + window_t],rax
  cmp rax,0
  je ER1

  mov rdi,[rip + window_t]
  mov esi,-1
  mov edx,2
  call SDL_CreateRenderer

  mov [rip + renderer_t],rax
  cmp rax,0
  je ER1 

  lea rdi,[rip + L5]
  lea rsi,[rip + L4]
  call SDL_SetHint

  lea rdi,[rip + L3]
  call IMG_Load

  mov r13,rax

  mov rdi,[rip + renderer_t]
  mov rsi,r13
  call SDL_CreateTextureFromSurface

  mov QWORD ptr [rip + texture_t],rax

  mov rdi,r13
  call SDL_FreeSurface

  mov QWORD ptr [rbp - 24],1

F01:

  mov rax,QWORD ptr [rbp - 24]
  test rax,rax
  jz S01

F02:

  lea rdi,[rip + event_t]
  call SDL_PollEvent

  cmp DWORD ptr [rip + event_t],0x300
  jne R01

  mov eax,DWORD ptr [rip + event_t + 20]
  cmp eax,'\0'
  je S01

  xor edi,edi
  call SDL_GetKeyboardState
  mov r12,rax

  mov [rip + keystate],rax
  cmp DWORD ptr [rip + event_t],256
  je L01

  movzx eax,BYTE ptr [r12 + SDL_SCANCODE_Q] 
  test eax,eax
  jnz L01

  movzx eax,BYTE ptr [r12 + SDL_SCANCODE_1]
  test eax,eax
  jnz L02

  jmp R01

L01:

  mov QWORD ptr [rbp - 24],0 
  jmp R01

L02:

  mov rdi,[rip + window_t]
  lea rsi,DWORD ptr [rbp - 28]
  lea rdi,DWORD ptr [rbp - 32]
  call SDL_GetWindowSize

  mov edi,DWORD ptr [rbp - 28]
  mov esi,DWORD ptr [rbp - 32]
  call print_size
  jmp R01

R01:
 
  mov rdi,[rip + renderer_t]
  call SDL_RenderClear

  mov rdi,[rip + renderer_t]
  mov esi,0
  mov edx,0
  mov ecx,0
  mov r8d,255
  call SDL_SetRenderDrawColor

  mov rdi,[rip + renderer_t]
  mov rsi,[rip + texture_t]
  xor edx,edx
  xor ecx,ecx
  call SDL_RenderCopy

  mov rdi,[rip + renderer_t]
  call SDL_RenderPresent

  mov edi,16 
  call SDL_Delay

  jmp F01

S01:

  mov rdi,[rip + window_t]
  call SDL_DestroyWindow

  mov rdi,[rip + renderer_t]
  call SDL_DestroyRenderer

  mov rdi,[rip + texture_t]
  call SDL_DestroyTexture

  mov eax,0 
  leave
  ret

ER1:

  lea rdi,[rip + L2]
  xor eax,eax
  call printf

  mov eax,-1
  leave
  ret

print_size:

  push rbp
  mov rbp,rsp
  sub rsp,16

  mov DWORD ptr [rbp - 4],edi
  mov DWORD ptr [rbp - 8],esi 

  lea rdi,[rip + LS1]
  mov esi,DWORD ptr [rbp - 4]
  xor eax,eax
  call printf

  lea rdi,[rip + LS2]
  mov esi,DWORD ptr [rbp - 8]
  xor eax,eax
  call printf

  leave
  ret

