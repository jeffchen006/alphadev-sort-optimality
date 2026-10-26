# n=5 model=out iset=I1 prefix14_class=3086
mov S1, P1
cmp P2, P1
cmovge P1, P2
cmovge P2, S1
cmp P0, P3
cmovge S0, P3
cmovl S0, P0
cmovle P0, P3
cmp P2, S0
cmovge S1, P2
cmovge P2, S0
cmovle S1, S0
mov S0, S1
cmp P1, P0
