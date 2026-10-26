# n=5 model=out iset=I1 prefix14_class=11716
mov S0, P2
cmp P3, P0
mov S2, P0
cmovge S2, P3
cmovle P0, P3
cmp P1, P2
cmovg S0, P1
cmovg P1, P2
cmp S0, S2
cmovg S1, S2
cmovg S2, S0
cmovle S1, S0
cmp P1, P0
cmovge S2, P1
