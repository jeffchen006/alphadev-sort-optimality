# n=5 model=out iset=I1 prefix14_class=14092
mov S1, P1
cmp S1, P2
cmovle S1, P2
cmovl P2, P1
mov S2, P2
mov S0, P3
cmp P0, S0
cmovl S0, P0
cmovge P3, P0
cmp S1, P3
cmovle P1, P3
cmovle P3, S1
cmovl S1, P1
cmp S0, S2
