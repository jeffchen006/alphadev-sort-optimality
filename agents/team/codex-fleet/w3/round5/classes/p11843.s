# n=5 model=out iset=I1 prefix14_class=11843
mov S1, P0
cmp P0, P2
cmovle P0, P2
mov S0, P0
cmovl P2, S1
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
cmovle P3, S1
cmp P1, S0
cmovge P0, P1
mov P0, P3
cmovl S0, P1
cmp P2, P0
