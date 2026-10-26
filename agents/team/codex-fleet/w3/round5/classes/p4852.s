# n=5 model=out iset=I1 prefix14_class=4852
mov S0, P0
cmp S0, P3
cmovl S0, P3
cmovg P0, P3
mov S1, P0
mov P3, P1
cmp P2, P1
cmovge P3, P2
cmovle P1, P2
cmp P0, P1
cmovle P0, P1
cmovl P1, S1
cmp P3, S0
cmovl P1, P3
