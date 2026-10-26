# n=5 model=out iset=I1 prefix14_class=1681
cmp P1, P3
mov S1, P3
cmovge P3, P1
mov S0, P2
cmovl S1, P1
cmp P2, P0
cmovge S0, P0
cmovg P0, P2
cmovge P2, S0
cmp P2, S1
cmovle P2, S1
cmovg S0, S1
cmp P0, P3
cmovge P1, P3
