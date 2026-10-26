# n=5 model=out iset=I1 prefix14_class=7750
mov S2, P1
mov S1, P0
cmp S2, P3
cmovge S2, P3
cmovl P1, P3
cmp S1, P2
cmovle S1, P2
cmovge P0, P2
mov P2, P0
cmp S2, P0
cmovg P0, S2
cmovge S2, P2
cmp S1, P1
cmovge P3, S1
