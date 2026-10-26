# n=5 model=out iset=I1 prefix14_class=7834
cmp P3, P1
cmovge S1, P1
cmovl S1, P3
cmovge P1, P3
mov P3, P0
cmp P3, P2
mov S2, S1
cmovge P0, P2
cmovge P2, P3
cmp P0, S2
cmovle S2, P0
cmovg S1, P0
cmp P1, P2
cmovl S0, P2
