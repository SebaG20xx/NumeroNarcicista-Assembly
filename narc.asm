.MODEL SMALL
.STACK
.DATA
        number          dw  ?
        digits          dw  ?
        sum             dw  ?
        cuttingNum      dw  ?
        insertNumber    db  "Inserte el numero aqui $"
        narcissistic    db  "Es de Armstrong$"
        notNarcissistic db  "No es de Armstrong$"
        
.CODE
MAIN PROC
  mov ax,@DATA
  mov ds,ax
  
  
  mov ah, 09h
  mov dx, offset insertNumber
  int 21h
 
 ; obtener número decimal
  mov bx, 0
inputNum:

  ; recibir input
  mov ah, 01h
  int 21h
  
  ; revisa si el último caracter termina la linea, en ese caso cierra el input
  cmp al,0dh
  je endInput
  
  ; en caso contrario convierte el caracter en dígito
  mov ch, 0
  mov cl, al
  sub cl, 30h
  
  ; multiplica el número por 10 y agrega el siguiente dígito
  mov ax, bx
  mov dx, 0
  mov bx, 10
  mul bx
  add ax, cx
  
  ; guarda el número y vuelve a reintentar
  mov bx, ax
  jmp inputNum
  
endInput:
  ; guarda el número
  mov number, bx
  mov ax, number
  
; cuenta la cantidad de dígitos del número ingresado
  mov digits, 0         ; cuenta de digitos
  mov bx, 10            ; divisor
  mov dx, 0             ; resto
  
countDigits:
  cmp ax, 0             ; while el numero sea distinto que 0
  je countComplete      ; if el numero es 0, la cuenta está completa
  
  div bx                ; else divide el numero por 10
  mov dx, 0             ; deja el resto en 0
  inc digits            ; aumenta la cuenta de digitos
  jmp countDigits       ; repite por la cantidad de numeros restantes
  
countComplete:

; guarda el numero en la variable cuttingNum 
  mov ax, number
  mov cuttingNum, ax
  mov sum, 0

elevateNarcissistic:
  cmp cuttingNum, 0             ; mientras cuttingNum sea distinto a 0
  je NarcissisticCheck
  
  mov ax, cuttingNum            ; deja a cuttingnum de dividendo
  mov dx, 0                     ; deja el resto en 0
  mov bx, 10                    ; deja el divisor en 10
  div bx                        ; divide cuttingNum por el divisor (10)
  mov cuttingNum, ax            ; guarda el nuevo numero
  mov ax, 1                     ; resultado de la potencia
  mov bx, dx                    ; el digito que debe ser potenciado
  mov cx, digits                ; potencia a la que debe ser elevada
  getPower:                     ; obtiene la potencia de un dígito
    mul bx
    loop getPower
  add sum, ax                   ; lo agrega a la suma
  jmp elevateNarcissistic        ; repetir
  
NarcissisticCheck:
  mov ax, number
  mov bx, sum
  cmp ax, bx                    ; revisa si la suma de los numeros es igual al numero
  jne isNotNarcissistic         ; en caso contrario, no es narcisista
  
  ; printear si es narcisista 
  mov ah, 09h
  mov dx, offset narcissistic
  int 21h
  jmp done
  
  ; printear no narcisista 
isNotNarcissistic:
  mov ah, 09h
  mov dx, offset notNarcissistic
  int 21h

  ; finalizar programa
done:
  mov ax,4c00h
  int 21h

MAIN ENDP
END MAIN
