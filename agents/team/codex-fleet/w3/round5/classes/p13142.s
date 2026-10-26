# n=5 model=out iset=I1 prefix14_class=13142
cmp P0, P3
mov S1, P0
cmovle P0, P3
cmovg S1, P3
cmp P2, P1
cmovle S2, P2
cmovl P2, P1
cmovg S2, P1
cmp S1, S2
cmovge P3, S1
cmovge S1, S2
cmovge S2, P3
mov S1, P0
cmp S1, P2
