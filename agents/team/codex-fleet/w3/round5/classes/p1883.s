# n=5 model=out iset=I1 prefix14_class=1883
mov S0, P2
mov S1, P0
cmp P1, S0
cmovl S0, P1
cmovle P1, P2
mov S2, P1
cmp P3, P0
cmovge P0, P3
cmovl S1, P3
cmp P0, S2
cmovl S2, P0
cmovle P0, P1
cmovle P1, S2
mov P0, S0
