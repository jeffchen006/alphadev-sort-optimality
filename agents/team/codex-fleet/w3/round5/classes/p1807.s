# n=5 model=out iset=I1 prefix14_class=1807
mov S1, P3
cmp P2, P3
cmovge P3, P2
mov S0, P1
cmovge P2, S1
cmp P0, P1
cmovge P1, P0
cmovge P0, S0
cmp P3, P1
cmovge S1, P1
cmovl S1, P3
cmovle P3, P1
cmp P0, P2
cmovg S2, P2
