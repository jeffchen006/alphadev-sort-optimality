# n=5 model=out iset=I1 prefix14_class=2570
cmp P3, P1
mov S1, P3
cmovge S1, P1
mov S0, P0
cmovge P1, P3
cmp P2, S0
cmovge P0, P2
cmovg P2, S0
cmp P1, P0
cmovge S0, P1
cmovl S0, P0
cmovge P1, P0
cmp P2, S1
cmovle P3, S1
