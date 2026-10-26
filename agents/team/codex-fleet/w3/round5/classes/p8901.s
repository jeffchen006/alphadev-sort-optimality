# n=5 model=out iset=I1 prefix14_class=8901
mov S1, P3
cmp S1, P2
mov S2, P1
cmovg P3, P2
cmovle S1, P2
cmp P1, P0
cmovge P1, P0
cmovl S2, P0
mov S0, S2
cmp S1, S2
cmovge S0, S1
cmovle S2, S1
cmp P1, P3
cmovle S1, P3
