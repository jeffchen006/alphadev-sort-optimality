# n=5 model=out iset=I1 prefix14_class=12015
cmp P3, P0
mov S0, P2
cmovge S1, P3
cmovge P3, P0
cmovge P0, S1
cmp P2, P1
cmovg S0, P1
cmovle P2, P1
cmp S0, P3
mov P1, S0
cmovl S0, P3
cmovl P3, P1
cmp P2, P0
cmovle P3, P0
