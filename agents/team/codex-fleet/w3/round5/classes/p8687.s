# n=5 model=out iset=I1 prefix14_class=8687
mov S2, P2
cmp P0, S2
cmovg P2, P0
mov S1, P1
cmovle S2, P0
cmp S1, P3
cmovg P1, P3
cmovle S1, P3
cmp S1, P2
mov S0, P2
cmovge S0, S1
cmovl P2, S1
cmp P1, S2
cmovge P0, P1
