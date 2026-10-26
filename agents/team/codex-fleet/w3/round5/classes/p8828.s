# n=5 model=out iset=I1 prefix14_class=8828
cmp P1, P3
cmovg S1, P1
cmovle S1, P3
cmovge P1, P3
cmp P2, P0
cmovl S2, P0
cmovle P0, P2
cmovge S2, P2
mov P3, P1
cmp S2, S1
cmovg P2, S2
cmovge S2, S1
mov S0, S2
cmovg S1, P2
