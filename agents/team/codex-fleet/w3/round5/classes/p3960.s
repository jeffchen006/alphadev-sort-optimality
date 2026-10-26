# n=5 model=out iset=I1 prefix14_class=3960
mov S0, P3
mov S2, P2
cmp S0, P0
cmovl S0, P0
cmovle P0, P3
cmovge P3, P0
cmp P2, P1
cmovl P2, P1
cmovle P1, S2
cmp P1, P3
cmovg P3, P1
cmovl P0, P1
cmp P2, S0
mov P0, P3
