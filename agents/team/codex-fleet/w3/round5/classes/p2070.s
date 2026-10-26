# n=5 model=out iset=I1 prefix14_class=2070
cmp P1, P3
mov S1, P0
cmovle S2, P3
cmovl P3, P1
cmovg S2, P1
cmp S1, P2
cmovge S1, P2
cmovge P2, P0
mov P0, S2
cmp S2, P2
cmovg P0, P2
cmovle S2, P2
mov S2, P3
cmp S2, S1
