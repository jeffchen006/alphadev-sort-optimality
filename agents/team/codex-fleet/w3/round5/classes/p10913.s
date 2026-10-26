# n=5 model=out iset=I1 prefix14_class=10913
cmp P3, P1
mov S0, P3
cmovle S0, P1
cmovle P1, P3
mov P3, P2
cmp P3, P0
cmovl P3, P0
cmovl P0, P2
cmp P3, S0
cmovle P2, P3
cmovle P3, S0
cmovl S0, P2
cmp P1, P0
cmovle P2, P0
