# n=5 model=out iset=I1 prefix14_class=11245
cmp P3, P1
mov S2, P0
cmovle S1, P1
cmovge S1, P3
cmovge P3, P1
cmp S2, P2
cmovge S2, P2
cmovl P0, P2
cmp P0, S1
cmovge P2, S1
cmovge S1, P0
mov S1, P3
cmovg P0, P2
cmp S1, S2
