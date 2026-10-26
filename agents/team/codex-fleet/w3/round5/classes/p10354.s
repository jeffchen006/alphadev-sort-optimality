# n=5 model=out iset=I1 prefix14_class=10354
cmp P2, P3
mov S0, P2
cmovle S0, P3
cmovg P2, P3
cmp P1, P0
cmovg P3, P0
cmovg P0, P1
cmovg P1, P3
mov S1, P0
cmp S0, P0
cmovle P0, S0
cmovge S1, S0
cmp P2, P1
cmovge S0, P2
