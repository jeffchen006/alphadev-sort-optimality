# n=5 model=out iset=I1 prefix14_class=9926
mov S2, P3
cmp P0, S2
cmovg S2, P0
cmovge P0, P3
cmp P2, P1
cmovl S1, P2
mov S0, S2
cmovle P2, P1
cmovl P1, S1
cmp S0, P2
mov P3, P0
cmovg S2, P2
cmovl S0, P2
cmp P3, P1
