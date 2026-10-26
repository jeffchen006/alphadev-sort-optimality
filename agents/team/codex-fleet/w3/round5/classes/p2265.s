# n=5 model=out iset=I1 prefix14_class=2265
cmp P0, P1
mov S2, P0
cmovle P0, P1
mov S0, P2
cmovge S2, P1
cmp P3, S0
cmovge S0, P3
cmovg P3, P2
mov S1, S0
cmp S1, P0
cmovle S0, P0
cmovle P0, S1
cmp S2, P3
cmovg P2, S2
