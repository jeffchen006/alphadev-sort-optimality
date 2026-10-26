# n=5 model=out iset=I1 prefix14_class=1345
cmp P1, P2
mov S1, P0
mov S0, P2
cmovle S0, P1
cmovg P2, P1
cmp P3, P0
cmovle S1, P3
mov S2, P2
cmovg P0, P3
cmp P0, S2
cmovge S2, P0
mov S2, S1
cmovle P2, P0
cmp S1, S0
