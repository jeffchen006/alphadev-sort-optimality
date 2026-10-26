# n=5 model=out iset=I1 prefix14_class=3941
mov S0, P3
cmp P1, P3
cmovl S0, P1
cmovg P3, P1
mov P1, P2
cmp P1, P0
cmovle P2, P0
cmovl P0, P1
cmovge P1, P0
cmp S0, P1
cmovg P0, S0
cmovle P1, S0
cmp P3, P2
mov S0, P3
