# n=5 model=out iset=I1 prefix14_class=3256
mov S1, P3
cmp P3, P2
cmovl S1, P2
mov S2, P1
cmovg P3, P2
cmp P0, S2
cmovge P1, P0
mov S0, P3
cmovge P0, S2
cmp P3, P0
cmovg S0, P0
cmovge P0, P3
cmovle P3, P0
cmp P1, S1
