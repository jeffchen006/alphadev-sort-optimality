# n=5 model=out iset=I1 prefix14_class=1667
cmp P3, P2
cmovge S0, P2
cmovge P2, P3
cmovl S0, P3
mov S2, P2
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmovge P0, S1
cmp P1, S0
cmovle P3, S0
cmovg P3, P1
cmovle S0, P1
cmp P2, P0
