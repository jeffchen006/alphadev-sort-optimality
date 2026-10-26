# n=5 model=out iset=I1 prefix14_class=12119
cmp P3, P2
cmovge S2, P3
cmovg P3, P2
cmovg P2, S2
cmp P0, P1
mov S0, P1
cmovg P1, P0
cmovle S0, P0
cmp S0, P3
cmovle P0, S0
cmovg P0, P3
cmovle S0, P3
cmp P1, P2
cmovge S2, P1
