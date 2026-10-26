# n=5 model=out iset=I1 prefix14_class=3745
mov S0, P1
cmp P3, S0
cmovl S0, P3
cmovge P1, P3
cmp P2, P0
cmovge S2, P0
mov P3, S0
cmovg P0, P2
cmovge P2, S2
cmp P2, S0
cmovle P3, P2
cmovg S0, P2
mov P3, P0
cmp P0, P1
