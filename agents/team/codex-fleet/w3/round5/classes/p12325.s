# n=5 model=out iset=I1 prefix14_class=12325
mov S0, P3
cmp P3, P2
cmovge S0, P2
cmovg P2, P3
cmp P1, P0
cmovge P3, P1
cmovle P3, P0
cmovle P0, P1
cmp S0, P0
cmovle P1, P0
cmovg P1, S0
cmovge S0, P0
cmp P3, P2
cmovle S0, P2
