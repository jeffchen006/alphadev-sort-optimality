# n=5 model=out iset=I1 prefix14_class=12493
cmp P2, P1
mov S0, P1
mov S1, P0
cmovge P1, P2
cmovl S0, P2
cmp P3, P0
cmovle P0, P3
cmovle P3, S1
cmp P0, S0
mov S1, P1
cmovge S2, S0
cmovge S0, P0
cmovg P0, S2
cmp P3, S1
