# n=5 model=out iset=I1 prefix14_class=11634
mov S2, P3
cmp P1, P0
cmovle S1, P1
cmovle P1, P0
cmovg S1, P0
cmp P3, P2
cmovge S2, P2
cmovg P2, P3
mov S0, P1
cmp S0, P2
cmovle P1, P2
cmovge S0, P2
cmp S1, S2
cmovg P1, S2
