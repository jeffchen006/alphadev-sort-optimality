# n=5 model=out iset=I1 prefix14_class=9676
mov S2, P2
cmp P0, P2
mov S0, P3
cmovl S2, P0
cmovle P0, P2
cmp P3, P1
cmovl S0, P1
cmovl P1, P3
cmp S0, P0
cmovge P2, P0
cmovge P0, S0
cmovg S0, P2
mov P3, S2
cmp S2, P1
