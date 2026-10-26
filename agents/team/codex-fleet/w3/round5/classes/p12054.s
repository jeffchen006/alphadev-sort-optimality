# n=5 model=out iset=I1 prefix14_class=12054
cmp P2, P1
mov S1, P1
cmovge P1, P2
mov S2, P1
cmovge P2, S1
mov S0, P3
cmp P3, P0
cmovl P3, P0
cmovg S0, P0
cmp S0, P2
cmovle P0, P2
cmovl P2, S0
cmovl S0, P0
cmp P1, P3
