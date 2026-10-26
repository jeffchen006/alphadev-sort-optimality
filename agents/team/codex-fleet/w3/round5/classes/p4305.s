# n=5 model=out iset=I1 prefix14_class=4305
mov S2, P2
cmp S2, P0
cmovge P2, P0
cmovl S2, P0
cmp P1, P3
mov S0, P1
cmovle P1, P3
cmovg S0, P3
mov P0, P1
cmp S0, P2
cmovl P3, S0
cmovl S0, P2
cmovl P2, P3
cmp S2, P1
