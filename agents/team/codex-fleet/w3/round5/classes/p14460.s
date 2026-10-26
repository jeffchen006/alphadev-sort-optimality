# n=5 model=out iset=I1 prefix14_class=14460
cmp P2, P0
cmovge S1, P0
cmovle S1, P2
mov S2, P3
cmovg P0, P2
cmp S2, P1
cmovle S2, P1
cmovl P1, P3
cmp P1, S1
cmovge P3, P1
cmovg P1, S1
mov S0, S2
cmovg S1, P3
cmp S2, P0
