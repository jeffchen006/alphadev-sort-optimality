# n=5 model=out iset=I1 prefix14_class=14215
mov S1, P0
cmp P1, P0
cmovl P0, P1
mov S2, P3
cmovle P1, S1
cmp P2, P3
cmovge P3, P2
cmovge P2, S2
cmp P3, P1
cmovl S2, P1
mov S0, P0
cmovl P1, P3
cmovl P3, S2
cmp S0, P2
