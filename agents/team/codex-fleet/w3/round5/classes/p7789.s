# n=5 model=out iset=I1 prefix14_class=7789
mov S0, P1
mov S1, P2
cmp P2, P0
cmovl S1, P0
cmovge P2, P0
cmp S0, P3
cmovl S0, P3
cmovge P1, P3
mov P3, P1
cmp P2, P3
cmovle P3, P2
cmovg P1, P2
cmp S1, S0
cmovl P3, S1
