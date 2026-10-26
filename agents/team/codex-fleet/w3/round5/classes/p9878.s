# n=5 model=out iset=I1 prefix14_class=9878
mov S2, P1
cmp P1, P2
cmovge P1, P2
cmovg P2, S2
cmp P0, P3
cmovl S1, P3
cmovge S1, P0
mov S2, P2
cmovle P3, P0
cmp S1, S2
cmovge P2, S1
cmovge S1, S2
cmp P3, P1
cmovle S0, P1
