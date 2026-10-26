# n=5 model=out iset=I1 prefix14_class=1575
cmp P0, P2
cmovge S1, P2
cmovg P2, P0
cmovl S1, P0
mov P0, P3
cmp P1, P3
cmovge P0, P1
cmovle P3, P1
cmp P3, S1
mov S0, S1
cmovle S0, P3
cmovge S1, P3
cmp P2, P0
mov S0, P0
