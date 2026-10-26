# n=5 model=out iset=I1 prefix14_class=8809
mov S2, P0
cmp S2, P1
cmovl P0, P1
cmovle P1, S2
mov S1, P3
cmp P2, P3
cmovge S1, P2
cmovle P3, P2
cmp S1, P0
cmovge P2, P0
cmovge P0, S1
cmovg S1, P2
cmp P3, P1
cmovle S0, P3
