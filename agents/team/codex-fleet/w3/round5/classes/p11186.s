# n=5 model=out iset=I1 prefix14_class=11186
cmp P3, P2
mov S1, P1
cmovge S0, P2
cmovge P2, P3
cmovg P3, S0
cmp P1, P0
cmovl S1, P0
cmovle P0, P1
cmp P2, S1
cmovge S0, P2
cmovg P2, S1
cmovg S1, S0
cmp P3, P0
mov P1, P3
