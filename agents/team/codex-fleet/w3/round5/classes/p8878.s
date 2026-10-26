# n=5 model=out iset=I1 prefix14_class=8878
mov S2, P2
cmp P1, P0
cmovge S1, P0
cmovg P0, P1
cmovge P1, S1
cmp P2, P3
cmovge S2, P3
cmovl P2, P3
mov P3, P2
cmp P0, P3
cmovge P3, P0
cmovge P0, P2
cmp S2, P1
cmovle S0, S2
