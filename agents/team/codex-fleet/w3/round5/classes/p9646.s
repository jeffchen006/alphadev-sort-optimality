# n=5 model=out iset=I1 prefix14_class=9646
mov S2, P1
cmp P2, S2
mov S1, P3
cmovle S2, P2
cmovg P1, P2
cmp P3, P0
cmovl S1, P0
cmovg P3, P0
cmp P1, S1
mov S0, S1
cmovl S1, P1
cmovge S0, P1
cmp S2, P3
cmovge P2, S2
